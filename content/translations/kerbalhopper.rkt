#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["Kerbalhopper：用 KSP 解释 PID" "2023-04-30" #:lang "zh"]{
    @heading["introduction"]{引言}
    @para{
      SpaceX 的星舰试飞太刺激了！你旧习难改，决心在《坎巴拉太空计划》里复刻一遍。
      也许先造一个 Starhopper 的仿制品比较明智。毕竟，你只需要起飞，再把高度维持几秒，对吧？
    }
    @para{
      火箭设计很直接。只需在 Rockomax 燃料罐下面装一台 Dart 引擎，再把着陆腿、探测核心和电池拼到一起，就能发射了。
    }
    @img["/files/20230430/craft.png"]{KerbalHopper 飞行器}
    @para{
      摆弄过
      @link["/files/20230430/KerbalHopper.craft"]{这艘飞行器} 之后，你决定
      把这个“飞到某个高度并保持住”的过程自动化。作为程序员，自动化对你来说再自然不过。
    }
    @para{
      多亏社区，一个叫
      @link["https://github.com/krpc/krpc"]{krpc} 的模组暴露了 KSP 的底层 API。你可以用它写脚本来控制飞行器。
    }

    @heading["the-math-way"]{数学方法}
    @para{
      你想把这个问题转化为优化问题来解决。简而言之，你需要找出一个函数
      @math{f: \mathbb{R} \mapsto [0,1], \text{time} \mapsto \text{throttle}}。
      根据牛顿定律：
    }
    @dmath{F = ma}
    @para{其中对应的 @math{F}、@math{m} 和 @math{a} 分别是：}
    @dmath{
\begin{align*}
& F = f(t) + mg + \text{drag}(\frac{\mathrm{d}x}{\mathrm{d}t}) \\
& m = \text{wet mass} - \text{fuel consumption}(\int_{0}^{t} f(u) \mathrm{d}u) \\
& a = \frac{\mathrm{d}^2 x}{\mathrm{d}t^2}
\end{align*}
}
    @para{而你希望在某个时刻 @math{t_0}：}
    @dmath{
\begin{align*}
& x = h \\
& \frac{\mathrm{d}x}{\mathrm{d}t} = 0
\end{align*}
}
    @para{
      好吧，局面似乎开始失控了。变量太多，彼此影响。你想知道有没有更好的做法。结果发现这其实是个工程问题：@bold{你不必找到最优解，只要找到足够好的解就行。}
    }

    @heading["the-engineering-way"]{工程方法}
    @para{该发挥创造力了！}

    @para{@bold{P}}
    @para{
      一个很直接的办法，是让油门大小与距离目标高度 @math{h} 还差多少成正比。
    }
    @para{令 @math{E = h - x}，那么 @math{f} 可以写成：}
    @dmath{f = KE}
    @para{你把它用 Python 实现出来：}
    @code-block["python"]|{
import krpc, time

HEIGHT = 200
K = 0.01 # Some constant?
DELTA_T = 0.01


class Controller:
    def __init__(
        self,
        target: float,
        k: float
    ) -> None:
        self.target = target
        self.k = k

    def step(self, current: float, dt: float) -> float:
        # f = KE
        error = self.target - current
        return error * self.k


def main():
    conn = krpc.connect(name="KerbalHopper Controller")
    vessel = conn.space_center.active_vessel
    controller = Controller(
        target=HEIGHT,
        k=K,
    )

    input("Press enter to launch.")
    vessel.control.activate_next_stage()

    while True:
        flight = vessel.flight()
        alt = flight.surface_altitude
        throttle = controller.step(
            current=alt,
            dt=DELTA_T
        )
        vessel.control.throttle = throttle
        print(
            "Altitude: {alt} Throttle: {throttle}".format(
                alt=alt,
                throttle=throttle,
            )
        )
        time.sleep(DELTA_T)

if __name__ == "__main__":
    main()
}|
    @para{
      试了几次之后，你发现无论 @math{K} 取什么值，飞行器都到不了目标。飞船在 @math{30} 和
      @math{230} 之间剧烈振荡。这个方法需要一些变通。
    }

    @para{@bold{D}}
    @para{
      回想一下你维持高度时会怎么做：当飞船接近目标高度时，你会尽量不让它飞得太快。
    }
    @para{
      怎么描述@it{接近时不要太快}？没错，就是
      @math{-\frac{\mathrm{d}x}{\mathrm{d}t} = \frac{\mathrm{d}E}{\mathrm{d}t}}。
      于是你又取来这个值，乘上一个常数 @math{K_d}，盼着它管用。
    }
    @dmath{f = K_p E + K_d \frac{\mathrm{d}E}{\mathrm{d}t}}
    @para{你把它用 Python 实现出来：}
    @code-block["python"]|{
import krpc, time

HEIGHT = 200
KP = 0.02
KD = 0.008 # Some more constant!
DELTA_T = 0.01


class Controller:
    def __init__(self, target: float, kp: float, kd: float) -> None:
        self.target = target
        self.kp = kp
        self.kd = kd
        self.last_error = 0

    def step(self, current: float, dt: float) -> float:
        error = self.target - current

        p = error * self.kp

        # discrete version of dE
        dE = (error - self.last_error) / dt
        d = self.kd * dE

        self.last_error = error
        return p + d


def main():
    conn = krpc.connect(name="KerbalHopper Controller")
    vessel = conn.space_center.active_vessel
    controller = Controller(
        target=HEIGHT,
        kp=KP,
        kd=KD,
    )
    # ...snip
}|
    @para{
      方法奏效了！飞船现在会把油门大致保持在合适的范围内。@math{K_p} 控制你希望多@it{快}到达
      @math{h}，@math{K_d} 控制到达 @math{h} 时有多@it{从容}。
    }
    @img["/files/20230430/pd.png"]{悬停在高度 180}
    @para{
      可是，飞船卡在 @math{200} 下方某处。你拿起笔，试着算它会在哪里达到平衡，也就是
      @math{\text{thrust}=\text{gravity}}：
    }
    @dmath{
\begin{align*}
f = mg \\
K_p (h-x) + 0 = mg \\
x = -\frac{mg}{K_p} + h
\end{align*}
}
    @para{
      @math{h-x = \frac{mg}{K_p}}，这意味着火箭永远到不了目标高度 @math{h}！
    }

    @para{@bold{I}}
    @para{
      你已经试过把 @math{E} 和 @math{E'} 考虑进去，但都没用。如果你发现飞船到不了
      @math{h}，你会怎么办？随着时间推移，你会渐渐不耐烦，然后加大油门。怎么衡量@it{你自己逐渐失去耐心}？没错，就是
      @math{\int E \mathrm{d}t}！照例，你乘上一个常数 @math{K_i}，盼着它管用。
    }
    @dmath{f = K_p E + K_d \frac{\mathrm{d}E}{\mathrm{d}t} + K_i \int^{t}_{0} E \mathrm{d}u}
    @para{你把它用 Python 实现出来：}
    @code-block["python"]|{
import krpc, time

HEIGHT = 200
KP = 0.02
KI = 0.001
KD = 0.01
DELTA_T = 0.01


class Controller:
    def __init__(
            self,
            target: float,
            kp: float,
            kd: float,
            ki: float
    ) -> None:
        self.target = target
        self.kp = kp
        self.kd = kd
        self.ki = ki
        self.last_error = 0
        self.integral = 0

    def step(self, current: float, dt: float) -> float:
        error = self.target - current

        p = error * self.kp

        dE = (error - self.last_error) / dt
        d = self.kd * dE

        i = self.ki * self.integral

        self.last_error = error
        self.integral += error * dt

        return p + d + i


def main():
    conn = krpc.connect(name="KerbalHopper Controller")
    vessel = conn.space_center.active_vessel
    controller = Controller(
        target=HEIGHT,
        kp=KP,
        kd=KD,
        ki=KI,
    )

    input("Press enter to launch.")
    vessel.control.activate_next_stage()

    while True:
        flight = vessel.flight()
        alt = flight.surface_altitude
        throttle = controller.step(current=alt, dt=DELTA_T)
        vessel.control.throttle = throttle
        print(
            "Altitude: {alt} Throttle: {throttle}".format(
                alt=alt,
                throttle=throttle,
            )
        )
        time.sleep(DELTA_T)


if __name__ == "__main__":
    main()
}|
    @img["/files/20230430/pid.png"]{悬停在高度 200}
    @para{
      成了！你的努力有了回报。飞船现在悬停在地面上方 @math{200} 米处。你可以坐等它把燃料烧完，好好放松一下了！
    }

    @heading["conclusion"]{结论}
    @para{
      这个方法真古怪，却有着漂亮的对称性。@math{K_p E} 掌控当下，@math{K_d \frac{\mathrm{d}E}{\mathrm{d}t}}
      预测未来，@math{K_i \int E \mathrm{d}t} 反映过去。这 28 行代码如此简单有效，令你着迷——它没有对你所交互的系统做任何假设。同样的规律在 Duna 和 Eve 上依然成立。你决定叫它 @bold{PID}，取
      @bold{P}roportional、@bold{I}ntegral 和 @bold{D}erivative 的首字母。
    }
    @para{
      ……然后你郁闷地发现，它早在 1940 年代就被发明了。它甚至还有一个
      @link["https://en.wikipedia.org/wiki/PID_controller"]{维基百科页面}。
    }
    @para{
      @bold{本文的源代码可以在
      @link["https://github.com/yikerman/simple-kerbalhopper"]{这里} 找到。}
    }
  })

(provide post)