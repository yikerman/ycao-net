#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["Thoughts after Playing Oxygen Not Included" "2026-10-21"]{
    @para{
      I've owed Oxygen Not Included this post for a long time. This game has cost me 676 hours of my precious youth. The more I think about it, the more I find its design ingenious and hard to improve.
    }
    @img["/files/20261021/yuhua.webp" #:scale 0.4]{Damn, this is so badass, holy shit}
    @para{
      The purpose of games (note that this is different from “alienated entertainment.” I absolutely detest works whose primary purpose is profit, such as online games; in essence this is the capitalist exploitation of users' attention, the same critique leveled at short videos.) is no different from that of traditional art: in essence, both give the audience/player a specific emotional experience. On the basis of traditional art, games gain the tool of “interactivity,” greatly expanding the boundaries of artistic expression. @cite["sylvesterDesigningGamesGuide2013"]
    }
    @para{
      Oxygen Not Included's traditional storytelling is at best better than nothing, but it truly pushes the game-specific “interactivity” to the limit. Consider that Oxygen Not Included has the following main systems:
      @ul{
        @item{
          A simple one-tile, one-object cellular automaton heuristic solver
          @ul{
            @item{Naive heat diffusion}
            @item{Naive gas-liquid diffusion}
            @item{Naive matter phase transitions}
          }
        }
        @item{
          Graph structures overlaid on the cellular grid
          @ul{
            @item{Directed-graph gas/liquid/solid pipes}
            @item{Connected-graph power system}
            @item{Linear abstract machines, such as water electrolysis}
          }
        }
        @item{
          Duplicant priority-queue work and linear survival needs
        }
      }
    }
    @para{
      The primary advantage of the systems is simplicity. Most systems are simplified abstractions of physics that already exist in real life, reducing the player's cognitive load. Linear Duplicants and machines likewise make game behavior easy to predict (legible), and avoid the player being unable to make choices and designs under overly nonlinear or chaotic systems (non-decision). The premise that “Duplicants need to survive” (a fictional wrapper) also acts directly on the emotions, giving the player a clear goal and ample motivation.
    }
    @para{
      ONI's systems have excellent emergent properties. The most classic example is that “heat diffusion” and “directed-graph gas/liquid/solid pipes” can be combined to build counterflow heat exchange as in real industrial production. Thanks to the game's CA simulation, interesting and practically useful methods for players also emerge, such as “liquid locks,” “infinite storage,” and “vacuum insulation.” But these small components are only the tip of the iceberg. Consider a typical gameplay progression: “collect resources -> automate -> renewable.” Apart from the tech tree, most goals are indirectly designed and emerge during play. For example, “heat diffusion” is not only the operating principle of some machines but also drives the game's progression. Most “linear machines” interact with “heat diffusion” by generating heat; by the mid-game, regional overheating that prevents production is thrown at the player as a problem — the player's short-term solutions naturally become long-term problems. Ultimately the game, like Stellaris, interleaves short- and long-term goals, is predictable and emotionally grounded, and drives one to “play one more cycle.”
    }
    @para{
      Perhaps a game can be viewed as a dynamical system @math{x_{t+1}=f(x_t,u_t)}; after the player specifies a strategy, they enter a trajectory @math{G}. On the one hand, we do not want @math{G} to be too trivial; otherwise all the decisions the player makes are one-note and obvious. Nor do we want an overly complex or chaotic @math{G}; after all, playing games is not doing academic research. We hope that (after some tutorial) the player can have good intuition within the system and weigh trade-offs. ONI uses simple simulations (naive CA) to combine a relatively rich but well-behaved and predictable system, successfully achieving a perfect balance among intuitiveness, emergence, and simplicity.
    }
    @para{
      With this as a standard, we can consider other games that focus on interaction and system simulation:
      @ul{
        @item{Traditional 4X, such as Civilization and Stellaris - too many things are linear, so designers have to keep piling on extra content}
        @item{Minecraft (especially circuits) - too counterintuitive}
        @item{KSP - quite fun, but the systems are unintuitive, and it is severely lacking in guidance and goals}
        @item{Noita - flavor-stack computation and a lack of guidance; too hard to get into}
        @item{Factorio, Rim World - I haven't played them yet; they might be better than ONI. I'll have to give them a proper taste when I have time}
      }
      However, ONI also has some flaws. The most obvious is the universal solution: the famous liquid-cooling/steam-engine loop can directly delete heat from the environment, greatly reducing the solution space and undermining ONI's most innovative heat diffusion system. Likewise, ONI's guidance is not much better than KSP's and is another major obstacle that drives new players away.
    }
    @para{
      (My Chinese is hopelessly Europeanized; I really need to read more books.)
    }
  }
)

(provide post)