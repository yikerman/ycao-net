#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["Kerbalhopper：用 KSP 讲解 PID" "2023-04-30" #:lang "zh"]{
    @heading["introduction"]{引言}
    @para{
      SpaceX 的星舰试飞真是激动人心！你老毛病不改，决心在《坎巴拉太空计划》里复刻一番。
      也许先造一个 Starhopper 的仿制品才是明智之举。毕竟，你只需要起飞并在几秒内保持高度，对吧？
    }
    @para{
      火箭设计很简单。只要在 Rockomax 燃料罐下面装一台 Dart 引擎，再把着陆腿、探测核心和电池组合到一起，就可以发射了。
    }
    @img["/files/20230430/craft.png"]{KerbalHopper 飞行器}
    @para{
      把 @link["/files/20230430/KerbalHopper.craft"]{这架飞行器} 摆弄一阵后，你决定把“飞到某个高度并保持住”这件事自动化。身为程序员，自动化对你来说再自然不过。
    }
    @para{
      多亏社区，一个名为 @link["https://github.com/krpc/krpc"]{krpc} 的模组暴露了 KSP 的底层 API。你可以用它写脚本来控制飞行器。
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
    @para{你希望在某个时刻 @math{t_0} 满足：}
    @dmath{
\begin{align*}
& x = h \\
& \frac{\mathrm{d}x}{\mathrm{d}t} = 0
\end{align*}
}
    @para{
      好吧，事情似乎开始失控了。彼此影响的变量太多。你想知道有没有更好的办法。结果发现，这其实是个工程问题：@bold{你不必找到最优解，只需要找到一个足够好的解。}
    }

    @heading["the-engineering-way"]{工程方法}
    @para{该发挥创造力了！}

    @para{@bold{P}}
    @para{
      一个很直接的办法，是让油门与距离目标高度 @math{h} 还差多少成正比。
    }
    @para{令 @math{E = h - x}，那么你的 @math{f} 可以写成：}
    @dmath{f = KE}
    @para{然后把它用 Python 实现：}
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
      试了几次后，你发现无论 @math{K} 取什么值都不管用。飞船在 @math{30} 和 @math{230} 之间剧烈振荡。这个方法还得打些补丁。
    }

    @para{@bold{D}}
    @para{
      回想一下，你试图保持高度时会怎么做：当接近目标高度时，你会尽量不让飞船飞得太快。
    }
    @para{
      怎么描述@it{接近时不要飞得太快}？对，就是 @math{-\frac{\mathrm{d}x}{\mathrm{d}t} = \frac{\mathrm{d}E}{\mathrm{d}t}}。
      照旧，你取来这个值，乘上一个常数 @math{K_d}，然后希望它能奏效。
    }
    @dmath{f = K_p E + K_d \frac{\mathrm{d}E}{\mathrm{d}t}}
    @para{然后把它用 Python 实现：}
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
      这方法奏效了！飞船现在倾向于把油门保持在合适的范围内。@math{K_p} 控制你希望多@it{快}到达 @math{h}，@math{K_d} 控制到达 @math{h} 的过程有多@it{平缓}。
    }
    @img["/files/20230430/pd.png"]{在高度 180 处悬停}
    @para{
      然而，飞船卡在 @math{200} 下方的某个位置。你拿起笔，想算出它在何处达到平衡，也就是 @math{\text{thrust}=\text{gravity}}：
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
      你已经试着把 @math{E} 和 @math{E'} 都考虑进去，但它们都没帮上忙。如果你发现飞船到不了 @math{h}，会怎么做？随着时间推移，你会渐渐不耐烦，然后加大油门。怎么衡量@it{你自己失去耐心}？对，就是 @math{\int E \mathrm{d}t}！照旧，你给它乘上一个常数 @math{K_i}，然后希望它能奏效。
    }
    @dmath{f = K_p E + K_d \frac{\mathrm{d}E}{\mathrm{d}t} + K_i \int^{t}_{0} E \mathrm{d}u}
    @para{然后把它用 Python 实现：}
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
    @img["/files/20230430/pid.png"]{在高度 200 处悬停}
    @para{
      就这样！你的努力有了回报。飞船现在悬停在地面上方 @math{200} 米处。你可以靠回椅背放松一下，直到它把燃料烧完！
    }

    @heading["conclusion"]{结论}
    @para{
      这方法古怪，却带着些漂亮的对称性。
      @math{K_p E} 控制当下，@math{K_d \frac{\mathrm{d}E}{\mathrm{d}t}}
      预测未来，@math{K_i \int E \mathrm{d}t} 反映过去。这 28 行代码如此简单又有效，令你着迷——它对你所交互的系统没有做任何假设。同样的规律在 Duna 和 Eve 上依然成立。你决定叫它 @bold{PID}，分别取 @bold{P}roposal、@bold{I}ntegral 和 @bold{D}erivative 的首字母。
    }
    @para{
      ……然后你沮丧地发现，这东西早在 1940 年代就被发明了。它甚至还有一页 @link["https://en.wikipedia.org/wiki/PID_controller"]{维基百科页面}。
    }
    @para{
      @bold{本文的源代码可以在 @link["https://github.com/yikerman/simple-kerbalhopper"]{这里} 找到。}
    }
  })

(provide post)