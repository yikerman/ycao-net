#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["An Introduction to Lambda Calculus" "2023-02-09"]{
    @heading["introduction"]{Introduction}
    @para{
      Who doesn't like simplicity! To me simplicity is not only a preference but
      a belief. I always has a werid feeling that only the simple things last.
    }
    @para{
      In the world of calculation, the most simple thing might be a Turing
      machine, a mathematical model of computation that is capable of
      implementing any algorithm using a tape, a head, a state and instructions.
      However besides the tape stuff, another extremely simple mathematical
      model was also invented at roughly the same time. Don't be surprised when
      you see its name: @bold{@it{Lambda calculus}} (@math{\lambda}-calculus). It
      consists a set of notation system and reduction rules. Compared with the
      Turing machine, it is more "math-y" than "computer-y".
    }

    @heading["notation-system"]{Notation System}
    @para{
      @it{I've used it!} you may think. Correct! Lambda calculus is the
      fundamental building blocks in Functional Programming language. It's
      extremely likely to meet it in most modern programming languages, for
      example Python, JavaScript and even OO languages such as
      @link["https://stackoverflow.com/questions/48210733/link-between-lambda-calculus-and-lambda-expressions-in-c"]{C++}
      and Java. Let's take a look at an example:
    }
    @dmath{\lambda x . x}
    @para{A little bit confused huh? Let's write it in Python:}
    @code-block["python"]|{lambda x: x}|
    @para{Much more intuitive now! It simply outputs whatever is inputed.}
    @para{
      It can be applied to another expression by writing the expresstion after
      the function:
    }
    @dmath{(\lambda x.x) y}
    @para{And it resolves into @math{y}. We'll cover the details later.}
    @para{
      This is one of the so-called @it{lambda expressions}. There are three
      kinds of lambda expressions:
    }
    @ul{
      @item{Name: just a trivial name representing anything. e.g. @math{x}}
      @item{Abstraction: @math{\lambda param . body}, where @math{param} is a
        name and body is the substitution rule. e.g. @math{\lambda xy.xyx} (which
        is in infact an abbreviation of @math{\lambda x.\lambda y.xyx})}
      @item{Application: a list of expressions. e.g. @math{(\lambda xz.xxz)ij}}
    }
    @para{
      You can check out the formal definition at
      @link["https://en.wikipedia.org/wiki/Lambda_calculus#Formal_definition"]{Wikipedia}.
      It's totally fine to treat the lambda expression notation system as a
      minimal programming language whose keywords are only @math{.} (dot) and
      @math{\lambda} (lambda). There are also optional quotes in lambda
      expressions. Without quotes we phrase the expression from left to right.
    }
    @para{
      In an abstraction, or function, there're two types of variables:
      @it{bounded} and @it{free} variables. A variable is @it{bounded} means it
      appears in the "params" section and @it{free} is the opposite. This is
      similar to local and global variables. For example in @math{(\lambda x.xy)},
      @math{x} is bounded and @math{y} is free.
    }

    @heading["reduction-rules"]{Reduction Rules}
    @para{
      The reduction rules have horrible names: @math{\alpha}-conversion and
      @math{\beta}-reduction.
    }
    @para{
      @math{\alpha}-conversion is very stupid: a name can be written in another
      if its bounded. For exmaple @math{\lambda x.xy} is equivalent to
      @math{\lambda z.zy}.
    }
    @para{
      @math{\beta}-reduction is also a dumb operation: it means substituting
      using the rules defined in the body of the function. For example, resolve
      the application:
    }
    @dmath{(\lambda x.x) y = [y/x] x = y}
    @para{
      The @math{[a/b]} mark simply means substituting @math{b} with @math{a}. Now
      try a more complex one:
    }
    @dmath{
\begin{align*}
& (\lambda xy.xyx)ab \\
& = (((\lambda x . \lambda y . xyx)) a ) b \\
& = (\boxed{[a/x]} (\lambda y . \boxed{x} y \boxed{x})) b \\
& = (\lambda y . \boxed{a} y \boxed{a}) b \\
& = \boxed{[b/y]} a \boxed{y} a = a \boxed{b} a
\end{align*}
}
    @para{Still confused? Try it out in Python.}
    @code-block["python"]|{
(lambda x: (lambda y: x + y + x))('a')('b')
# => 'aba'
}|
    @para{
      Of course no one will write such horrible program. Let's try naming it
      (however few real lambda functions are given names):
    }
    @code-block["python"]|{
def l1(x):
    def l2(y):
        return x + y + x
    return l2

l('a')
# => <function __main__.l1.<locals>.l2(y)>
l('a')('b')
# => 'b'
}|
    @para{
      Note that for @code{l2} (the inner lambda function) variable @math{x} is
      free. However for the whole expression it's bounded.
    }

    @heading["arithmetic"]{Arithmetic}
    @para{Time to do some calculations! Let's start by defining @math{0}.}
    @dmath{\lambda sz.z}
    @para{And yes! @math{0} is a function! Try it out:}
    @dmath{(\lambda sz.z) a = (\lambda s . (\lambda z.z)) a = [a/s](\lambda z.z) = \lambda z.z}
    @para{
      The input @math{a} is thrown away, leaving only @math{\lambda z.z} which is
      called a "identity function". There're also many other ways defining
      @math{0}, but there are
      @link["https://stackoverflow.com/a/1485145/10811334"]{good reasons} using
      this. Just keep going by defining @math{1, 2, ...} and all the natural
      numbers.
    }

    @para{@bold{Successor}}
    @para{
      One approach to this is to define a "successor operation", which basically
      returns the number that is one greater than the input. It goes as follows
      (yes we are giving it a name since it's quite common):
    }
    @dmath{\mathbf{S} = \lambda wyx.y(wyx)}
    @para{Actually I prefer the form of:}
    @dmath{\mathbf{S} = \lambda w . (\lambda yx.y(wyx))}
    @para{Apply our @math{0} to it:}
    @dmath{
\begin{align*}
& \mathbf{S} 0 \\
& = \mathbf{S} (\lambda sz.z) \\
& = (\lambda wyx.y(wyx))(\lambda sz.z) \\
& = \boxed{[\lambda sz.z / w]} (\lambda yx.y(\boxed{w} y x)) \\
& = \lambda yx.y(\boxed{(\lambda sz.z)} yx) \\
& = \lambda yx.y((\lambda z.z) x) \\
& = \lambda yx.y(x) = \lambda sz.s(z) = 1
\end{align*}
}
    @para{
      Another really weird function huh? Compared with @math{0}, @math{z} is
      quoted by @math{s} in @math{1} and that's how we encode out natural
      numbers. Recall that this is not the only way to encode natural numbers,
      but we find defining calculations for it much eaiser (covered later).
      Rewrite it in Python if you are still confused:
    }
    @code-block["python"]|{
def zero(s):
    return lambda z: z


def S(w):
    # Define function "inner" for the sake of less nasty lambda nesting.
    def inner(y):
        # We know that w is a function, hence we're going to call it instead of join (+) it.
        return lambda x: y + w(y)(x)
    return inner
}|
    @para{
      Since @math{w} is always in the form of
      @math{\lambda sz.s(s(s( ... (z))))}, by calling @math{w} using @math{(wyx)}
      we "unwrap" the head of @math{w} and "de-function" it. The @math{y} at the
      head of @math{\boxed{y}(wyx)} adds another layer of nesting.
    }
    @para{Now you have an idea what it is doing. Now try to get @math{2}:}
    @dmath{
\begin{align*}
& \mathbf{S} 1 = (\lambda \boxed{w}yx.y(\boxed{w}yx))\boxed{(\lambda yx.y(x))} \\
& = \lambda yx.y(\boxed{(\lambda sz.s(z))}yx) \\
& = \lambda yx.y(y(x)) \\
& = \lambda sz.s(s(z)) = 2
\end{align*}
}
    @para{Note that we have renamed the variables for clarity.}
    @para{
      Each time @math{\mathbf{S}} is applied, the nesting goes deeper. We can
      even test it in Python!
    }
    @code-block["python"]|{
zero('s')('z')
# => 'z'
one = S(zero)
one('s')('z')
# => 'sz'
two = S(one)
two('s')('z')
# => 'ssz'
}|

    @para{@bold{Addition}}
    @para{
      Addition can also be achieved by the successor function. Write a number
      before @math{\mathbf{S}}:
    }
    @dmath{
\begin{align*}
& 2\mathbf{S} \\
& = (\lambda s . \lambda z . s (s(z))) \mathbf{S} \\
& = \lambda z.\mathbf{S}(\mathbf{S}(z))
\end{align*}
}
    @para{
      It's resolved into a function with @math{2} successor operations! Now it's
      trivial to calculate @math{2+3} using it:
    }
    @dmath{2\mathbf{S}3 = \mathbf{S}\mathbf{S}3 = \mathbf{S}4 = 5}
    @para{Numbers defined in a recursive way make this operation a breeze.}

    @para{@bold{Multiplication}}
    @para{Multiplication is also made easy by the defination of numbers.}
    @dmath{\mathbf{M} = \lambda xyz.x(yz)}
    @para{It "unwraps" @math{y} and apply the repeated sequence to @math{x}, say @math{2 \times 3}:}
    @dmath{
\begin{align*}
& (\mathbf{M}2)3 = (\lambda xyz.x(yz)2)3 \\
& = \lambda z.2(3z) \\
& = \lambda z.(\lambda uw . u(u(w)))((\lambda ij.i(i(i(j))))z) \\
& = \lambda z.(\lambda uw . u(u(w)))(\lambda j.z(z(z(j)))) \\
& = \lambda z.(\lambda w . \boxed{\lambda j.z(z(z(j)))}(\boxed{\lambda j.z(z(z(j)))}(w))) \\
& = \lambda z.(\lambda w . z(z(z(z(z(z(w))))))) \\
& = \lambda s. \lambda z . s(s(s(s(s(s(z)))))) = 6 \\
\end{align*}
}
    @para{Whoa so many @it{brackets}! But trust me it's doing the right thing.}

    @heading["further-reading"]{Further Reading}
    @para{
      You should have a rough understanding of Lambda Calculus now. It is a
      simple yet powerful system and there's still a lot to learn. You can:
    }
    @ul{
      @item{Try to create more arithmetic operations using the lambda system.}
      @item{Check out @link["https://en.wikipedia.org/wiki/Lambda_calculus"]{Wikipedia}
        for a more systematic and formal introduction.}
      @item{Try some FP languages such as @link["https://lisp-lang.org/"]{Lisp}
        and @link["https://www.haskell.org/"]{Haskell}. (After all that's what
        this is all for!)}
    }
    @para{Good luck and have fun!}
  })

(provide post)
