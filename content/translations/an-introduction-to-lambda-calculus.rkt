#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["Lambda 演算简介" "2023-02-09" #:lang "zh"]{
    @heading["introduction"]{引言}
    @para{
      谁不喜欢简洁呢！对我而言，简洁不仅是一种偏好，更是一种信仰。我总有一种莫名的直觉：唯有简单的事物才能长久。
    }
    @para{
      在计算的世界里，最简单的模型或许要数图灵机（Turing machine）了。它是一种计算数学模型，仅凭一条纸带、一个读写头、一个状态寄存器和一套指令表，就能实现任何算法。然而，除了这种鼓捣纸带的机器，几乎在同一时期，人们还发明了另一种极其简单的数学模型。看到它的名字千万别惊讶：@bold{@it{Lambda 演算}}（Lambda calculus，即 @math{\lambda}-calculus）。它由一套记号系统和归约规则组成。与图灵机相比，它的“数学味”要比“计算机味”更浓一些。
    }

    @heading["notation-system"]{记号系统}
    @para{
      你可能会想：@it{这玩意儿我用过！}没错！Lambda 演算是函数式编程语言的基石。你极有可能在大多数现代编程语言中见过它的身影，比如 Python、JavaScript，甚至是
      @link["https://stackoverflow.com/questions/48210733/link-between-lambda-calculus-and-lambda-expressions-in-c"]{C++}
      和 Java 这样的面向对象语言。我们来看个例子：
    }
    @dmath{\lambda x . x}
    @para{有点摸不着头脑？我们用 Python 写出来看看：}
    @code-block["python"]|{lambda x: x}|
    @para{这下直观多了！它的作用仅仅是把输入原样输出。}
    @para{
      把另一个表达式写在函数后面，就能将函数应用到该表达式上：
    }
    @dmath{(\lambda x.x) y}
    @para{运算结果是 @math{y}。具体细节我们稍后详谈。}
    @para{
      这就是所谓的 @it{Lambda 表达式}（lambda expressions）。Lambda 表达式分为三种：
    }
    @ul{
      @item{名称（Name）：一个普通的符号，用来指代任何东西。例如：@math{x}}
      @item{抽象（Abstraction）：形如 @math{\lambda param . body}，其中 @math{param} 是名称，body 是替换规则。例如：@math{\lambda xy.xyx}（实际上是 @math{\lambda x.\lambda y.xyx} 的简写）}
      @item{应用（Application）：一串并列的表达式。例如：@math{(\lambda xz.xxz)ij}}
    }
    @para{
      你可以在@link["https://en.wikipedia.org/wiki/Lambda_calculus#Formal_definition"]{维基百科}上查看其形式化定义。你完全可以把 Lambda 表达式的记号系统当成一门极简的编程语言，它的关键字只有 @math{.}（点）和 @math{\lambda}（lambda）。Lambda 表达式里还可以视情况加上括号。如果不加括号，我们就从左往右解析表达式。
    }
    @para{
      在一个抽象（即函数）中，变量分为两种：@it{约束变量}（bounded variables）和@it{自由变量}（free variables）。@it{约束}变量是指出现在“参数（params）”部分的变量，反之则是@it{自由}变量。这与局部变量和全局变量的概念很像。例如在 @math{(\lambda x.xy)} 中，@math{x} 是约束变量，@math{y} 是自由变量。
    }

    @heading["reduction-rules"]{归约规则}
    @para{
      归约规则的名字听起来颇为唬人：@math{\alpha}-转换（@math{\alpha}-conversion）和 @math{\beta}-归约（@math{\beta}-reduction）。
    }
    @para{
      @math{\alpha}-转换非常简单：只要变量是受约束的，就可以把它的名字换成别的。比如 @math{\lambda x.xy} 等价于 @math{\lambda z.zy}。
    }
    @para{
      @math{\beta}-归约同样是个傻瓜式操作：按照函数体中定义的规则进行替换即可。比如，求解下面这个应用：
    }
    @dmath{(\lambda x.x) y = [y/x] x = y}
    @para{
      这里的 @math{[a/b]} 记号仅仅表示用 @math{a} 替换 @math{b}。现在来试一个稍微复杂点的：
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
    @para{还是觉得绕？放到 Python 里试试吧。}
    @code-block["python"]|{
(lambda x: (lambda y: x + y + x))('a')('b')
# => 'aba'
}|
    @para{
      当然，没人会写这么反人类的代码。我们不妨给这些函数起个名字（尽管真正的匿名函数很少有名字）：
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
      注意，对于 @code{l2}（内层的 Lambda 函数）而言，变量 @math{x} 是自由的；但对于整个表达式而言，它是受约束的。
    }

    @heading["arithmetic"]{算术运算}
    @para{是时候做点计算了！我们先从定义 @math{0} 开始。}
    @dmath{\lambda sz.z}
    @para{没错！@math{0} 竟然是个函数！来试一下：}
    @dmath{(\lambda sz.z) a = (\lambda s . (\lambda z.z)) a = [a/s](\lambda z.z) = \lambda z.z}
    @para{
      输入 @math{a} 被直接丢弃了，只留下 @math{\lambda z.z}，也就是所谓的“恒等函数”（identity function）。定义 @math{0} 还有很多其他方式，但采用这种定义是有@link["https://stackoverflow.com/a/1485145/10811334"]{充分理由}的。接下来，我们继续定义 @math{1, 2, ...} 乃至所有自然数。
    }

    @para{@bold{后继}}
    @para{
      一种方法是定义一个“后继运算”（successor operation），它的作用是返回比输入大 1 的数。定义如下（没错，因为它很常用，我们破例给它起了个名字）：
    }
    @dmath{\mathbf{S} = \lambda wyx.y(wyx)}
    @para{其实我更喜欢下面这种写法：}
    @dmath{\mathbf{S} = \lambda w . (\lambda yx.y(wyx))}
    @para{把刚才定义的 @math{0} 传进去：}
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
      又是一个奇奇怪怪的函数，对吧？与 @math{0} 相比，@math{1} 里面的 @math{z} 被 @math{s} 套了一层，这就是我们编码自然数的方式。回想一下，编码自然数并非只有这一种方式，只不过用这种方式来定义运算会容易得多（稍后会讲到）。要是还觉得迷糊，我们就用 Python 重写一遍：
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
      因为 @math{w} 的形式总是 @math{\lambda sz.s(s(s( ... (z))))}，通过 @math{(wyx)} 调用 @math{w}，我们就剥去了 @math{w} 的函数头，消除了它的函数外壳。而 @math{\boxed{y}(wyx)} 开头的 @math{y} 则又给它套上了新的一层。
    }
    @para{现在你明白它的原理了。接下来试试推导 @math{2}：}
    @dmath{
\begin{align*}
& \mathbf{S} 1 = (\lambda \boxed{w}yx.y(\boxed{w}yx))\boxed{(\lambda yx.y(x))} \\
& = \lambda yx.y(\boxed{(\lambda sz.s(z))}yx) \\
& = \lambda yx.y(y(x)) \\
& = \lambda sz.s(s(z)) = 2
\end{align*}
}
    @para{注意，为了清晰起见，这里重命名了变量。}
    @para{
      每应用一次 @math{\mathbf{S}}，嵌套就加深一层。我们甚至可以在 Python 里测试一下！
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
      加法同样可以通过后继函数来实现。试着在 @math{\mathbf{S}} 前面写个数字：
    }
    @dmath{
\begin{align*}
& 2\mathbf{S} \\
& = (\lambda s . \lambda z . s (s(z))) \mathbf{S} \\
& = \lambda z.\mathbf{S}(\mathbf{S}(z))
\end{align*}
}
    @para{
      它归约成了一个包含 @math{2} 次后继运算的函数！有了它，计算 @math{2+3} 就易如反掌了：
    }
    @dmath{2\mathbf{S}3 = \mathbf{S}\mathbf{S}3 = \mathbf{S}4 = 5}
    @para{以递归方式定义的数字，让加法运算变得轻而易举。}

    @para{@bold{乘法}}
    @para{得益于这种数字定义方式，乘法也很容易实现。}
    @dmath{\mathbf{M} = \lambda xyz.x(yz)}
    @para{它会剥开 @math{y}，并将其中重复的序列应用到 @math{x} 上，以 @math{2 \times 3} 为例：}
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
    @para{哇，这么多@it{括号}！但相信我，它的计算过程完全正确。}

    @heading["further-reading"]{延伸阅读}
    @para{
      现在你应该对 Lambda 演算有了大致的了解。这是一个简单却强大的系统，还有许多内容值得深入探索。你可以：
    }
    @ul{
      @item{试着用 Lambda 系统构建更多的算术运算。}
      @item{查阅@link["https://en.wikipedia.org/wiki/Lambda_calculus"]{维基百科}，获取更系统、更形式化的介绍。}
      @item{尝试一些函数式编程语言，例如 @link["https://lisp-lang.org/"]{Lisp} 和 @link["https://www.haskell.org/"]{Haskell}。（毕竟这才是折腾这一切的最终目的！）}
    }
    @para{祝你好运，玩得开心！}
  })

(provide post)