#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["Thoughts After Playing Death Stranding and Reflections on Art Criticism" "2025-11-15"]{
    @para{
      Today I completed Death Stranding. I have to mention that while playing, I initially thought this was a post-pandemic work reflecting on pandemic isolation, but it turned out that the game was actually released in 2019—what a coincidence.
    }
    @para{
      The most unique thing about Death Stranding is that it achieves a unity of authorial expression, narrative, and gameplay. Hideo Kojima’s main creative intent is to convey the importance of people helping one another, and the game’s story has Sam, as a “porter,” reconnect a fragmented post-apocalyptic America. The innovation lies in the fact that the core gameplay—delivery—directly serves this theme. It constantly contrasts the hardship of delivering with the help brought by structures left behind by other players, and the like system also gives players feedback when they help others. Most players have had similar emotional experiences (for example, @cite["ds-review-1"]).
    }
    @para{
      As expected, reviews of Death Stranding diverged, mainly focusing on its weak gameplay and monotonous mechanics. @cite["ds-review-2"]@cite["ds-review-3"] Sylvester, in his Game Design, proposes that games are “experience generation engines” @cite["ds-review-4"], that is, they use interactivity unique to games (mechanics, systems) to generate specific experiences. The controversy over Death Stranding’s gameplay stems from players not expecting its interactive (gameplay) portion to be deliberately designed as boring, difficult, and frightening in order to highlight its theme. But if analyzed from the perspective of experience transmission, players successfully felt the emotions—the “hardship,” “loneliness,” and “mutual aid” that Kojima hoped players would experience—and this is evidence of successful game design. The traditional view holds that games must be “fun,” but fun is also an emotional experience, which can be subdivided into a sense of achievement (common in sandbox and competitive games), exhilaration (beautiful graphics, grand scenes, etc. (also frequently used in popcorn movies, a conventional lazy trope)), and so on. Traditional game criticism expects games can, and only can, deliver “fun” through “interaction,” while overlooking other combinations—namely, that dynamic interaction (game mechanics) and traditional art (cutscenes, visual art, narrative) can express what traditional art expresses, such as an author’s joys and sorrows or reflections on social problems.
    }
    @para{
      This evaluative framework can be further generalized: the difference between games and traditional cultural entertainment is that traditional cultural entertainment products (literature, film, painting, etc.) use narrative and/or audiovisual means, whereas games use interactive means, but their goal is the same: to transmit emotional experiences to an audience. To evaluate a piece of literature, music, film, or game as “good” should mean that the author succeeded in making the reader experience the emotions he designed. When people exchange information, they need to prove certain propositions; the proof itself must be either rational (logos) or emotional (pathos). To persuade with reason is argument; to persuade with emotion is art.
    }
    @para{
      2025/12/07 addendum: This article conflates “art evaluation” and “evaluation of an artist’s creative work”; the former is not well-defined/remains controversial.
    }
  })

(provide post)