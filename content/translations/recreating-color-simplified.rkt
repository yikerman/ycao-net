#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["从第一性原理再现颜色" "2025-12-07" #:lang "zh"]{
    @para{
      @it{摘要：本文给出一个浅显的推导，说明人眼视觉中的 LMS 颜色模型与 RAW 相机传感器数据、以及显示器和 jpg/png 等图像中的 RGB 值之间，存在简单、可测量的线性关系。}
    }
    @para{
      现实世界中的颜色是连续光谱，例如
      @link["https://en.wikipedia.org/wiki/Sunlight#Composition_and_power"]{太阳光谱}。
      我们可以把它描述为连续函数 @math{J(\lambda)}，其中
      @math{\lambda} 是波长，@math{J(\lambda)} 是该波长处的强度。
    }
    @para{
      人眼有三类颜色受体（视锥细胞），分别
      @link["https://en.wikipedia.org/wiki/LMS_color_space"]{对不同波长范围敏感}，
      按长、中、短波长命名为 L、M、S，大致对应红、绿、蓝。把这三类细胞在波长
      @math{\lambda} 处的响应度表示为函数 @math{s(\lambda)}，那么某一类视锥细胞感知到的强度可以表示为（以 L 为例）：
    }
    @dmath{L = \int_{-\infty}^\infty J(\lambda) s_L(\lambda) d\lambda}
    @para{
      M、S 细胞同理。只要
      @math{\begin{bmatrix} L & M & S \end{bmatrix}} 相同，感知就相同。这一点很重要，不仅因为它是人眼颜色视觉的基础，还因为相机传感器借助
      @link["https://en.wikipedia.org/wiki/Bayer_filter"]{Bayer 滤镜}或类似技术，模仿这一机制来捕捉颜色。
    }
    @para{
      需要注意的是，对于同一种感知颜色（
      @math{\begin{bmatrix} L_0 & M_0 & S_0 \end{bmatrix}} 固定），可以有无数种光谱 @math{J(\lambda)} 产生同样的感知。
      这称为
      @link["https://en.wikipedia.org/wiki/Metamerism_(color)"]{同色异谱}，它使现代显示器能够用不同于现实世界的光谱来再现或近似颜色。事实上，现代显示器（如 LCD、OLED 等）也正是利用这一方法工作的：它们有三种基色光——红、绿、蓝，各具有人工设定但固定的光谱，并且可以分别调节每种基色的强度。也就是说，设 @math{r}、@math{g}、@math{b} 分别为 RGB 光的强度（它们恰好就是我们在数字图像中通常读到的 RGB 值），并设 @math{J_R(\lambda)}、@math{J_G(\lambda)}、@math{J_B(\lambda)} 为 RGB 光固定的人工光谱，则显示器发出的总光谱可表示为：
    }
    @dmath{J_\text{display}(\lambda) = r J_R(\lambda) + g J_G(\lambda) + b J_B(\lambda)}
    @para{考虑某一类视锥细胞，比如 L；要再现 @math{L_0}，就有：}
    @dmath{
\begin{align*}
L_0 &= \int_{-\infty}^\infty J_\text{display}(\lambda) s_L(\lambda) d\lambda \\
L_0 &= \int_{-\infty}^\infty \left( r J_R(\lambda) + g J_G(\lambda) + b J_B(\lambda) \right) s_L(\lambda) d\lambda \\
L_0 &= r \int_{-\infty}^\infty J_R(\lambda) s_L(\lambda) d\lambda + g \int_{-\infty}^\infty J_G(\lambda) s_L(\lambda) d\lambda + b \int_{-\infty}^\infty J_B(\lambda) s_L(\lambda) d\lambda
\end{align*}
}
    @para{
      注意，@math{L_0} 是
      @math{\int_{-\infty}^\infty J_R(\lambda) s_L(\lambda) d\lambda}、
      @math{\int_{-\infty}^\infty J_G(\lambda) s_L(\lambda) d\lambda} 与
      @math{\int_{-\infty}^\infty J_B(\lambda) s_L(\lambda) d\lambda} 以
      系数 @math{r}、@math{g}、@math{b} 构成的线性组合。这些积分称为显示器各基色对 L 视锥细胞的敏感度，分别记作
      @math{S_{L,R}}、@math{S_{L,G}}、@math{S_{L,B}}，于是
      @math{L = r S_{L,R} + g S_{L,G} + b S_{L,B}}。因此，RGB 光强对 L、M、S 视锥细胞造成的颜色感知，可以用关于敏感度 @math{\mathbf{S}} 的矩阵形式表示：
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
    @para{于是，要再现颜色感知，只需计算：}
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
      现在这就很简单了。有时 @math{r}、@math{g}、@math{b} 的值会超出显示器的能力（例如为负值，或大于最大强度），这时就要灵活运用色彩管理技术，例如
      @link["https://en.wikipedia.org/wiki/Tone_mapping"]{色调映射}和
      @link["https://en.wikipedia.org/wiki/Gamut_mapping"]{色域映射}，找出显示器所能产生的、视觉上最悦目的颜色。
    }
  })

(provide post)