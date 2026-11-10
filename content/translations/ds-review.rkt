#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["Reflections on Death Stranding and Thoughts on Art Criticism" "2025-11-15"]{
    @para{
      Today I beat @bold{Death Stranding}. I have to mention that while playing, I assumed it was a post-pandemic work reflecting on lockdown and isolation. To my surprise, the game actually launched right in 2019—what a coincidence.
    }
    @para{
      What makes @bold{Death Stranding} truly unique is how it unifies auteur expression, narrative, and gameplay. Hideo Kojima's primary creative intent is to highlight the importance of mutual aid among people, and the game's plot follows Sam, a "porter," as he reconnects a fractured post-apocalyptic America. The innovation lies in how the core gameplay loop—delivering cargo—directly serves this theme. Every moment creates a stark contrast between the grueling hardship of making deliveries and the relief brought by structures left behind by other players. The "Like" system also gives players positive feedback for helping others, leading most players to share a similar emotional journey (e.g., @cite["ds-review-1"]).
    }
    @para{
      Unsurprisingly, reviews for @bold{Death Stranding} are polarizing, with criticisms mainly centered on weak gameplay and repetitive mechanics.@cite["ds-review-2"]@cite["ds-review-3"] In @bold{Designing Games}, Sylvester proposes that games are "engines of experience"@cite["sylvesterDesigningGamesGuide2013"]—using their unique interactivity (mechanics and systems) to generate specific experiences. The controversy surrounding @bold{Death Stranding}'s gameplay stems from the fact that players did not expect its interactive elements to be deliberately designed as tedious, difficult, and terrifying to serve its overarching theme. Yet, analyzed through the lens of experience delivery, players successfully felt the exact emotions Hideo Kojima intended—hardship, solitude, and solidarity—which is the hallmark of successful game design. The traditional view holds that games must be "fun," but "fun" is itself just one type of emotional experience. It can be broken down into a sense of achievement (common in sandbox and competitive games), visceral thrills (stunning graphics, grand spectacles, etc.—frequently used in popcorn flicks as a lazy trope), and so on. Traditional game criticism expects games to deliver "fun"—and only "fun"—through interactivity, overlooking other permutations: namely, that dynamic interaction (game mechanics) combined with traditional artistic media (cutscenes, art direction, narrative) can convey the same expressions as traditional art, such as an author's joys and sorrows, or reflections on social issues.
    }
    @para{
      This evaluative framework can be generalized further: the distinction between games and traditional entertainment media is that traditional media (literature, film, painting, etc.) rely on narrative and/or audiovisual means, whereas games utilize interactivity. However, their shared goal is to convey an emotional experience to the audience. Calling a piece of literature, music, film, or a game "good" should mean that the creator succeeded in making the audience experience the emotions they designed. When people communicate, they often need to prove a proposition. The proof itself inevitably relies on either reason (logos) or emotion (pathos): to persuade through reason is an essay; to move through emotion is art.
    }
    @para{
      Addendum (2025/12/07): This post conflated "evaluating art" with "evaluating the artist's craft"; the former is not well-defined and remains contentious.
    }
  })

(provide post)