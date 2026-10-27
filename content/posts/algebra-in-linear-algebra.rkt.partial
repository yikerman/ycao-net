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
      when @math{F = \mathbb{R}}, which gives "standard" linear algebra) is a nonempty set with two operations:
    }
    @dmath|{
      \begin{aligned}
        +_V &: V \times V \to V && \text{(vector addition)} \\
        \times_V &: F \times V \to V && \text{(scalar multiplication)}
      \end{aligned}
    }|
    @para{
      We write @math{\mathbf{u}+\mathbf{v}} for @math{\mathbf{u}+_V\mathbf{v}} and
      @math{a\mathbf{u}} for @math{a\times_V\mathbf{u}} for simplicity afterwards. These 
      operations satisfy the following eight axioms. Unless quantified otherwise, they hold for
      all @math{\mathbf{u},\mathbf{v},\mathbf{w} \in V} and @math{a,b \in F}.
    }
    @dmath|{
      \begin{aligned}
        (\mathbf{u}+\mathbf{v})+\mathbf{w} &= \mathbf{u}+(\mathbf{v}+\mathbf{w}) && \text{(associativity)} \\
        \mathbf{u}+\mathbf{v} &= \mathbf{v}+\mathbf{u} && \text{(commutativity)} \\
        \exists\mathbf{0}\in V,\ \forall\mathbf{u}\in V:\quad
          \mathbf{u}+\mathbf{0} &= \mathbf{u} && \text{(additive identity)} \\
        \forall\mathbf{u}\in V,\ \exists(-\mathbf{u})\in V:\quad
          \mathbf{u}+(-\mathbf{u}) &= \mathbf{0} && \text{(additive inverses)} \\
        a(b\mathbf{u}) &= (ab)\mathbf{u} && \text{(compatibility with field multiplication)} \\
        1_F\mathbf{u} &= \mathbf{u} && \text{(scalar identity)} \\
        a(\mathbf{u}+\mathbf{v}) &= a\mathbf{u}+a\mathbf{v} && \text{(distributivity over vector addition)} \\
        (a+b)\mathbf{u} &= a\mathbf{u}+b\mathbf{u} && \text{(distributivity over field addition)}
      \end{aligned}
    }|
    @para{
      Here @math{1_F} is the multiplicative identity of @math{F}.
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
        (\mathbf{x}+\mathbf{y})(t) &= \mathbf{x}(t)+\mathbf{y}(t) \\
        (a\mathbf{x})(t) &= a\mathbf{x}(t)
      \end{aligned}
    }|
    @para{
      Proof of this is indeed a vector space is trivial.
    }
    @heading["basis"]{Basis and Coordinates}
    @para{
      A subset @math{B \subseteq V} is a basis over @math{F} if it spans @math{V} and is
      linearly independent. The empty sum is @math{\mathbf{0}}.
    }
    @ul{
      @item{
        Spanning:
        @dmath|{
          \begin{gathered}
            \forall\mathbf{v}\in V,\quad \exists m\in\mathbb{Z}_{\ge0},\\
            \exists\text{ distinct }\mathbf{b}_1,\ldots,\mathbf{b}_m\in B,\quad
            \exists a_1,\ldots,a_m\in F:\\
            \mathbf{v}=\sum_{i=1}^{m}a_i\mathbf{b}_i.
          \end{gathered}
        }|
      }
      @item{
        Linear independence:
        @dmath|{
          \begin{gathered}
            \forall m\in\mathbb{Z}_{\ge1},\quad
            \forall\text{ distinct }\mathbf{b}_1,\ldots,\mathbf{b}_m\in B:\\
            \sum_{i=1}^{m}a_i\mathbf{b}_i=\mathbf{0}
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
    @para{
      Define linear map formally: 
      Let @math{V,W} be vector spaces over the same field @math{F}. A map
      @math{T:V\to W} is linear map iff:
    }
    @dmath|{
      \begin{gathered}
        \forall a,b\in F,\quad\forall\mathbf{u},\mathbf{v}\in V:\\
        T(a\mathbf{u}+b\mathbf{v})
        =aT(\mathbf{u})+bT(\mathbf{v}).
      \end{gathered}
    }|
    @para{
      A linear map is uniquely determined by where it sends the basis vectors. Any assignment
      of vectors in @math{W} to a basis of @math{V} extends to a unique linear map, since
    }
    @dmath|{
      T\left(\sum_{j=1}^{k}a_j\mathbf{b}_j\right)
      =\sum_{j=1}^{k}a_jT(\mathbf{b}_j).
    }|
    @para{
      Suppose @math{\dim V=n} and @math{\dim W=m}. Choose ordered bases
      @math{B=(\mathbf{b}_1,\ldots,\mathbf{b}_n)} of @math{V} and @math{C} of @math{W}.
      Write @math{[\mathbf{x}]_B} for the coordinate column of @math{\mathbf{x}} in @math{B},
      and similarly for @math{C}. We can generalize the standard matrix theorem:
    }
    @dmath|{
      \begin{array}{c|c}
        \text{Standard Matrix Theorem} & \text{Matrix Representation Theorem} \\[4pt]
        T:\mathbb{R}^n\to\mathbb{R}^m\text{ linear}
          & T:V\to W\text{ linear over }F \\[4pt]
        \text{Standard bases}
          & \text{Chosen bases }B,C \\[4pt]
        \exists!\mathbf{A}\in\mathbb{R}^{m\times n}
          & \exists!\mathbf{A}\in F^{m\times n} \\[4pt]
        \forall\mathbf{x}\in\mathbb{R}^n,\quad T(\mathbf{x})=\mathbf{A}\mathbf{x}
          & \forall\mathbf{x}\in V,\quad [T(\mathbf{x})]_C=\mathbf{A}[\mathbf{x}]_B \\[4pt]
        \mathbf{A}=\begin{bmatrix}T(\mathbf{e}_1)&\cdots&T(\mathbf{e}_n)\end{bmatrix}
          & \mathbf{A}=\begin{bmatrix}[T(\mathbf{b}_1)]_C&\cdots&[T(\mathbf{b}_n)]_C\end{bmatrix}
      \end{array}
    }|
    @para{
      For infinite bases, the same construction gives a possibly infinite matrix, with only
      finitely many nonzero entries in each column. Each column represents the image of one
      basis vector, which is still a finite linear combination. Input coordinates also have
      only finitely many nonzero entries, so matrix multiplication here needs no infinite sums.
    }
    @heading["application-2"]{Putting Basis into Practice}
    @para{
      Consider the system
    }
    @dmath|{
      \begin{cases}x'=5x+3y,\\y'=2x,\end{cases}
      \qquad\mathbf{x}'=\mathbf{A}\mathbf{x},\qquad
      \mathbf{A}=\begin{bmatrix}5&3\\2&0\end{bmatrix}.
    }|
    @para{
      Let @math{S} be its solution space. Take @math{F=\mathbb{R}}, @math{V=W=S}, and
      let @math{T=D} be differentiation:
    }
    @dmath|{
      S=\{\mathbf{x}:\mathbb{R}\to\mathbb{R}^2\mid
        \mathbf{x}\text{ is differentiable and }\mathbf{x}'=\mathbf{A}\mathbf{x}\},
      \qquad D:S\to S,\quad\mathbf{x}\mapsto\mathbf{x}'.
    }|
    @para{
      Linear combinations of solutions are solutions, so @math{S} is a vector space.
      Since @math{\mathbf{A}} is constant, solutions are smooth and
      @math{\mathbf{x}''=\mathbf{A}\mathbf{x}'}, so differentiation also stays in @math{S}.
      It is linear:
    }
    @dmath{D(a\mathbf{x}+b\mathbf{y})=aD\mathbf{x}+bD\mathbf{y}.}
    @para{
      What are the eigenvectors of @math{D}? They are nonzero whole functions satisfying
    }
    @dmath{D\mathbf{x}=\lambda\mathbf{x}
      \quad\Longrightarrow\quad\mathbf{x}(t)=e^{\lambda t}\mathbf{v},
      \qquad\mathbf{v}\in\mathbb{R}^2\setminus\{\mathbf{0}\}.}
    @para{
      To belong to @math{S}, this function must also satisfy the original system:
    }
    @dmath{\lambda e^{\lambda t}\mathbf{v}=\mathbf{A}e^{\lambda t}\mathbf{v}
      \quad\Longleftrightarrow\quad\mathbf{A}\mathbf{v}=\lambda\mathbf{v}.}
    @para{
      This is why the matrix eigenvalue problem appears. An eigenvector @math{\mathbf{v}}
      of @math{\mathbf{A}} gives an eigenfunction @math{e^{\lambda t}\mathbf{v}} of @math{D}.
      For this example,
    }
    @dmath|{
      \det(\mathbf{A}-\lambda\mathbf{I})=(\lambda+1)(\lambda-6),\qquad
      \mathbf{x}_1(t)=e^{-t}\begin{bmatrix}1\\-2\end{bmatrix},\quad
      \mathbf{x}_2(t)=e^{6t}\begin{bmatrix}1\\\frac13\end{bmatrix}.
    }|
    @para{
      Existence and uniqueness for this linear ODE says that each initial value
      @math{\mathbf{x}(0)\in\mathbb{R}^2} determines exactly one solution.
      Thus evaluation @math{\mathbf{x}\mapsto\mathbf{x}(0)} is a linear bijection
      @math{S\to\mathbb{R}^2}, and @math{\dim S=2}. The values
      @math{\mathbf{x}_1(0),\mathbf{x}_2(0)} are linearly independent, so
      @math{B=(\mathbf{x}_1,\mathbf{x}_2)} is a basis of @math{S}.
    }
    @para{
      Now apply the matrix representation theorem to @math{D:S\to S}, using @math{B}
      in both spaces. Since @math{D\mathbf{x}_1=-\mathbf{x}_1} and
      @math{D\mathbf{x}_2=6\mathbf{x}_2},
    }
    @dmath|{
      \mathbf{M}=\begin{bmatrix}[D\mathbf{x}_1]_B&[D\mathbf{x}_2]_B\end{bmatrix}
      =\begin{bmatrix}-1&0\\0&6\end{bmatrix},\qquad
      [D\mathbf{x}]_B=\mathbf{M}[\mathbf{x}]_B.
    }|
    @para{
      Here the vectors are functions, and the matrix acts on their constant basis coordinates:
    }
    @dmath|{
      \mathbf{x}=c_1\mathbf{x}_1+c_2\mathbf{x}_2,\qquad
      [\mathbf{x}]_B=\begin{bmatrix}c_1\\c_2\end{bmatrix},\qquad
      [D\mathbf{x}]_B=\begin{bmatrix}-c_1\\6c_2\end{bmatrix}.
    }|
    @para{
      An initial condition selects these coordinates. For example,
    }
    @dmath|{
      \mathbf{x}(0)=\begin{bmatrix}1\\7\end{bmatrix}
      \quad\Longrightarrow\quad
      \begin{bmatrix}1&1\\-2&\frac13\end{bmatrix}\begin{bmatrix}c_1\\c_2\end{bmatrix}
      =\begin{bmatrix}1\\7\end{bmatrix}
      \quad\Longrightarrow\quad c_1=-\frac{20}{7},\quad c_2=\frac{27}{7}.
    }|
    @para{
      The original @math{\mathbf{A}} acts on function values, while @math{\mathbf{M}}
      represents differentiation on the solution space in the eigenfunction basis.
      This construction uses a constant @math{\mathbf{A}}: for varying @math{\mathbf{A}(t)},
      @math{\mathbf{x}''=\mathbf{A}'\mathbf{x}+\mathbf{A}\mathbf{x}'}, when these derivatives
      exist, so differentiation need not send solutions to solutions.
    }
  }
)

(provide post)
