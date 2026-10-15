#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["从基本原理出发的色彩再现" "2025-12-07" #:lang "zh"]{
    @para{
      @it{摘要：本文给出一个浅易的推导，说明人类视觉中的 LMS 色彩模型、相机传感器 RAW 数据，以及显示器及 jpg/png 等图像中的 RGB 值之间，存在一种简单、可测量的线性关系。}
    }
    @para{
      现实世界中的颜色是连续光谱，例如
      @link["https://en.wikipedia.org/wiki/Sunlight#Composition_and_power"]{太阳光谱}。
      我们可以把它描述为连续函数 @math{J(\lambda)}，其中
      @math{\lambda} 是波长，@math{J(\lambda)} 是该波长处的强度。
    }
    @para{
      人眼有三类颜色感受器（视锥细胞），它们
      @link["https://en.wikipedia.org/wiki/LMS_color_space"]{对不同波长范围敏感}，
      分别称为 L、M、S，对应长、中、短波长，大致对应红、绿、蓝三色。
      将这三类细胞的响应度表示为随波长 @math{\lambda} 变化的函数
      @math{s(\lambda)}，那么某一类视锥细胞感受到的强度可表示为（以 L 为例）：
    }
    @dmath{L = \int_{-\infty}^\infty J(\lambda) s_L(\lambda) d\lambda}
    @para{
      M 细胞和 S 细胞同理。只要
      @math{\begin{bmatrix} L & M & S \end{bmatrix}} 相同，感知就相同。
      这一点很重要，不仅因为它是人类色觉的基础，还因为相机传感器利用
      @link["https://en.wikipedia.org/wiki/Bayer_filter"]{拜耳滤镜} 或类似技术，
      模仿这一机制来捕捉颜色。
    }
    @para{
      可以看出，对于同一种被感知的颜色（固定的
      @math{\begin{bmatrix} L_0 & M_0 & S_0 \end{bmatrix}}），有无限多种可能的光谱
      @math{J(\lambda)} 能产生相同感知。这称为
      @link["https://en.wikipedia.org/wiki/Metamerism_(color)"]{同色异谱}，
      它使现代显示器能用不同于现实世界光谱的光谱来再现或逼近颜色。
      事实上，现代显示器（如 LCD、OLED 等）也正是靠利用这一原理工作：
      它们有三种基色光——红、绿、蓝——具有人造但固定的光谱，并且能够调节每种基色的强度。
      也就是说，设 @math{r}、@math{g} 和 @math{b} 分别为 RGB 光的强度
      （这恰好就是我们在数字图像中通常读到的 RGB 值），并设
      @math{J_R(\lambda)}、@math{J_G(\lambda)} 和 @math{J_B(\lambda)}
      为 RGB 光固定的人造光谱，则显示器发出的总光谱可表示为：
    }
    @dmath{J_\text{display}(\lambda) = r J_R(\lambda) + g J_G(\lambda) + b J_B(\lambda)}
    @para{考虑一种视锥细胞，比如 L，要再现 @math{L_0}，则有：}
    @dmath{
\begin{align*}
L_0 &= \int_{-\infty}^\infty J_\text{display}(\lambda) s_L(\lambda) d\lambda \\
L_0 &= \int_{-\infty}^\infty \left( r J_R(\lambda) + g J_G(\lambda) + b J_B(\lambda) \right) s_L(\lambda) d\lambda \\
L_0 &= r \int_{-\infty}^\infty J_R(\lambda) s_L(\lambda) d\lambda + g \int_{-\infty}^\infty J_G(\lambda) s_L(\lambda) d\lambda + b \int_{-\infty}^\infty J_B(\lambda) s_L(\lambda) d\lambda
\end{align*}
}
    @para{
      注意 @math{L_0} 是
      @math{\int_{-\infty}^\infty J_R(\lambda) s_L(\lambda) d\lambda}、
      @math{\int_{-\infty}^\infty J_G(\lambda) s_L(\lambda) d\lambda} 和
      @math{\int_{-\infty}^\infty J_B(\lambda) s_L(\lambda) d\lambda} 的线性组合，
      系数为 @math{r}、@math{g} 和 @math{b}。这些积分称为显示器各基色对 L 视锥细胞的敏感度，
      分别记作 @math{S_{L,R}}、@math{S_{L,G}} 和 @math{S_{L,B}}，于是
      @math{L = r S_{L,R} + g S_{L,G} + b S_{L,B}}。因此，我们可以用关于敏感度
      @math{\mathbf{S}} 的矩阵形式，表示 RGB 光强度对 L、M、S 视锥细胞引起的颜色感知：
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
    @para{因此，要再现颜色感知，只需计算：}
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
      现在就很简单了。有时 @math{r}、@math{g} 和 @math{b} 的值会超出显示器的能力
      （例如为负值，或大于最大强度），这时就需要在色彩管理技术上动点脑筋，
      例如借助 @link["https://en.wikipedia.org/wiki/Tone_mapping"]{色调映射} 和
      @link["https://en.wikipedia.org/wiki/Gamut_mapping"]{色域映射}，
      找到显示器能产生的、视觉上最悦目的颜色。
    }
  })

(provide post)