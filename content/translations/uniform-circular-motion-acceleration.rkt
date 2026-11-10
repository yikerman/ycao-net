#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["Derivation of Acceleration in Uniform Circular Motion" "2022-07-12"]{
    @para{
      The People's Education Press textbook @bold{Physics: Compulsory Book 2} skips the derivation of centripetal force for uniform circular motion, brushing it off with vague hand-waving like @code{precise experiments show that the magnitude of centripetal force can be expressed as... or...}. This article aims to help high school students understand the origin of the formula.
    }
    @para{
      Consider an object moving along a circle. Let the radius of the circular motion be @math{r}, the linear speed be @math{v}, the angular velocity be @math{\omega}, the linear velocities at times @math{0} and @math{t} be @math{\vec{v_{i}}} and @math{\vec{v_{j}}}, and the angle swept during this interval be @math{\alpha}. Clearly, @math{\lvert \vec{v_{i}} \rvert = \lvert \vec{v_{j}} \rvert = v}, and both vectors are tangent to the circle.
    }
    @para{The average acceleration during this time interval is}
    @dmath{\vec{a} = \frac{\vec{v_{j}}-\vec{v_{i}}}{t}}
    @para{As @math{t\rightarrow 0}, @math{\vec{a}} becomes the instantaneous acceleration.}
    @img["/files/20220712/1.png"]

    @para{
      As we can see in the formula, we need to subtract the two vectors. To make the calculation easier, we can translate the two vectors so that they are placed tail-to-tail. From the properties of tangent lines, we can see that the angle @math{\alpha_{1}} between the translated vectors @math{\vec{v_{i}'}} and @math{\vec{v_{j}'}} satisfies @math{\alpha_{1}=\alpha}.
    }
    @img["/files/20220712/2.png"]

    @para{
      We can draw @math{\overrightarrow{\triangle v}=\vec{v_{j}'}-\vec{v_{i}'}} in the diagram. If you are unfamiliar with vector subtraction, you can think of it as @math{\overrightarrow{\triangle v}+\vec{v_{i}'}=\vec{v_{j}'}}, meaning @math{\vec{v_{i}'}} plus a certain vector equals @math{\vec{v_{j}'}}.
    }
    @img["/files/20220712/3.png"]

    @para{
      The next step is crucial. Since @math{AB=AC}, @math{DE=DF}, and @math{\alpha_{1}=\alpha}, we can prove that @math{\triangle ABC \sim \triangle DEF}. Therefore,
    }
    @dmath{\frac{\lvert \overrightarrow{\triangle v} \rvert}{\lvert \vec{v_{i}'} \rvert} = \frac {BC} {AB} = \frac {BC} {r}}
    @para{
      Since we are solving for instantaneous acceleration, as @math{t\rightarrow 0}, we have @math{\alpha \rightarrow 0} and @math{BC \rightarrow \overset{\LARGE\frown}{BC}}. Thus,
    }
    @dmath{\frac{\lvert \overrightarrow{\triangle v} \rvert}{\lvert \vec{v_{i}'} \rvert} = \frac {\overset{\LARGE\frown}{BC}} {r} = \frac {\alpha r} {r} = \alpha}
    @dmath{\lvert \overrightarrow{\triangle v} \rvert = \alpha \lvert \vec{v_{i}'} \rvert = \alpha v}
    @img["/files/20220712/4.png"]

    @para{Substituting the obtained @math{\lvert \overrightarrow{\triangle v} \rvert} into the expression for @math{\vec{a}}, we can find the magnitude of the instantaneous acceleration:}
    @dmath{\lvert \vec{a} \rvert = \lvert \frac{\vec{v_{j}}-\vec{v_{i}}}{t} \rvert = \frac{\lvert \overrightarrow{\triangle v} \rvert}{t} = \frac{\alpha v}{t}}
    @para{From the definitions of linear velocity and angular velocity, we obtain}
    @dmath{\lvert \vec{a} \rvert = v \omega}
    @para{However, this is only the magnitude of the acceleration. Observe the following diagram:}
    @img["/files/20220712/5.png"]
    @para{
      It is easy to see that as @math{t \rightarrow 0}, @math{\alpha_{1} \rightarrow 0}. At this point, @math{\overrightarrow{\triangle v}} is perpendicular to the tangent of the circle, meaning that @math{\vec{a}} points toward the center of the circle.
    }
  })

(provide post)