#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["用 Autotools 和 C 语言造轮子" "2020-08-08" #:lang "zh"]{
    @para{
      这篇指南会教你如何用 Autotools 和 C 语言造轮子。内容不算详尽，旨在帮你了解整套系统的运作方式。
    }

    @heading["introduction"]{简介}

    @para{@bold{环境要求}}
    @para{我使用的 Autotools 版本如下：}
    @ul{
      @item{Automake 1.16.1}
      @item{Autoconf 2.69}
      @item{Libtool 2.4.6}
    }
    @para{我的操作系统是 OS X，本文不包含安装指南。}

    @para{@bold{成品}}
    @para{
      我们要写一个简单的 C 语言库（兼容 C++），名为 @code{libts}，用来获取两次函数调用之间的时间间隔。
    }

    @heading["procedures"]{步骤}
    @para{是时候动手做点东西了！}

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
    @para{源代码写好了，接下来配置 Autotools！}

    @para{@bold{Autotools}}
    @para{
      Autotools 是一套复杂的构建系统，我们需要创建好几个文件。
    }
    @para{@it{注意：以下命令均在源代码根目录下运行。}}

    @para{@bold{@code{configure.ac}}}
    @para{
      @bold{@code{Autoconf} 会根据 @code{configure.ac} 生成 @code{configure} 脚本。该脚本用于检查系统环境（在本例中，是检查 @code{gettimeofday()} 和 @code{time()} 是否可用），并根据稍后生成的 @code{Makefile.in} 生成最终的 @code{Makefile}。}
    }
    @para{
      我们先从 GNU 提供的 @code{autoscan} 开始。它会扫描代码并自动生成 @code{configure.ac}。
    }
    @code-block["bash"]|{autoscan}|
    @para{此时的目录结构应该如下所示：}
    @code-block["plaintext"]|{
.
├── autoscan.log
├── configure.scan
├── ts.c
└── ts.h

0 directories, 4 files
}|
    @para{
      @code{autoscan.log} 可以放心删掉。重要的是 @code{configure.scan}，我们先把它重命名为 @code{configure.ac}：
    }
    @code-block["bash"]|{
rm -f autoscan.log
mv configure.scan configure.ac
}|
    @para{@code{configure.ac} 的内容如下：}
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
      这其实是一段 @link["https://www.gnu.org/software/m4/m4.html"]{m4} 语言代码，里面所有的 @code{AC_XXX} 都是宏，最终会展开成 bash 脚本。你也可以直接在 @code{configure.ac} 里写 bash 代码。
    }
    @para{
      如你所见，它很聪明地加上了 @code{AC_CHECK_FUNCS([gettimeofday])}，用来检查 @code{gettimeofday} 是否可用。真神奇！不过，我们还是得手动修改一下。
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
      @item{1：检查 @code{autoconf} 的最低版本要求。}
      @item{2 & 11：每个 @code{configure.ac} 必备的开头和结尾，其中还包含项目的基本信息。}
      @item{3：检查指定的源代码文件是否存在。}
      @item{4：生成名为 @code{config.h} 的配置头文件。}
      @item{5：为生成 @code{Makefile} 做准备。}
      @item{6：确定要使用的 C 编译器。}
      @item{7：检查头文件 @code{sys/time.h} 是否可用。}
      @item{8：检查函数 @code{gettimeofday} 是否可用。}
      @item{9：初始化 Libtool，稍后会用到。}
      @item{10：根据稍后生成的 @code{Makefile.in} 生成 @code{Makefile}。}
    }
    @para{接着生成 @code{configure} 文件：}
    @code-block["bash"]|{
aclocal
autoconf
autoheader
}|
    @para{此时项目结构如下：}
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
      @code{automake} 会根据 @code{Makefile.am} 生成前面提到的 @code{Makefile.in}。现在创建 @code{Makefile.am} 并写入以下内容：
    }
    @code-block["makefile"]|{
AUTOMAKE_OPTIONS = foreign
include_HEADERS=ts.h
lib_LTLIBRARIES = libts.la
libts_la_SOURCES=ts.c
}|
    @para{
      这里的构建目标是 @code{libts.la}，包含源文件 @code{ts.c}，它借助 @code{Libtool} 来保证跨平台兼容性。这个文件比 @code{configure.ac} 简单多了。
    }
    @para{
      另外请注意，@code{AUTOMAKE_OPTIONS} 设为了 @code{foreign}，这样它就不会强制要求我们创建 @code{NEWS}、@code{AUTHOR}、@code{ChangeLog} 等文件了。
    }
    @para{运行以下命令来生成 @code{Makefile.in}：}
    @code-block["bash"]|{
libtoolize # Generate supporting files for Libtool
automake --add-missing
}|

    @para{@bold{测试}}
    @para{
      测试必不可少。我们按照 Autotools 的方式来编写测试。首先创建 @code{test.c}：
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
    @para{你也可以使用现代的测试框架。}
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
    @para{如果你不想把前面的 @code{aclocal} 等命令再敲一遍，可以直接运行：}
    @code-block["bash"]|{autoreconf -i}|

    @para{@bold{配置与构建}}
    @para{很简单！一切就绪，按常规流程操作即可：}
    @code-block["bash"]|{
./configure
make
}|
    @para{安装：}
    @code-block["bash"]|{sudo make install}|
    @para{测试：}
    @code-block["bash"]|{make check}|
    @para{打包发布：}
    @code-block["bash"]|{make dist}|
    @para{
      哇，大功告成！要在你自己的程序里使用这个库，只需加上 @code{#include <ts.h>} 并链接该库（@code{-lts}）即可！
    }

    @para{@bold{成品}}
    @para{
      本示例的发布包可以在@link["/files/20200808/libts-0.1.tar.gz"]{这里}下载。
    }
  })

(provide post)