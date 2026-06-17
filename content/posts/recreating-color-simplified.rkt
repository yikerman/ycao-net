#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["Color Recreation from First Principles" "2025-12-07"]{
    @para{
      @it{Abstract: This article provides a gentle derivation showing the
      existence of a simple, measurable linear relationship between the LMS color
      model as in human vision and RAW camera sensor data and the RGB values as
      in displays and jpg/png/etc. images.}
    }
    @para{
      Real world colors are continuous spectra, such as the
      @link["https://en.wikipedia.org/wiki/Sunlight#Composition_and_power"]{sunlight spectrum}.
      We can describe it as a continuous function @math{J(\lambda)} where
      @math{\lambda} is the wavelength and @math{J(\lambda)} is the intensity at
      that wavelength.
    }
    @para{
      Human eyes have three types of color receptors (cone cells) that are
      @link["https://en.wikipedia.org/wiki/LMS_color_space"]{sensitive to different ranges of wavelengths},
      named L, M, S for long, medium and short wavelengths respectively, loosely
      corresponding to red, green and blue colors. Represent the responsiveness
      of these three types of cells as functions @math{s(\lambda)} at wavelength
      @math{\lambda}, then the perceived intensity of a type of cone cell can be
      expressed as (take L as an example):
    }
    @dmath{L = \int_{-\infty}^\infty J(\lambda) s_L(\lambda) d\lambda}
    @para{
      and same goes for M and S cells. As long as
      @math{\begin{bmatrix} L & M & S \end{bmatrix}} are the same, the perception
      will be the same. It is significant not only because it is the basis of
      human color vision, but also because camera sensors, utilizing
      @link["https://en.wikipedia.org/wiki/Bayer_filter"]{Bayer filter} or similar
      technologies, mimic this mechanism to capture colors.
    }
    @para{
      It can be noted that for the same perceived color (fixed
      @math{\begin{bmatrix} L_0 & M_0 & S_0 \end{bmatrix}}), there are infinite
      possible spectra @math{J(\lambda)} that can produce the same perception.
      This is called
      @link["https://en.wikipedia.org/wiki/Metamerism_(color)"]{metamerism} which
      enables modern displays to reproduce or approximate colors with a spectra
      different from the real world ones. It is also, in fact, true that modern
      displays (such as LCD, OLED, etc.) work by exploiting this method, namely,
      they have three kinds of primary color lights red, green and blue that have
      artificial but fixed spectra, and the ability to adjust the intensity of
      each primary color. Namely, let @math{r}, @math{g} and @math{b} be the
      intensities of the RGB lights respectively (which happens to be the RGB
      values we usually read in digital images) and let @math{J_R(\lambda)},
      @math{J_G(\lambda)} and @math{J_B(\lambda)} be the fixed, artificial spectra
      of the RGB lights, the overall spectrum emitted by the display can be
      expressed as:
    }
    @dmath{J_\text{display}(\lambda) = r J_R(\lambda) + g J_G(\lambda) + b J_B(\lambda)}
    @para{Consider one kind of cone cell, say L, to recreate @math{L_0}, we have:}
    @dmath{
\begin{align*}
L_0 &= \int_{-\infty}^\infty J_\text{display}(\lambda) s_L(\lambda) d\lambda \\
L_0 &= \int_{-\infty}^\infty \left( r J_R(\lambda) + g J_G(\lambda) + b J_B(\lambda) \right) s_L(\lambda) d\lambda \\
L_0 &= r \int_{-\infty}^\infty J_R(\lambda) s_L(\lambda) d\lambda + g \int_{-\infty}^\infty J_G(\lambda) s_L(\lambda) d\lambda + b \int_{-\infty}^\infty J_B(\lambda) s_L(\lambda) d\lambda
\end{align*}
}
    @para{
      Notice how @math{L_0} is a linear combination of
      @math{\int_{-\infty}^\infty J_R(\lambda) s_L(\lambda) d\lambda},
      @math{\int_{-\infty}^\infty J_G(\lambda) s_L(\lambda) d\lambda} and
      @math{\int_{-\infty}^\infty J_B(\lambda) s_L(\lambda) d\lambda} with
      coefficients @math{r}, @math{g} and @math{b}. These integrals are named as
      sensitivities of the display primaries to the L cone cell, denoted as
      @math{S_{L,R}}, @math{S_{L,G}} and @math{S_{L,B}} respectively so that
      @math{L = r S_{L,R} + g S_{L,G} + b S_{L,B}}. Thus, we can represent the
      color perception for L, M and S cone cells caused by RGB light intensities
      in matrix form regarding the sensitivities @math{\mathbf{S}}:
    }
    @dmath{
\begin{bmatrix}
L \\
M \\
S
\end{bmatrix}
=
\begin{bmatrix}
S_{L,R} & S_{L,G} & S_{L,B} \\
S_{M,R} & S_{M,G} & S_{M,B} \\
S_{S,R} & S_{S,G} & S_{S,B}
\end{bmatrix}
\begin{bmatrix}
r \\
g \\
b
\end{bmatrix}
}
    @para{so that to recreate color perceptions, we only need to calculate:}
    @dmath{
\begin{bmatrix}
r \\
g \\
b
\end{bmatrix}
=
\mathbf{S}^{-1}
\begin{bmatrix}
L \\
M \\
S
\end{bmatrix}
}
    @para{
      which is trivial now. And sometimes, the values of @math{r}, @math{g} and
      @math{b} may exceed the display's capability (for example, negative values
      or values larger than the maximum intensity), in which case we need to go
      creative with color management techniques such as
      @link["https://en.wikipedia.org/wiki/Tone_mapping"]{tone mapping} and
      @link["https://en.wikipedia.org/wiki/Gamut_mapping"]{gamut mapping} to find
      the best visually-pleasing color that the display can produce.
    }
  })

(provide post)
