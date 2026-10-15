#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["Reflections on Playing Death Stranding and Thoughts on Art Criticism" "2025-11-15"]{
    @para{
      I finished Death Stranding today. I must mention that while playing, I initially thought this was a post-pandemic work reflecting on pandemic isolation; it turned out that the game was actually released right in 2019. What a coincidence.
    }
    @para{
      Death Stranding's most distinctive aspect lies in achieving a unity of authorial expression, narrative, and gameplay. Hideo Kojima's main creative intention is to convey the importance of people helping one another; the game's story is Sam, as a "deliveryman," reconnecting a fragmented America in a post-apocalyptic world. The innovation is that the game's core gameplay—delivery—directly serves this theme. It constantly contrasts the "hardship of delivery" with "the help brought by structures left by other players," and the Likes system also gives players feedback when they help others. Most players have had similar emotional experiences (for example, @cite["ds-review-1"]).
    }
    @para{
      Death Stranding's reception was predictably divided, mainly over its weak gameplay and monotonous mechanics. @cite["ds-review-2"]@cite["ds-review-3"] Sylvester, in his Game Design, proposes that games are "experience generation engines"@cite["ds-review-4"], that is, using the interactivity unique to games (mechanics, systems) to generate specific experiences (experience). The controversy over Death Stranding's gameplay stems from players not expecting its interactive (gameplay) portions to be deliberately designed to be boring, difficult, and terrifying in order to set off its theme. But if analyzed from the perspective of experience delivery, players successfully felt the emotions—the "hardship," "loneliness," and "mutual aid" that Hideo Kojima wanted players to experience—then this is a manifestation of successful game design. The traditional view holds that games must be "fun," but fun is also an emotional experience, which can be further subdivided into a sense of achievement (common in sandbox and competitive games), a sense of thrill (beautiful graphics, grand scenes, etc. (also frequently used in popcorn movies, a customary lazy trope)), and so on. Traditional game criticism expects games to be able to, and only to, deliver "fun" through "interaction," while overlooking other combinations: namely, that dynamic interaction (game mechanics) and traditional art (cutscenes, art, narrative) can express what traditional art expresses, such as the author's joys and sorrows and reflections on social issues.
    }
    @para{
      This evaluative framework can be further generalized: the difference between games and traditional entertainment is that traditional entertainment products (literature, film, painting, etc.) use narrative and/or audiovisual means, while games use interactive means; but their goal is the same: to convey emotional experiences to an audience. When we evaluate a piece of literature, music, film, or game as "good," what we mean should be that the author successfully made the reader experience the emotion he designed. When people exchange information, they need to prove certain propositions; the proof itself must be either rational (logos) or emotional (pathos). To persuade by reason is an essay; to move by emotion is art.
    }
    @para{
      2025/12/07 addendum: This post conflates "artistic evaluation" and "evaluation of an artist's creation"; the former is not well-defined / remains controversial.
    }
  })

(provide post)