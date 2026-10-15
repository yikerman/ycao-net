#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["用 Autotools 和 C 造轮子" "2020-08-08" #:lang "zh"]{
    @para{
      这篇操作指南会教你如何用 Autotools 和 C 造轮子。
      注意，它并不详尽，只是想让你大致了解整个系统如何运作。
    }

    @heading["introduction"]{引言}

    @para{@bold{要求}}
    @para{我的 Autotools 版本如下：}
    @ul{
      @item{Automake 1.16.1}
      @item{Autoconf 2.69}
      @item{Libtool 2.4.6}
    }
    @para{我使用的系统是 OS X。这里不包含安装指南。}

    @para{@bold{成品}}
    @para{
      我们会做一个简单的 C 库（兼容 C++），名为 @code{libts}，用来帮你得到
      两次函数调用之间的时间间隔。
    }

    @heading["procedures"]{步骤}
    @para{该真正动手做点东西了！}

    @para{@bold{一个简单的库}}
    @para{
      项目起初很简单，只有一个头文件和一个源文件：
    }
    @code-block["plaintext"]|{
.
├── ts.c
└── ts.h

0 directories, 2 files
}|
    @para{代码如下：}
    @para{@code{ts.h}}
    @code-block["c"]|{
#ifndef __TS_H__
#define __TS_H__

#include <sys/time.h>
#include "config.h" /* This file will be generated later */

/* For C++ compatiblity */
#ifdef __cplusplus
extern "C" {
#endif

#define FIRST_CALL -1.0

/*
* Returns the time passed in seconds before the latest call.
* If it's the first time called, return FIRST_CALL.
*/
extern double getTimeDuration(void);

/* End of the extern "C" above */
#ifdef __cplusplus
}
#endif

#endif /* __TS_H__ */
}|
    @para{@code{ts.c}}
    @code-block["c"]|{
#include "ts.h"

double getTimeDuration()
{
    static double latest = 0; /* Last call */
    double sec; /* Current time in second */
    double ret; /* Return value */

    #if HAVE_GETTIMEOFDAY /* This macro comes from config.h */

    /* In some specific OS, gettimeofday() is available */
    /* See https://man7.org/linux/man-pages/man2/gettimeofday.2.html */

    struct timeval tv;
    gettimeofday(&tv, NULL);
    sec = tv.tv_sec;
    sec += tv.tv_usec / 1000000.0;

    #else /* HAVE_GETTIMEOFDAY */

    /* Or we can use time() instead. */

    sec = time(NULL);

    #endif /* HAVE_GETTIMEOFDAY */

    ret = sec - latest; /* Calculate difference */
    latest = sec; /* Update latest */
    if (ret == sec) /* First call, return special value */
        return FIRST_CALL;
    else
        return ret;
}
}|
    @para{源码写完了。来设置 Autotools 吧！}

    @para{@bold{Autotools}}
    @para{
      Autotools 是个复杂的构建系统。我们得创建好几个文件。
    }
    @para{@it{注意：以下命令都在源码根目录下运行。}}

    @para{@bold{@code{configure.ac}}}
    @para{
      @bold{@code{configure.ac} 是给 @code{Autoconf} 用来生成 @code{configure}
      脚本的文件。它负责检查可用性（在我们的例子里，就是 @code{gettimeofday()}
      和 @code{time()} 是否可用），并从稍后才会生成的 @code{Makefile.in} 生成
      @code{Makefile}。}
    }
    @para{
      先从 GNU 提供的 @code{autoscan} 开始。它会扫描你的代码，并自动生成
      @code{configure.ac}。
    }
    @code-block["bash"]|{autoscan}|
    @para{目录应当像这样：}
    @code-block["plaintext"]|{
.
├── autoscan.log
├── configure.scan
├── ts.c
└── ts.h

0 directories, 4 files
}|
    @para{
      @code{autoscan.log} 可以放心删除。要紧的是 @code{configure.scan}。我们得先把它重命名为
      @code{configure.ac}：
    }
    @code-block["bash"]|{
rm -f autoscan.log
mv configure.scan configure.ac
}|
    @para{@code{configure.ac} 看起来像这样：}
    @code-block["bash"]|{
#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.69])
AC_INIT([FULL-PACKAGE-NAME], [VERSION], [BUG-REPORT-ADDRESS])
AC_CONFIG_SRCDIR([ts.c])
AC_CONFIG_HEADERS([config.h])

# Checks for programs.
AC_PROG_CC

# Checks for libraries.

# Checks for header files.
AC_CHECK_HEADERS([sys/time.h])

# Checks for typedefs, structures, and compiler characteristics.

# Checks for library functions.
AC_CHECK_FUNCS([gettimeofday])

AC_OUTPUT
}|
    @para{
      它其实是一段 @link["https://www.gnu.org/software/m4/m4.html"]{m4}
      语言；那些 @code{AC_XXX} 之类都是宏，会被展开成 Bash 脚本。你也可以直接在
      @code{configure.ac} 里写 Bash。
    }
    @para{
      如你所见，加入 @code{AC_CHECK_FUNCS([gettimeofday])} 很聪明。它会检查
      @code{gettimeofday} 是否可用。神奇！不过，我们无论如何都得改一改。
    }
    @code-block["bash"]|{
#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.69]) # 1
AC_INIT([libts], [0.1], [username@example.com]) # 2
AC_CONFIG_SRCDIR([ts.c]) # 3
AC_CONFIG_HEADERS([config.h]) # 4

AM_INIT_AUTOMAKE # Modified 5

# Checks for programs.
AC_PROG_CC # 6

# Checks for libraries.

# Checks for header files.
AC_CHECK_HEADERS([sys/time.h]) # 7

# Checks for typedefs, structures, and compiler characteristics.

# Checks for library functions.
AC_CHECK_FUNCS([gettimeofday]) # 8

LT_INIT # Modified 9
AC_CONFIG_FILES([Makefile]) # Modified 10

AC_OUTPUT # 11
}|
    @ul{
      @item{1：检查 @code{autoconf} 的最低版本。}
      @item{2 和 11：每个 @code{configure.ac} 的开头和结尾。它还包含一些项目信息。}
      @item{3：检查源码是否存在。}
      @item{4：生成名为 @code{config.h} 的配置头文件。}
      @item{5：为生成 @code{Makefile} 做准备。}
      @item{6：确定要使用的 C 编译器。}
      @item{7：检查头文件 @code{sys/time.h} 是否可用。}
      @item{8：检查函数 @code{gettimeofday} 是否可用。}
      @item{9：初始化 Libtool。后面会用到。}
      @item{10：从稍后生成的 @code{Makefile.in} 生成 @code{Makefile}。}
    }
    @para{要生成 @code{configure} 文件：}
    @code-block["bash"]|{
aclocal
autoconf
autoheader
}|
    @para{你的项目会变成这样：}
    @code-block["plaintext"]|{
.
├── aclocal.m4
├── autom4te.cache
│   ├── output.0
│   ├── output.1
│   ├── output.2
│   ├── output.3
│   ├── requests
│   ├── traces.0
│   ├── traces.1
│   ├── traces.2
│   └── traces.3
├── config.h.in
├── configure
├── configure.ac
├── ts.c
└── ts.h
}|

    @para{@bold{@code{Makefile.am}}}
    @para{
      @code{Makefile.am} 是给 @code{automake} 用来生成前面提到的
      @code{Makefile.in} 的文件。现在创建 @code{Makefile.am}，写入以下内容：
    }
    @code-block["makefile"]|{
AUTOMAKE_OPTIONS = foreign
include_HEADERS=ts.h
lib_LTLIBRARIES = libts.la
libts_la_SOURCES=ts.c
}|
    @para{
      构建目标是 @code{libts.la}，其中包含源文件 @code{ts.c}，并借助
      @code{Libtool} 来保持可移植性。这比 @code{configure.ac} 简单。
    }
    @para{
      另外注意，@code{AUTOMAKE_OPTIONS} 设成了 @code{foreign}，所以不会强迫我们创建
      @code{NEWS}、@code{AUTHOR}、@code{ChangeLog} 等文件。
    }
    @para{要生成 @code{Makefile.in}，运行：}
    @code-block["bash"]|{
libtoolize # Generate supporting files for Libtool
automake --add-missing
}|

    @para{@bold{测试}}
    @para{
      测试总是需要的。我们按 Autotools 的方式来。先创建 @code{test.c}：
    }
    @code-block["c"]|{
#include "ts.h"
#include <assert.h>
#include <stdio.h>

/* Program exits with 0 means tests has passed */
int main(int args, char *argv[])
{
    double first = getTimeDuration();
    assert(first == FIRST_CALL);
    double second = getTimeDuration();
    assert(second != FIRST_CALL);
    puts("OK");
    return 0;
}
}|
    @para{你也可以使用现代测试框架。}
    @para{@code{Makefile.am}：}
    @code-block["makefile"]|{
# Lib
AUTOMAKE_OPTIONS = foreign
include_HEADERS=ts.h
lib_LTLIBRARIES = libts.la
libts_la_SOURCES=ts.c

# Tests
TESTS = checkTS
check_PROGRAMS = checkTS
checkTS_SOURCES = test.c
checkTS_LDFLAGS = libts.la
}|
    @para{另外，如果你不想再敲上面那些 @code{aclocal} 之类的东西：}
    @code-block["bash"]|{autoreconf -i}|

    @para{@bold{配置与构建}}
    @para{很简单！现在一切就绪。照常做：}
    @code-block["bash"]|{
./configure
make
}|
    @para{要安装：}
    @code-block["bash"]|{sudo make install}|
    @para{要测试：}
    @code-block["bash"]|{make check}|
    @para{要制作发行包：}
    @code-block["bash"]|{make dist}|
    @para{
      哇，你做到了！要在自己的程序里使用这个库，只需
      @code{#include <ts.h>} 并链接这个库（@code{-lts}）！
    }

    @para{@bold{成品}}
    @para{
      这个演示的发行包可以在
      @link["/files/20200808/libts-0.1.tar.gz"]{这里} 找到。
    }
  })

(provide post)