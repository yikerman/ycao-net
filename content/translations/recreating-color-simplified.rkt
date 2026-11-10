#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["从第一性原理理解色彩还原" "2025-12-07" #:lang "zh"]{
    @para{
      @it{摘要：本文通过简明的推导证明：人类视觉及相机 RAW 传感器数据所用的 LMS 色彩模型，与显示器及 jpg、png 等图像格式所用的 RGB 值之间，存在着简单且可测量的线性关系。}
    }
    @para{
      现实世界中的色彩是连续光谱，例如@link["https://en.wikipedia.org/wiki/Sunlight#Composition_and_power"]{太阳光谱}。我们可以将其描述为连续函数 @math{J(\lambda)}，其中 @math{\lambda} 代表波长，@math{J(\lambda)} 代表该波长下的光强。
    }
    @para{
      人眼有三种感光受体（视锥细胞），分别@link["https://en.wikipedia.org/wiki/LMS_color_space"]{对不同范围的波长敏感}。依长波、中波、短波之分，它们被命名为 L、M、S，大致对应红、绿、蓝三色。若将这三类细胞在波长 @math{\lambda} 处的响应度表示为函数 @math{s(\lambda)}，那么某类视锥细胞所感知的强度（以 L 为例）即可表示为：
    }
    @dmath{L = \int_{-\infty}^\infty J(\lambda) s_L(\lambda) d\lambda}
    @para{
      M 和 S 细胞也是同理。只要 @math{\begin{bmatrix} L & M & S \end{bmatrix}} 相同，人眼感知的色彩就相同。这一点至关重要，不仅因为它是人类色觉的基础，还因为相机传感器也利用@link["https://en.wikipedia.org/wiki/Bayer_filter"]{拜耳滤光片（Bayer filter）}等技术来模仿这一机制，从而捕捉色彩。
    }
    @para{
      不难发现，对于同一种感知色彩（即固定的 @math{\begin{bmatrix} L_0 & M_0 & S_0 \end{bmatrix}}），存在无数种可能的光谱 @math{J(\lambda)} 能产生相同的视觉感受。这种现象称为@link["https://en.wikipedia.org/wiki/Metamerism_(color)"]{同色异谱（Metamerism）}，现代显示器正是借此得以用不同于自然界的光谱来还原或近似再现色彩。事实上，现代显示器（如 LCD、OLED 等）确实利用了这一原理：它们内置红、绿、蓝三种具有固定人造光谱的基色光源，并能调节每种基色的强度。具体而言，设 @math{r}、@math{g}、@math{b} 分别为 RGB 光源的强度（也就是我们在数字图像中常见的 RGB 值），@math{J_R(\lambda)}、@math{J_G(\lambda)}、@math{J_B(\lambda)} 为 RGB 光源固定的人造光谱，那么显示器发出的总光谱可表示为：
    }
    @dmath{J_\text{display}(\lambda) = r J_R(\lambda) + g J_G(\lambda) + b J_B(\lambda)}
    @para{以 L 视锥细胞为例，为了还原出感知强度 @math{L_0}，有：}
    @dmath{
\begin{align*}
L_0 &= \int_{-\infty}^\infty J_\text{display}(\lambda) s_L(\lambda) d\lambda \\
L_0 &= \int_{-\infty}^\infty \left( r J_R(\lambda) + g J_G(\lambda) + b J_B(\lambda) \right) s_L(\lambda) d\lambda \\
L_0 &= r \int_{-\infty}^\infty J_R(\lambda) s_L(\lambda) d\lambda + g \int_{-\infty}^\infty J_G(\lambda) s_L(\lambda) d\lambda + b \int_{-\infty}^\infty J_B(\lambda) s_L(\lambda) d\lambda
\end{align*}
}
    @para{
      可以看到，@math{L_0} 是 @math{\int_{-\infty}^\infty J_R(\lambda) s_L(\lambda) d\lambda}、@math{\int_{-\infty}^\infty J_G(\lambda) s_L(\lambda) d\lambda} 与 @math{\int_{-\infty}^\infty J_B(\lambda) s_L(\lambda) d\lambda} 的线性组合，系数分别为 @math{r}、@math{g}、@math{b}。这几个积分值即显示器三基色对 L 视锥细胞的敏感度，分别记作 @math{S_{L,R}}、@math{S_{L,G}} 和 @math{S_{L,B}}，于是有 @math{L = r S_{L,R} + g S_{L,G} + b S_{L,B}}。由此，我们可以用敏感度矩阵 @math{\mathbf{S}} 的形式，将 RGB 光强在 L、M、S 视锥细胞中引起的色彩感知表示为：
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
    @para{因此，要还原色彩感知，只需计算：}
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
      这算起来就很简单了。不过有时计算出的 @math{r}、@math{g}、@math{b} 值会超出显示器的表现能力（比如出现负数，或超出最大亮度）。遇到这种情况，就需要灵活运用@link["https://en.wikipedia.org/wiki/Tone_mapping"]{色调映射（Tone mapping）}、@link["https://en.wikipedia.org/wiki/Gamut_mapping"]{色域映射（Gamut mapping）}等色彩管理技术，在显示器所能及的范围内，找出视觉效果最理想的色彩。
    }
  })

(provide post)