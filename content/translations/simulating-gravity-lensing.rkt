#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["模拟引力透镜效应" "2023-09-03" #:lang "zh"]{
    @para{
      你是否好奇过，为什么
      @link["https://www.imdb.com/title/tt0816692/mediaviewer/rm4154473472?ref_=ext_shr_lnk"]{@it{《星际穿越》（Interstellar）}里的黑洞}
      看起来像两个正交相交的圆环？这其实是
      @link["https://hubblesite.org/contents/articles/gravitational-lensing"]{引力透镜效应}所致。
    }
    @para{
      这一现象背后的物理学原理源于爱因斯坦的广义相对论，相当复杂。（如果你感兴趣，
      @link["https://qr.ae/pyE9TW"]{这篇 Quora 帖子}作了深入解读。）
      不过，有一条重要线索：光的传播方式与非零质量粒子的运动方式相同。这意味着，我们可以通过计算粒子在引力场中的运动轨迹来模拟引力透镜效应，因为在这个简化模型中，不必考虑光速等因素。
    }
    @para{
      该模型的起步方式类似于光线追踪。我们先准备一个屏幕和一台虚拟相机，将屏幕划分为像素网格。对于每个像素，从相机向其发射一个虚拟粒子。相机的位置即粒子的初始位置，粒子的速度则设为从相机指向该像素的单位向量。
    }
    @para{接下来，结合引力场计算粒子的受力，公式如下：}
    @math-block[#:label "gravity"]{\vec{F} = m\vec{a} = \sum_{M, \vec{d} \in \text{mass-points}} \frac{GMm}{\vec{d}^2}\hat{d}}
    @para{
      其中，@math{d} 是粒子与质点之间的距离，
      @math{M} 是质点的质量，@math{m} 是粒子的虚拟质量，
      @math{G} 是引力常数，而 @math{\hat{d}} 是从质点指向粒子的单位向量。
    }
    @para{
      由于 @math{m} 可以约掉（物体在引力场中的加速度与其质量无关），我们可以将 @eqref["gravity"] 简化为：
    }
    @dmath{\vec{a} = \frac{\mathrm{d}^2 \vec{x}}{\mathrm{d}t^2} = \sum_{M, \vec{d} \in \text{mass-points}} \frac{GM}{\vec{d}^2}\hat{d}}
    @para{
      这个方程或许存在解析解，但在计算轨迹与可见物体的碰撞时，解析解过于复杂，缺乏实用价值。
    }
    @para{
      因此，我们可以改用数值方法求解，以离散的方式计算粒子的运动。在每个时间步长
      @math{\Delta t} 内，模型会检查线段
      @math{x(t) \rightarrow x(t+\Delta t)} 是否撞上任何可见物体。若发生碰撞，模型便将粒子停在碰撞点，并用该物体的颜色为对应像素着色。
    }
    @para{
      这种方法看似笨拙，但实际上能在合理的时间内完成计算。你可以在
      @link["https://github.com/yikerman/glens"]{GitHub 上的 glens 仓库}找到我的代码实现。该软件用 Rust 编写，输出 PPM 格式的图像。
    }
    @para{只需写一点脚本（或者叫元脚本？），甚至还能生成视频。}
    @xml|{<video width="480" height="270" controls><source src="/files/20230903/pass.mp4" type="video/mp4"></video>}|
    @para{
      在上面的视频中，一个不可见的黑洞掠过两颗可见的恒星，引力透镜效应清晰可见。黑洞后方的恒星发生了扭曲，并出现了重影。例如在这张图中：
    }
    @img["/files/20230903/pass.png"]{黑洞掠过恒星}
    @para{
      那颗黄色恒星实际上位于黑洞正后方。但在引力透镜效应的作用下，光线改变方向，围绕黑洞形成了一个圆环（即
      @link["https://en.wikipedia.org/wiki/Einstein_ring"]{爱因斯坦环}）。左侧的蓝色恒星则是原恒星的重影——视线被黑洞弯曲，绕过黑洞背面，重新指向了恒星的实际位置。
    }
    @para{
      下面的视频展示了两个带有
      @link["https://en.wikipedia.org/wiki/Accretion_disk"]{吸积盘}的黑洞相互绕转共舞的场景，其中的引力透镜效应更加明显。
    }
    @xml|{<video width="480" height="270" controls><source src="/files/20230903/bh.mp4" type="video/mp4"></video>}|
  })

(provide post)