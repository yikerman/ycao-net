#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["模拟引力透镜" "2023-09-03" #:lang "zh"]{
    @para{
      你可曾想过，@link["https://www.imdb.com/title/tt0816692/mediaviewer/rm4154473472?ref_=ext_shr_lnk"]{@it{星际穿越}中的黑洞}
      为什么看起来像两个彼此正交相交的环？这是因为
      @link["https://hubblesite.org/contents/articles/gravitational-lensing"]{引力透镜效应}。
    }
    @para{
      这一现象背后的物理来自爱因斯坦的广义相对论，相当复杂。（如果你感兴趣，
      @link["https://qr.ae/pyE9TW"]{这篇 Quora 帖子} 有深入讲解。）
      不过，有一个重要线索：光的传播方式与质量不为零的粒子相同。这意味着，我们可以通过模拟粒子在引力场中的轨迹来模拟引力透镜效应，因为在这个简化模型中，我们不必考虑光速等等。
    }
    @para{
      该模型一开始类似光线追踪。我们先设置一块屏幕和一台虚拟相机，把屏幕分成像素网格。对每个像素，我们从相机向该像素发射一个虚拟粒子。相机的位置成为粒子的初始位置。粒子的速度设为从相机指向该像素的单位向量。
    }
    @para{然后根据引力场计算粒子，即：}
    @math-block[#:label "gravity"]{\vec{F} = m\vec{a} = \sum_{M, \vec{d} \in \text{mass-points}} \frac{GMm}{\vec{d}^2}\hat{d}}
    @para{
      其中 @math{d} 是粒子与质点之间的距离，
      @math{M} 是质点的质量，@math{m} 是粒子的虚拟质量，
      @math{G} 是引力常数，@math{\hat{d}} 是从质点指向粒子的单位向量。
    }
    @para{
      由于 @math{m} 可以约去（物体在引力场中的加速度不受其质量影响），我们可以把 @eqref["gravity"] 简化为：
    }
    @dmath{\vec{a} = \frac{\mathrm{d}^2 \vec{x}}{\mathrm{d}t^2} = \sum_{M, \vec{d} \in \text{mass-points}} \frac{GM}{\vec{d}^2}\hat{d}}
    @para{
      解析解也许存在，但当需要计算轨迹与可见物体的碰撞时，它就过于复杂，没什么用。
    }
    @para{
      于是，我们可以改用数值方法解这个方程。粒子的运动可以离散地计算。对每个时间步
      @math{\Delta t}，模型检查线段
      @math{x(t) \rightarrow x(t+\Delta t)} 是否撞上任何可见物体。如果撞上，模型就让粒子停在碰撞点，并用该物体的颜色绘制该像素。
    }
    @para{
      这个方法看似笨拙，但实际上能在合理的时间内完成计算。你可以在
      @link["https://github.com/yikerman/glens"]{GitHub 上的 glens} 找到我的实现。该软件用 Rust 开发，输出 PPM 格式的图像。
    }
    @para{再写点脚本（或者元脚本？），连视频也能生成。}
    @xml|{<video width="480" height="270" controls><source src="/files/20230903/pass.mp4" type="video/mp4"></video>}|
    @para{
      上面的视频中，一个不可见的黑洞从两颗可见恒星旁经过。引力透镜效应清晰可见。黑洞后方的恒星被扭曲并产生重影。例如，在这张图中：
    }
    @img["/files/20230903/pass.png"]{黑洞从恒星旁经过}
    @para{
      那颗黄色恒星其实位于黑洞后方。不过，由于引力透镜效应，光线会改变方向，在黑洞周围绕成一个环（称为
      @link["https://en.wikipedia.org/wiki/Einstein_ring"]{爱因斯坦环}）。
      左侧那颗蓝色恒星是原本那颗的复制像。黑洞使光线弯曲，让它绕过黑洞后方，再导向恒星的实际位置。
    }
    @para{
      下面的视频展示两个带 @link["https://en.wikipedia.org/wiki/Accretion_disk"]{吸积盘} 的黑洞彼此绕转。引力透镜效应更加明显。
    }
    @xml|{<video width="480" height="270" controls><source src="/files/20230903/bh.mp4" type="video/mp4"></video>}|
  })

(provide post)