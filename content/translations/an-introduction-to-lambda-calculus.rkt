#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["Lambda 演算简介" "2023-02-09" #:lang "zh"]{
    @heading["introduction"]{引言}
    @para{
      谁不喜欢简单！对我而言，简单不只是一种偏好，更是一种信念。我一直有种奇怪的感觉：只有简单的事物才能长久。
    }
    @para{
      在计算的世界里，最简单的东西也许是图灵机——一种计算的数学模型，能用一条纸带、一个读写头、一个状态和若干指令实现任何算法。不过，除了纸带那一套，大约同一时期还发明了另一种极其简单的数学模型。看到它的名字时不必惊讶：@bold{@it{Lambda 演算}}（@math{\lambda}-演算）。它由一套记号系统和归约规则组成。与图灵机相比，它更“数学”，没那么“计算机”。
    }

    @heading["notation-system"]{记号系统}
    @para{
      @it{我用过它！}你可能会想。没错！Lambda 演算是函数式编程语言的基本构件。在大多数现代编程语言里，你很可能会遇到它，例如 Python、JavaScript，甚至
      @link["https://stackoverflow.com/questions/48210733/link-between-lambda-calculus-and-lambda-expressions-in-c"]{C++}
      和 Java 这样的面向对象语言。来看一个例子：
    }
    @dmath{\lambda x . x}
    @para{有点困惑吧？我们用 Python 写出来：}
    @code-block["python"]|{lambda x: x}|
    @para{现在直观多了！它只是输入什么就输出什么。}
    @para{
      它可以应用到另一个表达式上，只需把该表达式写在函数后面：
    }
    @dmath{(\lambda x.x) y}
    @para{然后它会归约为 @math{y}。细节我们稍后再讲。}
    @para{
      这就是所谓的 @it{lambda 表达式}之一。lambda 表达式共有三种：
    }
    @ul{
      @item{名字：只是一个代表任意事物的普通名字，例如 @math{x}}
      @item{抽象：@math{\lambda param . body}，其中 @math{param} 是名字，函数体是替换规则。例如 @math{\lambda xy.xyx}（它实际上是 @math{\lambda x.\lambda y.xyx} 的缩写）}
      @item{应用：一组表达式，例如 @math{(\lambda xz.xxz)ij}}
    }
    @para{
      你可以在
      @link["https://en.wikipedia.org/wiki/Lambda_calculus#Formal_definition"]{维基百科}
      上查看形式定义。把 lambda 表达式记号系统当作一种极简编程语言完全没问题，它的关键字只有 @math{.}（点）和 @math{\lambda}（lambda）。lambda 表达式里还有可选的括号。没有括号时，我们从左到右解析表达式。
    }
    @para{
      在抽象（也就是函数）中，有两种变量：@it{绑定}变量和 @it{自由}变量。一个变量是 @it{绑定}的，意味着它出现在“参数”部分；@it{自由}则相反。这类似于局部变量和全局变量。例如在 @math{(\lambda x.xy)} 中，@math{x} 是绑定的，@math{y} 是自由的。
    }

    @heading["reduction-rules"]{归约规则}
    @para{
      这些归约规则的名字很可怕：@math{\alpha}-转换和 @math{\beta}-归约。
    }
    @para{
      @math{\alpha}-转换很无脑：一个名字只要是绑定的，就可以改写成另一个名字。例如 @math{\lambda x.xy} 等价于 @math{\lambda z.zy}。
    }
    @para{
      @math{\beta}-归约同样是个简单的操作：它表示按照函数体中定义的规则进行替换。例如，归约这个应用：
    }
    @dmath{(\lambda x.x) y = [y/x] x = y}
    @para{
      @math{[a/b]} 记号表示把 @math{b} 替换为 @math{a}。现在试试更复杂的一个：
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
    @para{还困惑？用 Python 试试。}
    @code-block["python"]|{
(lambda x: (lambda y: x + y + x))('a')('b')
# => 'aba'
}|
    @para{
      当然，没人会写这么可怕的程序。我们来给它命名吧（不过真正的 lambda 函数很少被命名）：
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
      注意，对于 @code{l2}（内层 lambda 函数）而言，变量 @math{x} 是自由的；但对于整个表达式来说，它是绑定的。
    }

    @heading["arithmetic"]{算术}
    @para{该做点计算了！先从定义 @math{0} 开始。}
    @dmath{\lambda sz.z}
    @para{没错！@math{0} 是个函数！试试看：}
    @dmath{(\lambda sz.z) a = (\lambda s . (\lambda z.z)) a = [a/s](\lambda z.z) = \lambda z.z}
    @para{
      输入 @math{a} 被丢掉了，只剩下 @math{\lambda z.z}，它被称为“恒等函数”。定义 @math{0} 还有很多其他方式，但使用这一种有
      @link["https://stackoverflow.com/a/1485145/10811334"]{充分理由}。继续定义 @math{1, 2, ...} 以及所有自然数吧。
    }

    @para{@bold{后继}}
    @para{
      一种方法是定义“后继运算”，它基本上返回比输入大一的数。如下所示（是的，我们给它起个名字，因为它很常用）：
    }
    @dmath{\mathbf{S} = \lambda wyx.y(wyx)}
    @para{其实我更喜欢这种形式：}
    @dmath{\mathbf{S} = \lambda w . (\lambda yx.y(wyx))}
    @para{把我们的 @math{0} 应用上去：}
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
      又一个很奇怪的函数吧？与 @math{0} 相比，在 @math{1} 中 @math{z} 被 @math{s} 引用了一次，我们就是这样编码自然数的。回想一下，这并不是编码自然数的唯一方式，但为它定义计算要容易得多（后面会讲）。如果仍然困惑，用 Python 重写一下：
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
      因为 @math{w} 总是形如
      @math{\lambda sz.s(s(s( ... (z))))}，所以用 @math{(wyx)}
      调用 @math{w} 时，我们“拆开” @math{w} 的头部并使其“去函数化”。@math{\boxed{y}(wyx)}
      头部的 @math{y} 又增加了一层嵌套。
    }
    @para{现在你知道它在做什么了。试着得到 @math{2}：}
    @dmath{
\begin{align*}
& \mathbf{S} 1 = (\lambda \boxed{w}yx.y(\boxed{w}yx))\boxed{(\lambda yx.y(x))} \\
& = \lambda yx.y(\boxed{(\lambda sz.s(z))}yx) \\
& = \lambda yx.y(y(x)) \\
& = \lambda sz.s(s(z)) = 2
\end{align*}
}
    @para{注意，为了清楚起见，我们重命名了变量。}
    @para{
      每次应用 @math{\mathbf{S}}，嵌套都会更深。我们甚至可以在 Python 里测试！
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

    @para{@bold{加法}}
    @para{
      加法也可以用后继函数实现。在 @math{\mathbf{S}} 前面写一个数：
    }
    @dmath{
\begin{align*}
& 2\mathbf{S} \\
& = (\lambda s . \lambda z . s (s(z))) \mathbf{S} \\
& = \lambda z.\mathbf{S}(\mathbf{S}(z))
\end{align*}
}
    @para{
      它会被归约成一个执行 @math{2} 次后继操作的函数！现在用它计算 @math{2+3} 就轻而易举了：
    }
    @dmath{2\mathbf{S}3 = \mathbf{S}\mathbf{S}3 = \mathbf{S}4 = 5}
    @para{用递归方式定义数字，让这个操作变得轻而易举。}

    @para{@bold{乘法}}
    @para{乘法的实现也因数字的定义而变得简单。}
    @dmath{\mathbf{M} = \lambda xyz.x(yz)}
    @para{它“拆开” @math{y}，并把重复序列应用到 @math{x} 上，比如 @math{2 \times 3}：}
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
    @para{哇，这么多 @it{括号}！但相信我，它做的是对的。}

    @heading["further-reading"]{延伸阅读}
    @para{
      现在你应该对 Lambda 演算有了大致了解。它是一个简单而强大的系统，还有很多东西要学。你可以：
    }
    @ul{
      @item{试着用 lambda 系统创造更多算术运算。}
      @item{查看 @link["https://en.wikipedia.org/wiki/Lambda_calculus"]{维基百科}，获得更系统、更正式的介绍。}
      @item{尝试一些函数式编程语言，例如 @link["https://lisp-lang.org/"]{Lisp}
        和 @link["https://www.haskell.org/"]{Haskell}。（毕竟这才是这一切的目的！）}
    }
    @para{祝你好运，玩得开心！}
  })

(provide post)