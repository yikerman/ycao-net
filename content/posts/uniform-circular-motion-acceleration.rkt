#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post-uniform-circular-motion-acceleration
  @article["匀速圆周运动加速度的推导" "2022-07-12"]{
    @para{
      人教版的物理必修二中跳过了对匀速圆周运动的向心力的推导，用@code{精确的实验表明，向心力的大小可以表示为...或...}这一套模糊的说辞蒙混过关了。这篇文章旨在帮助高中生理解公式的来历。
    }
    @para{
      考虑一个物体在圆周上运动。我们记圆周运动的半径为@math{r}，线速率为@math{v}，角速度为@math{\omega}，@math{0}和@math{t}时刻的线速度为@math{\vec{v_{i}}}和@math{\vec{v_{j}}}，经过的角度为@math{\alpha}，易知@math{\lvert \vec{v_{i}} \rvert = \lvert \vec{v_{j}} \rvert = v}，且都与圆相切。
    }
    @para{这一段时间中的平均加速度为}
    @dmath{\vec{a} = \frac{\vec{v_{j}}-\vec{v_{i}}}{t}}
    @para{当@math{t\rightarrow 0}时候@math{\vec{a}}为瞬时加速度。}
    @img["/files/20220712/1.png"]

    @para{
      可以看到在式子中我们要将两个向量相减。我们可以通过平移把两个向量尾尾相接便于计算。由切线的性质，可以发现平移后的@math{\vec{v_{i}'}}和@math{\vec{v_{j}'}}夹角@math{\alpha_{1}=\alpha}。
    }
    @img["/files/20220712/2.png"]

    @para{
      我们可以在图片中画出@math{\overrightarrow{\triangle v}=\vec{v_{j}'}-\vec{v_{i}'}}。不熟悉向量减法的可以用@math{\overrightarrow{\triangle v}+\vec{v_{i}'}=\vec{v_{j}'}}思考，即@math{\vec{v_{i}'}}加上一个向量等于@math{\vec{v_{j}'}}。
    }
    @img["/files/20220712/3.png"]

    @para{
      接下来一步至关重要。由于@math{AB=AC}，@math{DE=DF}，@math{\alpha_{1}=\alpha}，可以证明@math{\triangle ABC \sim \triangle DEF}。所以
    }
    @dmath{\frac{\lvert \overrightarrow{\triangle v} \rvert}{\lvert \vec{v_{i}'} \rvert} = \frac {BC} {AB} = \frac {BC} {r}}
    @para{
      由于我们在求解瞬时加速度，@math{t\rightarrow 0}时@math{\alpha \rightarrow 0}，@math{BC \rightarrow \overset{\LARGE\frown}{BC}}，所以
    }
    @dmath{\frac{\lvert \overrightarrow{\triangle v} \rvert}{\lvert \vec{v_{i}'} \rvert} = \frac {\overset{\LARGE\frown}{BC}} {r} = \frac {\alpha r} {r} = \alpha}
    @dmath{\lvert \overrightarrow{\triangle v} \rvert = \alpha \lvert \vec{v_{i}'} \rvert = \alpha v}
    @img["/files/20220712/4.png"]

    @para{将得到的@math{\lvert \overrightarrow{\triangle v} \rvert}代入@math{\vec{a}}，可以求出瞬时加速度的大小}
    @dmath{\lvert \vec{a} \rvert = \lvert \frac{\vec{v_{j}}-\vec{v_{i}}}{t} \rvert = \frac{\lvert \overrightarrow{\triangle v} \rvert}{t} = \frac{\alpha v}{t}}
    @para{由线速度和角速度的定义，可以得到}
    @dmath{\lvert \vec{a} \rvert = v \omega}
    @para{但这只是加速度的大小。观察以下图像：}
    @img["/files/20220712/5.png"]
    @para{
      易得当@math{t \rightarrow 0}时@math{\alpha_{1} \rightarrow 0}，此时@math{\overrightarrow{\triangle v}}与圆的切线垂直，即@math{\vec{a}}朝向圆心。
    }
  })

(provide post-uniform-circular-motion-acceleration)
