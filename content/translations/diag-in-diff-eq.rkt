#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["为什么解常微分方程会用到特征值和特征向量？" "2026-11-10" #:lang "zh"]{
    @para{
      本文面向正在修读微分方程的大一、大二学生——如果你对线性常微分方程（ODE）里为何会冒出线性代数感到困惑，这篇文章就是为你写的。困惑的根源在于，线性代数并不是一堆用来解线性方程组或搭建深度学习模型的巧妙技巧（当然它确实能做这些），而是由“线性”和“代数”两部分组成的。“线性”之所以重要，是因为它性质优良且应用广泛；而“代数”则是为了把“线性”尽可能地推广开来。然而不知出于什么原因，侧重“代数”的线性代数在许多理工科专业里只是选修课，不少工程师甚至数学系学生即便学过也未能领会其中的精髓。本文试图弥合这一鸿沟，阅读前只需具备“普通”线性代数的基础。当然，其中的精妙之处远非这篇短文所能道尽，真心建议大家哪怕纯粹为了好玩，也去听一听高阶线性代数课（upper-division linear algebra）。
    }

    @heading["examples"]{“非平凡”的线性代数}
    @para{
      低年级的入门课通常从 @math{\mathbb{R}^n} 中的具体计算和实例切入，这部分我们直接略过。在正式的代数课程中，线性代数的核心是@link["https://en.wikipedia.org/wiki/Vector_space"]{向量空间}——它可以定义在任意结构（见下文）和任意域上（不必局限于 @math{\mathbb{R}}，尽管实际应用中仍以 @math{\mathbb{R}} 和 @math{\mathbb{C}} 为主）。
    }
    @para{
      以前我们只把 @math{\mathbb{R}^n} 当作向量空间，但在更广义的视角下，函数、数列、随机变量等也都可以看作向量。不妨看看下面几个例子：
    }
    @ul{
      @item{
        极限：
        @math{\lim : \{\text{all convergent real sequences}\} \to \mathbb{R}}
        @dmath{a\lim_{n\to\infty} f_n + b\lim_{n\to\infty} g_n
          = \lim_{n\to\infty}(af_n + bg_n)}
      }
      @item{
        积分：
        @math{\int_0^1 : \{\text{continuous functions}\} \to \mathbb{R}}
        @dmath{a\int_0^1 f(x)\,\mathrm{d}x + b\int_0^1 g(x)\,\mathrm{d}x
          = \int_0^1 (af(x) + bg(x))\,\mathrm{d}x}
      }
      @item{
        求导：
        @math{\frac{\mathrm{d}}{\mathrm{d}x} : \{\text{differentiable functions}\} \to \{\text{functions}\}}
        @dmath{a\frac{\mathrm{d}f}{\mathrm{d}x} + b\frac{\mathrm{d}g}{\mathrm{d}x}
          = \frac{\mathrm{d}}{\mathrm{d}x}(af + bg)}
      }
      @item{
        期望：
        @math{\mathbb{E} : \{\text{random variables}\} \to \mathbb{R}}
        @dmath{a\mathbb{E}[X] + b\mathbb{E}[Y] = \mathbb{E}[aX + bY]}
      }
    }
    @para{
      任何满足 @math{T(a\mathbf{u} + b\mathbf{v}) = aT(\mathbf{u}) + bT(\mathbf{v})} 形式的 @math{T} 都称为线性映射，其中 @math{\mathbf{u}} 和 @math{\mathbf{v}} 属于向量空间，@math{a} 和 @math{b} 属于域。
    }
    @heading["eigenfunctions"]{求导与特征函数}
    @para{
      暂且抛开严谨繁琐的形式化细节不谈，既然求导是线性算子，一个很自然的问题就是：“它的特征向量和特征函数是什么？”
    }
    @dmath{D(x) = \lambda x \quad\Longleftrightarrow\quad x'(t) = \lambda x(t) \quad\Longrightarrow\quad x(t) = C e^{\lambda t}.}
    @para{
      指数函数 @math{e^{\lambda t}} 正是它的特征向量（通常称为@it{特征函数}）。我们可以这样来理解：（一）构造出这个函数后，代入验证便知它确实是特征函数；（二）根据皮卡定理（Picard's Theorem），不存在其他解了。
    }

    @heading["coupled-systems"]{耦合常微分方程组：为什么我们需要对角化}
    @para{
      现在来看一个系数为常数矩阵 @math{\mathbf{A}} 的一阶线性常微分方程组。此时，我们的向量是可微函数 @math{\mathbf{x}: \mathbb{R} \to \mathbb{R}^n}，加法定义为逐点相加 @math{(\mathbf{x}+\mathbf{y})(t) = \mathbf{x}(t)+\mathbf{y}(t)}，数乘定义为 @math{(a\mathbf{x})(t) = a\mathbf{x}(t)}。看一个具体的方程组：
    }
    @dmath|{
      \begin{cases}x_1' = 5x_1 + 3x_2,\\ x_2' = 2x_1,\end{cases}
      \qquad\mathbf{x}'(t) = \mathbf{A}\mathbf{x}(t),\qquad
      \mathbf{A} = \begin{bmatrix}5&3\\2&0\end{bmatrix}.
    }|
    @para{
      之所以难以直接求解，是因为 @math{x_1} 和 @math{x_2} 相互@bold{耦合}：@math{x_1'} 依赖于 @math{x_2}，而 @math{x_2'} 又依赖于 @math{x_1}。但设想一下，如果系数矩阵是对角矩阵呢？比如：
    }
    @dmath|{
      \mathbf{u}'(t) = \begin{bmatrix}-1&0\\0&6\end{bmatrix}\mathbf{u}(t)
      \quad\Longleftrightarrow\quad
      \begin{cases}u_1' = -u_1,\\ u_2' = 6u_2.\end{cases}
    }|
    @para{
      在对角系统中，各个变量互不干扰（已经解耦），问题便直接简化为前面讨论过的单变量情形。
    }
    @para{
      回顾一下“普通”线性代数：矩阵用基向量系数的语言表达了线性组合，我们可以将其转换到另一组基下；如果新基恰好是特征基（eigenbasis），矩阵就会变成对角矩阵。具体而言，只要 @math{\mathbf{A}} 有足够多的线性无关特征向量，就能对角化为 @math{\mathbf{A} = \mathbf{P}\mathbf{D}\mathbf{P}^{-1}}，其中 @math{\mathbf{D}} 是由特征值构成的对角矩阵，@math{\mathbf{P}} 是以对应特征向量为列构成的矩阵。
    }
    @para{
      对于 @math{\mathbf{A} = \begin{bmatrix}5&3\\2&0\end{bmatrix}}，我们先解特征方程：
    }
    @dmath|{
      \det(\mathbf{A}-\lambda\mathbf{I}) = (\lambda+1)(\lambda-6) = 0 \quad\Longrightarrow\quad \lambda_1 = -1,\ \lambda_2 = 6.
    }|
    @para{
      分别针对每个特征值求 @math{\mathbf{A}-\lambda\mathbf{I}} 的零空间，即可得到特征向量：
    }
    @dmath|{
      \mathbf{v}_1 = \begin{bmatrix}1\\-2\end{bmatrix},\quad
      \mathbf{v}_2 = \begin{bmatrix}1\\\frac{1}{3}\end{bmatrix}
      \quad\Longrightarrow\quad
      \mathbf{P} = \begin{bmatrix}1&1\\-2&\frac{1}{3}\end{bmatrix},\quad
      \mathbf{D} = \begin{bmatrix}-1&0\\0&6\end{bmatrix}.
    }|
    @para{
      现在将 @math{\mathbf{A} = \mathbf{P}\mathbf{D}\mathbf{P}^{-1}} 代入 @math{\mathbf{x}' = \mathbf{A}\mathbf{x}}，并在等式两边同时左乘 @math{\mathbf{P}^{-1}}：
    }
    @dmath|{
      \mathbf{x}' = \mathbf{P}\mathbf{D}\mathbf{P}^{-1}\mathbf{x}
      \quad\Longleftrightarrow\quad
      \mathbf{P}^{-1}\mathbf{x}' = \mathbf{D}(\mathbf{P}^{-1}\mathbf{x}).
    }|
    @para{
      令 @math{\mathbf{u} = \mathbf{P}^{-1}\mathbf{x}}，即 @math{\mathbf{x}} 在特征向量基下的表示。由于 @math{\mathbf{P}} 是常数矩阵，求导运算与 @math{\mathbf{P}^{-1}} 可以交换顺序，即 @math{\mathbf{u}' = \mathbf{P}^{-1}\mathbf{x}'}。这样一来，耦合的常微分方程组就化为了解耦的方程组：
    }
    @dmath|{
      \mathbf{u}' = \mathbf{D}\mathbf{u}
      \quad\Longleftrightarrow\quad
      \begin{cases}u_1' = -u_1,\\ u_2' = 6u_2\end{cases}
      \quad\Longrightarrow\quad
      \mathbf{u}(t) = \begin{bmatrix}c_1 e^{-t} \\ c_2 e^{6t}\end{bmatrix}.
    }|
    @para{
      最后，利用 @math{\mathbf{x}(t) = \mathbf{P}\mathbf{u}(t)} 变回标准坐标：
    }
    @dmath|{
      \mathbf{x}(t) = \begin{bmatrix}1&1\\-2&\frac{1}{3}\end{bmatrix}\begin{bmatrix}c_1 e^{-t} \\ c_2 e^{6t}\end{bmatrix}
      = c_1 e^{-t}\begin{bmatrix}1\\-2\end{bmatrix} + c_2 e^{6t}\begin{bmatrix}1\\\frac{1}{3}\end{bmatrix}.
    }|
    @para{
      正如课上所证，由于 @math{D} 和 @math{\mathbf{A}} 都是线性的，解的任意线性组合依然是方程的解。
    }
  }
)

(provide post)