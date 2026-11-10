#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["我的 2023 Swift Student Challenge" "2023-05-17" #:lang "zh"]{
    @para{
      啊，Swift Student Challenge，我们最敬爱的苹果公司举办的一年一度的比赛。
    }
    @para{
      在看到一个讲授非对称加密的获奖作品后，我从一开始就决定要做教育类的应用。事实上，我的清单上有几个备选灵感：
    }
    @ol{
      @item{结合 AR 技术，展示四维物体在三维空间中的投影。}
      @item{从“为什么有的人唱歌更好听”切入，介绍信号处理。}
      @item{介绍迭代函数系统（Iterated Function System），展示数学有趣且美妙的一面。}
    }
    @para{
      最终我选了第三个，因为我的时间非常有限，而这个方案最容易上手。此外，我之前也针对这个概念写过一个叫 @link["https://github.com/yikerman/QIFS"]{QIFS} 的小应用。（不过那份代码库既混乱又缺乏维护。）
    }

    @heading["ifs"]{IFS}
    @para{
      简而言之，IFS 是度量空间 @math{X} 下的一组函数 @math{\lbrace f_i: X \mapsto X \mid i \in [1,n] \rbrace, n \subset \mathbb{N}}。将以下过程无限重复，即可得到最终图像：
    }
    @dmath{S \gets \bigcup_{i=1}^{n} \bigcup_{s \in S} f_i(s)}
    @para{
      大多数情况下，为了简单起见，我们会取 @math{X = \mathbb{R}^2}，并令所有 @math{f_i, \forall i} 为仿射变换。最著名的例子就是谢尔宾斯基三角形（Sierpinski triangle），它由以下三个函数生成：
    }
    @dmath{
\begin{align*}
& f_1(x,y) = (\frac{x}{2}, \frac{y}{2}) \\
& f_2(x,y) = (\frac{x}{2} + \frac{1}{2}, \frac{y}{2}) \\
& f_3(x,y) = (\frac{x}{2} + \frac{1}{4}, \frac{y}{2} + \frac{\sqrt{3}}{4})
\end{align*}
}
    @para{
      更多例子可以在@link["http://larryriddle.agnesscott.org/ifs/ifs.htm"]{这里}找到。多亏了@link["https://math.stackexchange.com/questions/1896127/why-does-the-chaos-game-generate-a-fractal"]{混沌游戏算法（chaos game algorithm）}，只需不断从集合中随机挑选函数并作用于当前点，就能轻松绘制出 IFS。这个应用的核心骨架就这样完成了……
    }
    @code-block["swift"]|{
class IFSSystem {
    var position: CGPoint = CGPoint(x: 0.5, y: 0.5) // Some random point
    var transforms: [CGAffineTransform]

    init(_ t: [CGAffineTransform]) {
        transforms = t
    }

    func chaosGameStep() -> CGPoint {
        let selected = Int.random(in: 0..<transforms.count)
        position = position.applying(transforms[selected])
        return position
    }
}
}|
    @para{
      ……实际上只用了三行代码（多亏了 CoreGraphics，不然我还得多写十行）。现在只剩下让它具备交互性和直观性了。关键在于将变换 @math{f} 可视化。既然它是仿射变换，可以分解为线性变换和平移，我们就可以用平行四边形来表示它：其中一个顶点表示平移，另外两个顶点表示线性变换。也就是说，对于变换：
    }
    @dmath{f(x,y) = \begin{bmatrix} a & b \\ c & d \end{bmatrix} \begin{bmatrix} x \\ y \end{bmatrix} + \begin{bmatrix} e \\ f \end{bmatrix}}
    @para{
      四个顶点分别是 @math{A(e,f)}、@math{B(a+e,c+f)}、@math{C(b+e,d+f)} 和 @math{D(a+b+e,c+d+f)}。实际上，@math{\overrightarrow{AB}} 和 @math{\overrightarrow{AC}} 就代表变换后的 @math{\hat{i}} 和 @math{\hat{j}}。
    }
    @para{理清这些之后，现在就可以轻松地将 IFS 系统可视化了。}
    @code-block["swift"]|{
func iterate(_ transforms: [CGAffineTransform]) {
    var newTs: [CGAffineTransform] = []
    for t in transforms {
        for t2 in transforms {
            newTs.append(
                t2.concatenating(t)
            )
        }
    }
    return newTs
}
}|
    @para{现在唯一剩下的就是实现 UI。}
    @para{
      在构造部分，我把平行四边形做成了可拖拽的。虽然用户无法精确控制坐标（也没这个必要），但依然能直观感受到变换的运作方式。
    }
    @img["/files/20230517/cons.png"]{构造}
    @para{
      在可视化部分，我做了一个“Iterate”按钮，点击就会调用上面的 @code{iterate} 函数并绘制新的平行四边形。
    }
    @img["/files/20230517/vis0.png"]{可视化 0}
    @img["/files/20230517/vis1.png"]{可视化 1}
    @img["/files/20230517/vis2.png"]{可视化 2}
    @para{这个过程可以一直继续下去，直到设备内存耗尽。}
    @para{
      最后在渲染部分，我利用上面的 @code{chaosGameStep} 函数将点绘制在屏幕上。为了让图像更好看，我给每个变换函数都加上了随机颜色。
    }
    @img["/files/20230517/ren.png"]{渲染}
    @para{
      最终生成的图像还可以放大，方便用户观察分形的自相似性。
    }
    @img["/files/20230517/ren-zoom.png"]{放大}
    @para{
      就是这样！应用大功告成。你可以在@link["https://github.com/yikerman/IFS"]{这里}找到源代码。
    }

    @heading["results"]{结果}
    @para{
      我在截止日期的最后一天提交了作品。虽然有点赶，但我觉得质量还算过得去。5 月 9 日出了结果，很遗憾，我落选了。我想主要原因在于这个应用不够“实用”。在那个密码学的例子中，非对称加密广泛应用于日常生活，确实非常重要。然而，IFS 只是一个数学概念，在现实生活中没什么实际用途。尽管结果如此，我依然认为这是一次很好的经历，我也从中收获良多。明年我一定会再接再厉。
    }
  })

(provide post)