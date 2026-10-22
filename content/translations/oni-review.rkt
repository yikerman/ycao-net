#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["Thoughts on Playing Oxygen Not Included" "2026-10-21"]{
    @para{
      This post about Oxygen Not Included is long overdue. This game has cost me a precious six hundred and seventy-six hours of my youth. The more I think about it, the more ingenious it seems; the design is impeccable and difficult to improve.
    }
    @img["/files/20261021/yuhua.webp" #:scale 0.4]{Fuck, this is so fucking awesome, holy shit}
    @para{
      The purpose of games (note that this is different from alienated entertainment. I personally detest works such as online games whose primary purpose is profit; in essence they are a capitalist exploitation of users’ attention, and the critique is the same as that of short videos.) is no different from that of traditional art: in essence, both allow the audience/player to obtain a specific emotional experience. On top of traditional art, games add the tool of “interactivity,” greatly expanding the boundaries of artistic expression.@cite["sylvesterDesigningGamesGuide2013"]
    }
    @para{
      Oxygen Not Included’s traditional storytelling can only be described as better than nothing, but it truly takes the “interactivity” unique to games to the extreme. Consider that Oxygen Not Included has the following main systems:
      @ul{
        @item{
          A simple one-cell-one-object cellular automaton heuristic solver
          @ul{
            @item{Naive heat diffusion}
            @item{Naive gas-liquid diffusion}
            @item{Naive matter phase transitions}
          }
        }
        @item{
          Graph structures overlaid on the cell grid
          @ul{
            @item{Directed-graph gas/liquid/solid pipes}
            @item{Connected-graph power system}
            @item{Linear abstract machines, such as water electrolysis}
          }
        }
        @item{
          Duplicants’ priority-queue work and linear survival needs
        }
      }
    }
    @para{
      The primary benefit of these systems is simplicity. Most systems are simplified abstractions of physics that already exist in real life, reducing the player’s cognitive load. Linear Duplicants and machines likewise make game behavior easy to predict (legible), and also prevent situations in overly nonlinear or chaotic systems where the player cannot make choices or designs (non-decision). The premise that “Duplicants need to survive” (a fictional wrapper) also acts directly on emotion, giving the player a clear goal and ample motivation.
    }
    @para{
      ONI’s systems have excellent emergence. The most classic example is that “heat diffusion” and “directed-graph gas/liquid/solid pipes” can be combined to construct counterflow heat exchange from real-world industrial production. Based on the game’s CA simulation, the game also gives rise to interesting methods of practical value to players, such as “liquid lock,” “infinite storage,” and “vacuum insulation.” But this is only the tip of the iceberg. Consider a typical gameplay loop: “collect resources -> automate -> renewable.” Apart from the tech tree, most goals are indirectly designed and emerge during play. For example, “heat diffusion” is not only the operating principle of some machines but also drives the game’s development. Most “linear machines” interact with “heat diffusion” by producing heat, and by the mid-game it presents the player with the problem of regional overheating that makes production impossible—the player’s short-term solution naturally becomes a long-term problem. Ultimately, the game, like Stellaris, interweaves short-term and long-term goals, is predictable and emotionally grounded, and drives one to “play one more cycle.”
    }
    @para{
      Overall, ONI successfully achieves a perfect balance among intuitiveness, emergence, and simplicity. Other games that emphasize interactivity and system simulation:
      @ul{
        @item{Traditional 4X, such as Civilization and Stellaris — too many things are linear, so designers have to keep piling on extra content}
        @item{Minecraft (especially circuitry) — too counterintuitive}
        @item{KSP — quite fun, but its systems are unintuitive and it lacks far too much guidance and goals}
        @item{Noita — flavor-stack computation and lacks guidance, making it too hard to get into}
        @item{Factorio, RimWorld — I haven’t played them yet; they might be better than ONI. I’ll have to give them a proper appraisal when I have time}
      }
      However, ONI also has some flaws. The most notable is the universal solution: the famous liquid cooling/steam turbine loop can directly delete heat from the environment, greatly reducing the solution space and undermining ONI’s most innovative heat diffusion system. Likewise, ONI’s guidance is not much better than KSP’s, and is also a major hurdle that turns new players away.
    }
    @para{
      (My Chinese is severely Europeanized and beyond saving; I really need to read more books.)
    }
  }
)

(provide post)