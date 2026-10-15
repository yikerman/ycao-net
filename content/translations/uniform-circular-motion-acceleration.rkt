#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["Derivation of the Acceleration of Uniform Circular Motion" "2022-07-12"]{
    @para{
      The PEP edition of Physics Compulsory 2 skips the derivation of the centripetal force for uniform circular motion, glossing over it with the vague statement @code{Precise experiments show that the magnitude of the centripetal force can be expressed as ... or ...}. This article aims to help high school students understand where the formula comes from.
    }
    @para{
      Consider an object moving on a circle. Let the radius of the circular motion be @math{r}, the linear speed be @math{v}, the angular velocity be @math{\omega}, the linear velocities at times @math{0} and @math{t} be @math{\vec{v_{i}}} and @math{\vec{v_{j}}}, and the angle swept be @math{\alpha}. It is easy to see that @math{\lvert \vec{v_{i}} \rvert = \lvert \vec{v_{j}} \rvert = v}, and both are tangent to the circle.
    }
    @para{The average acceleration during this time interval is}
    @dmath{\vec{a} = \frac{\vec{v_{j}}-\vec{v_{i}}}{t}}
    @para{When @math{t\rightarrow 0}, @math{\vec{a}} is the instantaneous acceleration.}
    @img["/files/20220712/1.png"]

    @para{
      We can see that in the expression we need to subtract the two vectors. We can translate the two vectors so that their tails meet, which makes the calculation easier. From the properties of tangents, we can find that the angle between the translated @math{\vec{v_{i}'}} and @math{\vec{v_{j}'}} is @math{\alpha_{1}=\alpha}.
    }
    @img["/files/20220712/2.png"]

    @para{
      We can draw @math{\overrightarrow{\triangle v}=\vec{v_{j}'}-\vec{v_{i}'}} in the figure. Those who are not familiar with vector subtraction can think of it as @math{\overrightarrow{\triangle v}+\vec{v_{i}'}=\vec{v_{j}'}}, that is, @math{\vec{v_{i}'}} plus a vector equals @math{\vec{v_{j}'}}.
    }
    @img["/files/20220712/3.png"]

    @para{
      The next step is crucial. Since @math{AB=AC}, @math{DE=DF}, and @math{\alpha_{1}=\alpha}, we can prove that @math{\triangle ABC \sim \triangle DEF}. Therefore
    }
    @dmath{\frac{\lvert \overrightarrow{\triangle v} \rvert}{\lvert \vec{v_{i}'} \rvert} = \frac {BC} {AB} = \frac {BC} {r}}
    @para{
      Since we are finding the instantaneous acceleration, as @math{t\rightarrow 0}, @math{\alpha \rightarrow 0} and @math{BC \rightarrow \overset{\LARGE\frown}{BC}}, so
    }
    @dmath{\frac{\lvert \overrightarrow{\triangle v} \rvert}{\lvert \vec{v_{i}'} \rvert} = \frac {\overset{\LARGE\frown}{BC}} {r} = \frac {\alpha r} {r} = \alpha}
    @dmath{\lvert \overrightarrow{\triangle v} \rvert = \alpha \lvert \vec{v_{i}'} \rvert = \alpha v}
    @img["/files/20220712/4.png"]

    @para{Substituting the obtained @math{\lvert \overrightarrow{\triangle v} \rvert} into @math{\vec{a}}, we can find the magnitude of the instantaneous acceleration}
    @dmath{\lvert \vec{a} \rvert = \lvert \frac{\vec{v_{j}}-\vec{v_{i}}}{t} \rvert = \frac{\lvert \overrightarrow{\triangle v} \rvert}{t} = \frac{\alpha v}{t}}
    @para{From the definitions of linear velocity and angular velocity, we can obtain}
    @dmath{\lvert \vec{a} \rvert = v \omega}
    @para{But this is only the magnitude of the acceleration. Observe the following figure:}
    @img["/files/20220712/5.png"]
    @para{
      It is easy to see that when @math{t \rightarrow 0}, @math{\alpha_{1} \rightarrow 0}; at this time @math{\overrightarrow{\triangle v}} is perpendicular to the tangent of the circle, that is, @math{\vec{a}} points toward the center of the circle.
    }
  })

(provide post)