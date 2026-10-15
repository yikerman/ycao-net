#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["我的 2023 年 Swift 学生挑战赛" "2023-05-17" #:lang "zh"]{
    @para{啊，Swift 学生挑战赛，我们最亲爱的苹果一年一度的比赛。}
    @para{早在看到一份入选作品向用户介绍非对称密码学的时候，我就决定做几个教育类 App。事实上，我心里列了好几个灵感：}
    @ol{
      @item{结合 AR 技术，展示四维物体投影到三维空间的样子。}
      @item{从“为什么有些人唱歌比别人好听”入手，介绍信号处理。}
      @item{介绍迭代函数系统，说明数学也可以既有趣又美。}
    }
    @para{最后我选了第三个，因为它最容易上手，而我的时间又很有限。还因为围绕这个概念，我做过一个小 App @link["https://github.com/yikerman/QIFS"]{QIFS}。（不过代码库很乱，也没再维护。）}

    @heading["ifs"]{IFS}
    @para{简而言之，IFS 是度量空间 @math{X} 上的一组函数 @math{\lbrace f_i: X \mapsto X \mid i \in [1,n] \rbrace, n \subset \mathbb{N}}。它的图像通过把下面这个过程重复无穷多次得到：}
    @dmath{S \gets \bigcup_{i=1}^{n} \bigcup_{s \in S} f_i(s)}
    @para{多数情况下，我们想让事情简单些，所以取 @math{X = \mathbb{R}^2}，并让 @math{f_i, \forall i} 都是仿射变换。最有名的例子是谢尔宾斯基三角形，它由下面三个函数生成：}
    @dmath{
\begin{align*}
& f_1(x,y) = (\frac{x}{2}, \frac{y}{2}) \\
& f_2(x,y) = (\frac{x}{2} + \frac{1}{2}, \frac{y}{2}) \\
& f_3(x,y) = (\frac{x}{2} + \frac{1}{4}, \frac{y}{2} + \frac{\sqrt{3}}{4})
\end{align*}
}
    @para{更多例子可以在 @link["http://larryriddle.agnesscott.org/ifs/ifs.htm"]{这里} 找到。多亏 @link["https://math.stackexchange.com/questions/1896127/why-does-the-chaos-game-generate-a-fractal"]{混沌游戏算法}，只要不断从集合中随机选一个函数，作用到当前点上，就能轻松绘出 IFS。于是这个 App 的骨架就完成了……}
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
    @para{……实际上只有 3 行代码（多亏有 CoreGraphics，否则我还得再加 10 行）。现在只剩把它做得可交互、直观。关键是把变换 @math{f} 可视化。我们知道它是仿射变换，可以分解为线性变换和平移。我们可以用一个平行四边形来表示：一个点表示平移，另外两个点表示线性变换。也就是说，对于变换：}
    @dmath{f(x,y) = \begin{bmatrix} a & b \\ c & d \end{bmatrix} \begin{bmatrix} x \\ y \end{bmatrix} + \begin{bmatrix} e \\ f \end{bmatrix}}
    @para{四个点是 @math{A(e,f)}、@math{B(a+e,c+f)}、@math{C(b+e,d+f)} 和 @math{D(a+b+e,c+d+f)}。实际上，@math{\overrightarrow{AB}} 与 @math{\overrightarrow{AC}} 分别表示变换后的 @math{\hat{i}} 和 @math{\hat{j}}。}
    @para{记住这些，现在就能轻松地把 IFS 系统可视化。}
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
    @para{现在只剩实现 UI 了。}
    @para{构造部分，我把平行四边形做成了可拖拽的。虽然用户无法精确控制坐标（也没必要），但仍能感受到变换是怎么起作用的。}
    @img["/files/20230517/cons.png"]{构造}
    @para{可视化部分，我做了一个“迭代”按钮，它会调用上面的 @code{iterate} 函数，并绘制新的平行四边形。}
    @img["/files/20230517/vis0.png"]{可视化 0}
    @img["/files/20230517/vis1.png"]{可视化 1}
    @img["/files/20230517/vis2.png"]{可视化 2}
    @para{它可以一直继续下去，直到设备内存耗尽。}
    @para{最后是渲染部分，我用上面的 @code{chaosGameStep} 函数，把点画到屏幕上。为了让图像更好看，我给每个变换函数加了随机颜色。}
    @img["/files/20230517/ren.png"]{渲染}
    @para{最终图像还可以放大，让用户看到分形的自相似性。}
    @img["/files/20230517/ren-zoom.png"]{放大}
    @para{就这样！App 完成了。源代码可以在 @link["https://github.com/yikerman/IFS"]{这里} 找到。}

    @heading["results"]{结果}
    @para{我在提交期最后一天提交了 App。有点赶，但我觉得还能接受。5 月 9 日我收到了结果。很遗憾，我没有入选。我觉得主要原因是这个 App 不太“有用”。在密码学那个例子里，非对称密码学在日常生活中会用到，确实相当重要。但 IFS 只是一个数学概念，在现实生活中不太有用。尽管结果如此，我仍然觉得这是一次很好的经历，也从中学到了很多。明年我一定会再试。}
  })

(provide post)