#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["The Missing Prerequisite of 'Algebra' in Linear Algebra" "2026-10-24"]{
    @para{
      This post aims at an audience of freshmen and sophomores taking differential equations and getting
      confused by the appearance of linear algebra in linear ODEs. It is rooted in the fact that linear algebra
      is not a bunch of neat tricks for solving linear equations or building deep learning models (while,
      of course, they certainly do), but it has two components: "linear" and "algebra". "Linear"
      is important since it behaves nicely and widely, while "algebra" aims to generalize "linear"
      as much as possible. However, for whatever reason, abstract algebra is an elective course for
      a lot of STEM majors, and a lot of engineers or even math people don't get any insights when
      encountering it. This article tries to bridge the gap and assumes prior study of "ordinary" linear
      algebra.
    }
    @heading["examples"]{"Non-trivial" Linear Algebra}
    @para{
      A lower-division course usually approaches the subject through concrete computations and examples,
      and we'll skip that part here. The important observation is that linear map appears in so many
      different locations, and not only over real numbers, such as:
    }
    @ul{
      @item{
        Limit:
        @math{\lim : \{\text{all convergent real sequences}\} \to \mathbb{R}}
        @dmath{a\lim_{n\to\infty} f_n + b\lim_{n\to\infty} g_n
          = \lim_{n\to\infty}(af_n + bg_n)}
      }
      @item{
        Integral:
        @math{\int_0^1 : \{\text{all continuous real-valued functions on } [0,1]\} \to \mathbb{R}}
        @dmath{a\int_0^1 f(x)\,\mathrm{d}x + b\int_0^1 g(x)\,\mathrm{d}x
          = \int_0^1 (af(x) + bg(x))\,\mathrm{d}x}
      }
      @item{
        Differentiation:
        @math{\frac{\mathrm{d}}{\mathrm{d}x} : \{\text{all differentiable real-valued functions on } (0,1)\}
          \to \{\text{all real-valued functions on } (0,1)\}}
        @dmath{a\frac{\mathrm{d}f}{\mathrm{d}x} + b\frac{\mathrm{d}g}{\mathrm{d}x}
          = \frac{\mathrm{d}}{\mathrm{d}x}(af + bg)}
      }
      @item{
        Expected value:
        @math{\mathbb{E} : \{\text{all random variables with finite expectation on a fixed probability space}\}
          \to \mathbb{R}}
        @dmath{a\mathbb{E}[X] + b\mathbb{E}[Y] = \mathbb{E}[aX + bY]}
      }
    }
    @heading["vec-space"]{Formal Definition of Vector Space}
    @para{
      Previously we only used @math{\mathbb{R}^n} as the vector space, but as shown by examples above 
      it can get pretty arbitrary, which is why we deseperately need to introduce linear algebra in 
      the "algebra way", since we want to extract the common, convient tools manipulating them.
      We begin by defining "vector space", the foundation of linear algebra, more formally:
    }
    @para{
      Let @math{F} be a field (we most commonly let @math{F = \mathbb{R}} or @math{\mathbb{C}}).
      A vector space @math{V} over @math{F} (we commonly let @math{V = \mathbb{R}^n}
      when @math{F = \mathbb{R}}, which gives "standard" linear algebra) is a set with two operations:
    }
    @dmath|{
      \begin{aligned}
        +_V &: V \times V \to V && \text{(vector addition)} \\
        \times_V &: F \times V \to V && \text{(scalar multiplication)}
      \end{aligned}
    }|
    @para{
      such that, for all @math{\mathbf{u},\mathbf{v},\mathbf{w} \in V} and @math{a,b \in F},
    }
    @dmath|{
      \begin{aligned}
        \mathbf{u}+_V\mathbf{v} &= \mathbf{v}+_V\mathbf{u} && \text{(commutativity)} \\
        (\mathbf{u}+_V\mathbf{v})+_V\mathbf{w} &= \mathbf{u}+_V(\mathbf{v}+_V\mathbf{w}) && \text{(associativity)} \\
        \mathbf{u}+_V\mathbf{0}_V &= \mathbf{u} && \text{(zero vector)} \\
        \mathbf{u}+_V(-\mathbf{u}) &= \mathbf{0}_V && \text{(additive inverse)} \\
        a\times_V(b\times_V\mathbf{u}) &= (ab)\times_V\mathbf{u} && \text{(scalar multiplication)} \\
        1_F\times_V\mathbf{u} &= \mathbf{u} && \text{(scalar identity)} \\
        a\times_V(\mathbf{u}+_V\mathbf{v}) &= (a\times_V\mathbf{u})+_V(a\times_V\mathbf{v}) && \text{(distributivity over vector addition)} \\
        (a+b)\times_V\mathbf{u} &= (a\times_V\mathbf{u})+_V(b\times_V\mathbf{u}) && \text{(distributivity over scalar addition)}
      \end{aligned}
    }|
    @para{
      See @link["https://en.wikipedia.org/wiki/Vector_space"]{Wikipedia} for more properties and
      theorems. From now on, we assume we know basic vector space arithmetic.
    }
    @heading["application"]{Put into Practice}
    @para{
      Let @math{\mathbf{A} \in \{\mathbb{R} \to \mathbb{R}\}^{n \times n}},
      @math{\mathbf{x}: \mathbb{R} \to \mathbb{R}^n}, and
      @math{\mathbf{f}: \mathbb{R} \to \mathbb{R}^n}. All are functions of @math{t}.
      Now let's look at an @math{n \times n} linear ODE system:
    }
    @dmath{\mathbf{x}'(t) = \mathbf{A}(t)\mathbf{x}(t) + \mathbf{f}(t)}
    @para{
      Here, @math{F = \mathbb{R}}, and
      @math{V} is the space of differentiable functions @math{\mathbb{R} \to \mathbb{R}^n},
      with pointwise arithmetic:
    }
    @dmath|{
      \begin{aligned}
        (\mathbf{x}+_V\mathbf{y})(t) &= \mathbf{x}(t)+\mathbf{y}(t) \\
        (a\times_V\mathbf{x})(t) &= a\mathbf{x}(t)
      \end{aligned}
    }|
    @heading["basis"]{Basis and Coordinates}
    @para{
      A subset @math{B \subseteq V} is a basis over @math{F} if it spans @math{V} and is
      linearly independent. Write @math{\sum^V} for summation using @math{+_V}, with empty sum
      @math{\mathbf{0}_V}.
    }
    @ul{
      @item{
        Spanning: every @math{\mathbf{v}\in V} can be written as a linear combination of @math{b \in S \subseteq B}
        where @math{S} is finite.
        @dmath|{
          \begin{gathered}
            \forall\mathbf{v}\in V,\quad
            \exists S\subseteq B,\ |S|<\infty,\quad
            \exists(a_{\mathbf{b}})_{\mathbf{b}\in S}\in F^S:\\
            \mathbf{v}=\sum_{\mathbf{b}\in S}^{V}(a_{\mathbf{b}}\times_V\mathbf{b}).
          \end{gathered}
        }|
      }
      @item{
        Linear independence: a linear combination of @math{\mathbf{b} \in S \subseteq B},
        where @math{S} is finite, equals @math{\mathbf{0}_V} only when all coefficients are zero.
        @dmath|{
          \begin{gathered}
            \forall S\subseteq B,\ |S|<\infty,\quad
            \forall(a_{\mathbf{b}})_{\mathbf{b}\in S}\in F^S:\\
            \sum_{\mathbf{b}\in S}^{V}(a_{\mathbf{b}}\times_V\mathbf{b})=\mathbf{0}_V
            \quad\Longrightarrow\quad
            \forall\mathbf{b}\in S,\ a_{\mathbf{b}}=0.
          \end{gathered}
        }|
      }
    }
    @para{
      Every vector has unique basis coefficients, only finitely many of which are nonzero.
    }
    @para{
      Sometimes a basis is easy to write out. For @math{\mathbb{R}^n}, we have the standard basis
      @math{\mathbf{e}_1,\ldots,\mathbf{e}_n}, where @math{\mathbf{e}_i} has a @math{1} in position
      @math{i} and zeros elsewhere. For real polynomials, @math{\{1,t,t^2,\ldots\}} is a basis:
      every polynomial is a finite sum of these powers, with unique real coefficients.
    }
    @para{TODO
    }
  }
)

(provide post)
