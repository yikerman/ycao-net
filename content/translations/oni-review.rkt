#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["Reflections on Oxygen Not Included" "2026-10-21"]{
    @para{
      This review of @bold{Oxygen Not Included} (ONI) is long overdue. The game has consumed 676 precious hours of my youth. The more I reflect on it, the more I find its design brilliant and nearly impossible to improve upon.
    }
    @img["/files/20261021/yuhua.webp" #:scale 0.4]{Damn, this is so fucking awesome.}
    @para{
      The purpose of games (as distinct from alienated forms of entertainment—I personally detest live-service games and other works driven primarily by profit, which are essentially capitalist exploitation of user attention, subject to the same critiques as short-form videos) is no different from that of traditional art: fundamentally, both aim to evoke specific emotional experiences in the audience or player. Building upon traditional art, games introduce the tool of "interactivity," vastly expanding the boundaries of artistic expression.@cite["sylvesterDesigningGamesGuide2013"]
    }
    @para{
      While @bold{Oxygen Not Included}'s traditional narrative is barely there, it pushes the game-specific medium of "interactivity" to the absolute extreme. Consider the main systems in ONI:
      @ul{
        @item{
          A simple one-element-per-tile cellular automaton (CA) heuristic solver
          @ul{
            @item{Naive heat diffusion}
            @item{Naive gas and liquid diffusion}
            @item{Naive phase transitions of matter}
          }
        }
        @item{
          Graph structures overlaid on the cellular grid
          @ul{
            @item{Directed graphs for gas, liquid, and solid piping}
            @item{Connected graphs for the power grid}
            @item{Linear, abstracted machines, such as the Electrolyzer}
          }
        }
        @item{
          Duplicant priority-queue task management and linear survival needs
        }
      }
    }
    @para{
      The primary advantage of these systems is simplicity. Most of them are simplified abstractions of real-world physics, reducing the cognitive load on the player. The linear nature of Duplicants and machines also makes game behavior predictable (legible), preventing non-decisions where players are paralyzed from making choices or designs due to overly non-linear or chaotic systems. Furthermore, the fictional wrapper that "Duplicants need to survive" directly engages the player's emotions, providing clear goals and ample motivation.
    }
    @para{
      ONI's systems exhibit exceptional emergence. The most classic example is combining "heat diffusion" with "directed-graph piping" to construct counter-current heat exchangers, just like in real-world industrial engineering. Out of the game's CA simulation also emerge interesting and practically useful contraptions for the player, such as "liquid locks," "infinite storage," and "vacuum insulation." Yet these clever builds are just the tip of the iceberg. Consider a typical gameplay progression: "Resource Gathering -> Automation -> Sustainability." Aside from the tech tree, most goals are designed indirectly and emerge naturally during play. For instance, "heat diffusion" isn't just the operating principle behind certain machines; it actively drives the progression of the game. Most "linear machines" interact with the "heat diffusion" system by generating heat. By the mid-game, this confronts the player with the problem of regional overheating, which halts production—the player's short-term solutions naturally become their long-term problems. Ultimately, much like @bold{Stellaris}, the game interweaves short-term and long-term goals in a way that is both predictable and emotionally grounded, compelling you to play "just one more cycle."
    }
    @para{
      Perhaps we can view a game as a dynamical system @math{x_{t+1}=f(x_t,u_t)}, where the system enters a trajectory @math{G} once the player specifies a policy. On one hand, we don't want @math{G} to be too trivial, otherwise every decision the player makes is one-dimensional and obvious. Nor do we want an overly complex or chaotic @math{G}—playing a game isn't academic research, after all. We want players (after some onboarding) to develop a solid intuition for the system and be able to weigh trade-offs. By combining simple simulations (naive CA), ONI constructs a rich yet well-behaved and predictable system, striking a perfect balance between intuition, emergence, and simplicity.
    }
    @para{
      Using this as a benchmark, we can evaluate other games that emphasize interactivity and systemic simulation:
      @ul{
        @item{Traditional 4X games, like @bold{Civilization} and @bold{Stellaris} - Too many mechanics are linear, forcing designers to constantly pile on extra content.}
        @item{@bold{Minecraft} (especially Redstone circuits) - Far too counter-intuitive.}
        @item{@bold{KSP} - Very fun, but the systems are unintuitive, and it severely lacks onboarding and clear goals.}
        @item{@bold{Noita} - Flavored stack calculus with a lack of guidance, making the barrier to entry way too high.}
        @item{@bold{Factorio}, @bold{RimWorld} - Haven't played them yet; perhaps they are even better than ONI. I'll have to savor them when I find the time.}
      }
      That said, ONI does have some flaws. The most glaring one is the existence of a silver-bullet solution: the infamous Thermo Aquatuner / Steam Turbine loop can outright delete heat from the environment, which drastically shrinks the solution space and undermines ONI's most innovative system—heat diffusion. Similarly, ONI's onboarding is barely any better than @bold{KSP}'s, serving as a major hurdle that turns away new players.
    }
    @para{
      (My Chinese writing has become hopelessly Europeanized; I really need to read more books.)
    }
  }
)

(provide post)