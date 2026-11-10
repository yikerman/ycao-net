#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["坎巴拉虫跳：用 KSP 讲解 PID（Kerbalhopper: PID explained with KSP）" "2023-04-30" #:lang "zh"]{
    @heading["introduction"]{引言}
    @para{
      SpaceX 的星舰（Starship）试飞简直激动人心！按照老习惯，你决定在《坎巴拉太空计划》（Kerbal Space Program，简称 KSP）中把它复刻出来。或许先造一艘“星虫”（Starhopper）的仿制品会更明智。毕竟，只要起飞并在空中悬停几秒钟就行了，对吧？
    }
    @para{
      火箭的设计非常简单。你只需在罗克马克斯燃料箱（Rockomax Fuel Tank）下方装上一台“飞镖”引擎（Dart engine），再把着陆腿、无人控制核心和电池组装到一起，就可以准备发射了。
    }
    @img["/files/20230430/craft.png"]{坎巴拉虫跳飞船（KerbalHopper Craft）}
    @para{
      捣鼓了一番@link["/files/20230430/KerbalHopper.craft"]{这艘飞船}后，你决定把“飞到指定高度并保持悬停”的过程自动化。身为程序员，自动化对你来说是水到渠成的事。
    }
    @para{
      多亏了社区的贡献，一个名为 @link["https://github.com/krpc/krpc"]{krpc} 的模组暴露了 KSP 的底层 API。你可以用它编写脚本来控制飞船。
    }

    @heading["the-math-way"]{数学方法}
    @para{
      你想把这个过程转化为最优化问题来求解。简而言之，你需要求出一个函数
      @math{f: \mathbb{R} \mapsto [0,1], \text{time} \mapsto \text{throttle}}。
      根据牛顿定律：
    }
    @dmath{F = ma}
    @para{其中对应的 @math{F}、@math{m} 和 @math{a} 分别为：}
    @dmath{
\begin{align*}
& F = f(t) + mg + \text{drag}(\frac{\mathrm{d}x}{\mathrm{d}t}) \\
& m = \text{wet mass} - \text{fuel consumption}(\int_{0}^{t} f(u) \mathrm{d}u) \\
& a = \frac{\mathrm{d}^2 x}{\mathrm{d}t^2}
\end{align*}
}
    @para{并且你希望在某一时刻 @math{t_0} 满足：}
    @dmath{
\begin{align*}
& x = h \\
& \frac{\mathrm{d}x}{\mathrm{d}t} = 0
\end{align*}
}
    @para{
      好吧，情况似乎有些失控了。太多变量相互耦合，让你不禁怀疑有没有更好的办法。事实证明，这是一个工程问题：@bold{你不必寻找最优解，只需找到一个足够好的解。}
    }

    @heading["the-engineering-way"]{工程方法}
    @para{是时候发挥创造力了！}

    @para{@bold{P}}
    @para{
      一个很直观的思路是，让节流阀开度与距离目标高度 @math{h} 的剩余路程成正比。
    }
    @para{令 @math{E = h - x}，那么函数 @math{f} 可以写成：}
    @dmath{f = KE}
    @para{你用 Python 实现了这个逻辑：}
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
      尝试几次后，你发现无论 @math{K} 取什么值，飞船都无法稳定下来，而是在 @math{30} 到 @math{230} 的高度之间剧烈震荡。这个方法还需要改进。
    }

    @para{@bold{D}}
    @para{
      回想一下手动维持高度时的操作：当接近目标高度时，你会尽量避免飞船飞得太快。
    }
    @para{
      如何用数学语言描述@it{接近时不要太快}呢？没错，就是
      @math{-\frac{\mathrm{d}x}{\mathrm{d}t} = \frac{\mathrm{d}E}{\mathrm{d}t}}。
      同样，你取这个值，给它乘上一个常数 @math{K_d}，然后祈祷它能奏效。
    }
    @dmath{f = K_p E + K_d \frac{\mathrm{d}E}{\mathrm{d}t}}
    @para{你用 Python 实现了这个逻辑：}
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
      这招奏效了！飞船现在能把节流阀维持在合理的范围内。@math{K_p} 控制着到达高度 @math{h} 的@it{快慢}，而 @math{K_d} 则控制着接近高度 @math{h} 时的@it{平缓程度}。
    }
    @img["/files/20230430/pd.png"]{悬停在 180 米高度}
    @para{
      然而，飞船卡在了 @math{200} 米下方的某个位置。你拿起笔，试着计算它在哪里达到了平衡，即满足 @math{\text{thrust}=\text{gravity}} 的位置：
    }
    @dmath{
\begin{align*}
f = mg \\
K_p (h-x) + 0 = mg \\
x = -\frac{mg}{K_p} + h
\end{align*}
}
    @para{
      @math{h-x = \frac{mg}{K_p}}，这意味着火箭永远无法真正到达目标高度 @math{h}！
    }

    @para{@bold{I}}
    @para{
      你已经尝试将 @math{E} 和 @math{E'} 纳入考量，但都无法消除这个偏差。如果眼看着飞船迟迟达不到高度 @math{h}，你会怎么做？随着时间推移，你会渐渐失去耐心，然后推大节流阀。那么，该如何衡量@it{逐渐失去耐心}的过程呢？没错，就是 @math{\int E \mathrm{d}t}！照例，你给它乘上一个常数 @math{K_i}，并期盼它能管用。
    }
    @dmath{f = K_p E + K_d \frac{\mathrm{d}E}{\mathrm{d}t} + K_i \int^{t}_{0} E \mathrm{d}u}
    @para{你用 Python 实现了这个逻辑：}
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
    @img["/files/20230430/pid.png"]{悬停在 200 米高度}
    @para{
      大功告成！你的努力得到了回报。飞船现在稳稳地悬停在离地 @math{200} 米的空中。你可以靠在椅背上放松一下，静待燃料耗尽了！
    }

    @heading["conclusion"]{结语}
    @para{
      这个方法既奇妙又具有优美的对称性。@math{K_p E} 把控当下，@math{K_d \frac{\mathrm{d}E}{\mathrm{d}t}} 预测未来，而 @math{K_i \int E \mathrm{d}t} 则铭记过去。这短短 28 行代码的简洁与高效令你着迷——它甚至没有对你所交互的系统做任何假设。同样的法则在杜纳星（Duna）和伊芙星（Eve）上依然适用。你决定取 @bold{P}roposal（比例）、@bold{I}ntegral（积分）和 @bold{D}erivative（微分）的首字母，将它命名为 @bold{PID}。
    }
    @para{
      ……然后你沮丧地发现，它早在 20 世纪 40 年代就被发明出来了，甚至还有一个专门的@link["https://en.wikipedia.org/wiki/PID_controller"]{维基百科页面}。
    }
    @para{
      @bold{本文的源代码可以在@link["https://github.com/yikerman/simple-kerbalhopper"]{这里}找到。}
    }
  })

(provide post)