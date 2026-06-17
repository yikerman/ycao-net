#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post-invent-wheels-with-autotools-c
  @article["Invent wheels with Autotools & C" "2020-08-08"]{
    @para{
      This how-to guide will teach you how to invent wheels with Autotools & C.
      Note that it isn't detailed, just to give you some ideas how the whole
      system works.
    }

    @heading["introduction"]{Introduction}

    @para{@bold{Requirements}}
    @para{My Autotools versions are:}
    @ul{
      @item{Automake 1.16.1}
      @item{Autoconf 2.69}
      @item{Libtool 2.4.6}
    }
    @para{And I'm on OS X. Installation guide will not be included.}

    @para{@bold{Product}}
    @para{
      We'll make a simple C lib (C++ compatible) called @code{libts} helps you
      to get time duration between two function calls.
    }

    @heading["procedures"]{Procedures}
    @para{Time to actually make something!}

    @para{@bold{A simple lib}}
    @para{
      Our project starts simply like this, including a header file and a source
      file:
    }
    @code-block["plaintext"]|{
.
├── ts.c
└── ts.h

0 directories, 2 files
}|
    @para{And codes are shown below:}
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
    @para{Now the source code is done. Let's setup Autotools!}

    @para{@bold{Autotools}}
    @para{
      Autotools is a complicated build system. We have to create several files.
    }
    @para{@it{Note: The following commands are run at the root of the source code.}}

    @para{@bold{@code{configure.ac}}}
    @para{
      @bold{@code{configure.ac} is a file for @code{Autoconf} to generate an
      @code{configure} script. It checks availability (in our example, if
      @code{gettimeofday()} and @code{time()} are available) and generates
      @code{Makefile} from @code{Makefile.in}, which will be generated later.}
    }
    @para{
      Let's start with an @code{autoscan} GNU provided. It scans your code and
      generates an @code{configure.ac} automatically.
    }
    @code-block["bash"]|{autoscan}|
    @para{The directory should be like this:}
    @code-block["plaintext"]|{
.
├── autoscan.log
├── configure.scan
├── ts.c
└── ts.h

0 directories, 4 files
}|
    @para{
      The @code{autoscan.log} can be removed safely. What matters is
      @code{configure.scan}. We have to rename it to @code{configure.ac} first:
    }
    @code-block["bash"]|{
rm -f autoscan.log
mv configure.scan configure.ac
}|
    @para{@code{configure.ac} looks like this:}
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
      It's actually a piece of @link["https://www.gnu.org/software/m4/m4.html"]{m4}
      language, and all those @code{AC_XXX} stuffs are macros and will be
      expanded into bash scripts. You can write bash in the @code{configure.ac}
      directly as well.
    }
    @para{
      As you can see, it's smart to include @code{AC_CHECK_FUNCS([gettimeofday])}.
      This will checks if @code{gettimeofday} is available. Magic! But, we have
      to modify it anyway.
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
      @item{1: Checks the minimal version of @code{autoconf}.}
      @item{2 & 11: Start and end of every @code{configure.ac}. It also includes
        some info for your project.}
      @item{3: Check if the source code exists.}
      @item{4: Generates the configuration header named @code{config.h}.}
      @item{5: Prepare for generating @code{Makefile}.}
      @item{6: Determine a C compiler to use.}
      @item{7: Check if header file @code{sys/time.h} is available.}
      @item{8: Check if function @code{gettimeofday} is available.}
      @item{9: Initialize Libtool. This will be used later.}
      @item{10: Generate @code{Makefile} from @code{Makefile.in}, which will be
        generated later.}
    }
    @para{And to generate the @code{configure} file:}
    @code-block["bash"]|{
aclocal
autoconf
autoheader
}|
    @para{And your project will be like this:}
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
      @code{Makefile.am} is a file for @code{automake} to generate the
      @code{Makefile.in} mentioned above. Now create a @code{Makefile.am} and
      write the following stuffs:
    }
    @code-block["makefile"]|{
AUTOMAKE_OPTIONS = foreign
include_HEADERS=ts.h
lib_LTLIBRARIES = libts.la
libts_la_SOURCES=ts.c
}|
    @para{
      The build target is @code{libts.la}, containing the source file
      @code{ts.c}, which uses @code{Libtool} to sustain portability. It's
      simpler than @code{configure.ac}.
    }
    @para{
      Also, note that @code{AUTOMAKE_OPTIONS} is set to @code{foreign}, so it
      won't force us to create those @code{NEWS}, @code{AUTHOR},
      @code{ChangeLog}, etc.
    }
    @para{To generate @code{Makefile.in}, run:}
    @code-block["bash"]|{
libtoolize # Generate supporting files for Libtool
automake --add-missing
}|

    @para{@bold{Tests}}
    @para{
      Tests are always needed. Let's do this in Autotools' way. First create
      @code{test.c}:
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
    @para{You can use modern test frameworks too.}
    @para{@code{Makefile.am}:}
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
    @para{Also, if you don't want to type the above @code{aclocal} and stuff again:}
    @code-block["bash"]|{autoreconf -i}|

    @para{@bold{configure & build}}
    @para{Simple! Everything is ready now. Do this as usual:}
    @code-block["bash"]|{
./configure
make
}|
    @para{And to install:}
    @code-block["bash"]|{sudo make install}|
    @para{To test:}
    @code-block["bash"]|{make check}|
    @para{To make a distribution package:}
    @code-block["bash"]|{make dist}|
    @para{
      Whoa, you did that! To use this lib in your own programs, just
      @code{#include <ts.h>} and link this library (@code{-lts})!
    }

    @para{@bold{Product}}
    @para{
      This demo's distribution can be found
      @link["/files/20200808/libts-0.1.tar.gz"]{here}.
    }
  })

(provide post-invent-wheels-with-autotools-c)
