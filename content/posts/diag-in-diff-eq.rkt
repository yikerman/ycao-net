#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["Why Eigenval/vec When Solving ODE?" "2026-11-10"]{
    @para{
      This post aims at an audience of freshmen and sophomores taking differential equations and getting
      confused by the appearance of linear algebra in linear ODEs. It is rooted in the fact that linear algebra
      is not a bunch of neat tricks for solving linear equations or building deep learning models (while,
      of course, they certainly do), but it has two components: "linear" and "algebra". "Linear"
      is important since it behaves nicely and widely, while "algebra" aims to generalize "linear"
      as much as possible. However, for whatever reason, "algebra" linear algebra is an elective course for
      a lot of STEM majors, and a lot of engineers or even math people don't get any insights when
      encountering it. This article tries to bridge the gap and assumes prior study of "ordinary" linear
      algebra. There are, of course, much more nuances than this essay, and you really should take the upper-div
      linear algebra lecture just for the fun of it.
    }

    @heading["examples"]{"Non-trivial" Linear Algebra}
    @para{
      A lower-division course usually approaches the subject through concrete computations and examples
      in @math{\mathbb{R}^n}, and we'll skip that part here. In a formal algebra course, linear algebra
      is all about @link["https://en.wikipedia.org/wiki/Vector_space"]{vector space} that can be defined
      on arbitrary structures (see below) and arbitrary fields (instead of @math{\mathbb{R}}, but still
      mainly @math{\mathbb{R}} and @math{\mathbb{C}} in practice).
    }
    @para{
      Previously we only used @math{\mathbb{R}^n} as our vector space, but under this general view, 
      functions, sequences, and random variables, etc. can also be vectors. Consider these:
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
        @math{\int_0^1 : \{\text{continuous functions}\} \to \mathbb{R}}
        @dmath{a\int_0^1 f(x)\,\mathrm{d}x + b\int_0^1 g(x)\,\mathrm{d}x
          = \int_0^1 (af(x) + bg(x))\,\mathrm{d}x}
      }
      @item{
        Differentiation:
        @math{\frac{\mathrm{d}}{\mathrm{d}x} : \{\text{differentiable functions}\} \to \{\text{functions}\}}
        @dmath{a\frac{\mathrm{d}f}{\mathrm{d}x} + b\frac{\mathrm{d}g}{\mathrm{d}x}
          = \frac{\mathrm{d}}{\mathrm{d}x}(af + bg)}
      }
      @item{
        Expected value:
        @math{\mathbb{E} : \{\text{random variables}\} \to \mathbb{R}}
        @dmath{a\mathbb{E}[X] + b\mathbb{E}[Y] = \mathbb{E}[aX + bY]}
      }
    }
    @para{
      Any @math{T} s.t. the form of @math{T(a\mathbf{u} + b\mathbf{v}) = aT(\mathbf{u}) + bT(\mathbf{v})}
      is known as a linear map, where @math{\mathbf{u}} and @math{\mathbf{v}} live in the vector space
      and @math{a} and @math{b} live in the field.
    }
    @heading["eigenfunctions"]{Differentiation and Eigenfunctions}
    @para{
      Without going too much into the rigorous and formal details, by that differentiation is a linear
      operator, a natural thing to ask is "what is its eigenvector and eigenfunction"?
    }
    @dmath{D(x) = \lambda x \quad\Longleftrightarrow\quad x'(t) = \lambda x(t) \quad\Longrightarrow\quad x(t) = C e^{\lambda t}.}
    @para{
      Exponential functions @math{e^{\lambda t}} are literally the eigenvectors (often called @it{eigenfunctions}).
      A nice way to think about it is that (I) we construct it and inspect it indeed is an eigenfunction;
      (II) by Picard's Theorem, there are no more solutions.
    }

    @heading["coupled-systems"]{Coupled ODEs and Why We Want Diagonalization}
    @para{
      Now let's look at a system of first-order linear ODEs with a constant matrix @math{\mathbf{A}}. 
      Here, our vectors are differentiable functions @math{\mathbf{x}: \mathbb{R} \to \mathbb{R}^n} with 
      pointwise addition @math{(\mathbf{x}+\mathbf{y})(t) = \mathbf{x}(t)+\mathbf{y}(t)} and scalar multiplication 
      @math{(a\mathbf{x})(t) = a\mathbf{x}(t)}. Consider the concrete system:
    }
    @dmath|{
      \begin{cases}x_1' = 5x_1 + 3x_2,\\ x_2' = 2x_1,\end{cases}
      \qquad\mathbf{x}'(t) = \mathbf{A}\mathbf{x}(t),\qquad
      \mathbf{A} = \begin{bmatrix}5&3\\2&0\end{bmatrix}.
    }|
    @para{
      What makes this hard to solve directly is that @math{x_1} and @math{x_2} are @bold{coupled}: @math{x_1'} depends 
      on @math{x_2}, and @math{x_2'} depends on @math{x_1}. However, imagine if the matrix were diagonal instead, say:
    }
    @dmath|{
      \mathbf{u}'(t) = \begin{bmatrix}-1&0\\0&6\end{bmatrix}\mathbf{u}(t)
      \quad\Longleftrightarrow\quad
      \begin{cases}u_1' = -u_1,\\ u_2' = 6u_2.\end{cases}
    }|
    @para{
      In a diagonal system, since the variables are decoupled, it reduces to the previously discussed
      single variable case.
    }
    @para{
      Recall from "ordinary" linear algebra that we can translate a matrix, linear combination in
      the language of basis coefficients, into another basis system, and if the new basis is an eigenbasis,
      the matrix is a diagonal matrix. Specifically, if @math{\mathbf{A}} has enough linearly independent eigenvectors, we can 
      diagonalize it as @math{\mathbf{A} = \mathbf{P}\mathbf{D}\mathbf{P}^{-1}}, where @math{\mathbf{D}} is the 
      diagonal matrix of eigenvalues and @math{\mathbf{P}} has the corresponding eigenvectors as columns.
    }
    @para{
      For @math{\mathbf{A} = \begin{bmatrix}5&3\\2&0\end{bmatrix}}, we solve the characteristic equation:
    }
    @dmath|{
      \det(\mathbf{A}-\lambda\mathbf{I}) = (\lambda+1)(\lambda-6) = 0 \quad\Longrightarrow\quad \lambda_1 = -1,\ \lambda_2 = 6.
    }|
    @para{
      Finding the null space of @math{\mathbf{A}-\lambda\mathbf{I}} for each eigenvalue gives the eigenvectors:
    }
    @dmath|{
      \mathbf{v}_1 = \begin{bmatrix}1\\-2\end{bmatrix},\quad
      \mathbf{v}_2 = \begin{bmatrix}1\\\frac{1}{3}\end{bmatrix}
      \quad\Longrightarrow\quad
      \mathbf{P} = \begin{bmatrix}1&1\\-2&\frac{1}{3}\end{bmatrix},\quad
      \mathbf{D} = \begin{bmatrix}-1&0\\0&6\end{bmatrix}.
    }|
    @para{
      Now substitute @math{\mathbf{A} = \mathbf{P}\mathbf{D}\mathbf{P}^{-1}} into @math{\mathbf{x}' = \mathbf{A}\mathbf{x}} 
      and multiply both sides on the left by @math{\mathbf{P}^{-1}}:
    }
    @dmath|{
      \mathbf{x}' = \mathbf{P}\mathbf{D}\mathbf{P}^{-1}\mathbf{x}
      \quad\Longleftrightarrow\quad
      \mathbf{P}^{-1}\mathbf{x}' = \mathbf{D}(\mathbf{P}^{-1}\mathbf{x}).
    }|
    @para{
      Define @math{\mathbf{u} = \mathbf{P}^{-1}\mathbf{x}}, which represents @math{\mathbf{x}} in the 
      eigenvector basis. Since @math{\mathbf{P}} is constant, differentiation commutes with @math{\mathbf{P}^{-1}}, 
      that is @math{\mathbf{u}' = \mathbf{P}^{-1}\mathbf{x}'}. The coupled ODE turns into the decoupled system:
    }
    @dmath|{
      \mathbf{u}' = \mathbf{D}\mathbf{u}
      \quad\Longleftrightarrow\quad
      \begin{cases}u_1' = -u_1,\\ u_2' = 6u_2\end{cases}
      \quad\Longrightarrow\quad
      \mathbf{u}(t) = \begin{bmatrix}c_1 e^{-t} \\ c_2 e^{6t}\end{bmatrix}.
    }|
    @para{
      Finally, we transform back to the standard coordinates using @math{\mathbf{x}(t) = \mathbf{P}\mathbf{u}(t)}:
    }
    @dmath|{
      \mathbf{x}(t) = \begin{bmatrix}1&1\\-2&\frac{1}{3}\end{bmatrix}\begin{bmatrix}c_1 e^{-t} \\ c_2 e^{6t}\end{bmatrix}
      = c_1 e^{-t}\begin{bmatrix}1\\-2\end{bmatrix} + c_2 e^{6t}\begin{bmatrix}1\\\frac{1}{3}\end{bmatrix}.
    }|
    @para{
      Because @math{D} and @math{\mathbf{A}} are linear, any linear combination of solutions is still
      a solution as proven in the course.
    }
  }
)

(provide post)