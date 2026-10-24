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
      and we'll skip that part here. The important observation is that linear maps appear in many
      different settings, and not only over real numbers, such as:
    }
    @para{In the following examples, @math{a,b \in \mathbb{R}}.}
    @ul{
      @item{
        Limit:
        @math{\lim : \{\text{all convergent real sequences}\} \to \mathbb{R}}
        @dmath{a\lim_{n\to\infty} f_n + b\lim_{n\to\infty} g_n
          = \lim_{n\to\infty}(af_n + bg_n)}
      }
      @item{
        Integral:
        @math{\int_0^1 : \{\text{continuous real-valued functions}\} \to \mathbb{R}}
        @dmath{a\int_0^1 f(x)\,\mathrm{d}x + b\int_0^1 g(x)\,\mathrm{d}x
          = \int_0^1 (af(x) + bg(x))\,\mathrm{d}x}
      }
      @item{
        Differentiation:
        @math{\frac{\mathrm{d}}{\mathrm{d}x} : \{\text{differentiable real-valued functions}\}
          \to \{\text{real-valued functions}\}}
        @dmath{a\frac{\mathrm{d}f}{\mathrm{d}x} + b\frac{\mathrm{d}g}{\mathrm{d}x}
          = \frac{\mathrm{d}}{\mathrm{d}x}(af + bg)}
      }
      @item{
        Expected value:
        @math{\mathbb{E} : \{\text{real-valued random variables}\}
          \to \mathbb{R}}
        @dmath{a\mathbb{E}[X] + b\mathbb{E}[Y] = \mathbb{E}[aX + bY]}
      }
    }
    @heading["vec-space"]{Formal Definition of Vector Space}
    @para{
      Previously we only used @math{\mathbb{R}^n} as the vector space, but as shown by examples above 
      it can get pretty arbitrary, which is why we deseperately need to introduce linear algebra in 
      the "algebra way", since we want to extract the common, convient tools to manipulate them.
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
        \mathbf{u}+_V\mathbf{0} &= \mathbf{u} && \text{(zero vector)} \\
        \mathbf{u}+_V(-\mathbf{u}) &= \mathbf{0} && \text{(additive inverse)} \\
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
    @heading["application-1"]{Putting Vec Space into Practice}
    @para{
      Let @math{\mathbf{A} \in \{\mathbb{R} \to \mathbb{R}\}^{n \times n}},
      @math{\mathbf{x}: \mathbb{R} \to \mathbb{R}^n}, and
      @math{\mathbf{f}: \mathbb{R} \to \mathbb{R}^n}. All are functions of @math{t} and behaves well
      under differentiation.
      Now let's look at a system of @math{n} first-order linear ODEs:
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
      @math{\mathbf{0}}.
    }
    @ul{
      @item{
        Spanning:
        @dmath|{
          \begin{gathered}
            \forall\mathbf{v}\in V,\quad \exists m\in\mathbb{Z}_{\ge0},\\
            \exists\text{ distinct }\mathbf{b}_1,\ldots,\mathbf{b}_m\in B,\quad
            \exists a_1,\ldots,a_m\in F:\\
            \mathbf{v}=\mathop{\sum\nolimits^{V}}\limits_{i=1}^{m}(a_i\times_V\mathbf{b}_i).
          \end{gathered}
        }|
      }
      @item{
        Linear independence:
        @dmath|{
          \begin{gathered}
            \forall m\in\mathbb{Z}_{\ge1},\quad
            \forall\text{ distinct }\mathbf{b}_1,\ldots,\mathbf{b}_m\in B,\quad
            \forall a_1,\ldots,a_m\in F:\\
            \mathop{\sum\nolimits^{V}}\limits_{i=1}^{m}(a_i\times_V\mathbf{b}_i)=\mathbf{0}
            \quad\Longrightarrow\quad
            a_1=\cdots=a_m=0.
          \end{gathered}
        }|
      }
    }
    @para{
      One caveat compared with a lower-division textbook is that the basis @math{B}
      itself may be infinite, but every @math{\mathbf{v}\in V} must still be a finite
      linear combination of elements of @math{B}. If we want to allow infinite sums,
      we need additional structure to define convergence. This leads to other notions
      of basis in "functional analysis", which we will not explore here.
    }
    @heading["linear-maps"]{Linear Maps and Matrices}
    @para{TODO
    }
    @heading["application-2"]{Putting Basis into Practice}
    @para{TODO
    }
  }
)

(provide post)
