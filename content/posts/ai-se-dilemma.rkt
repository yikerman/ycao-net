#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["Software Engineering Cannot be Solved by Code Generation" "2026-10-16"]{
    @para{
      Since around the release of Claude Opus 4.5, LLM & agentic coding have finally become useful.
      But, turns out it is still non-trivial to write software with AI. Personally I had always 
      find the process of vibe-coding @it{painful}. It is not to say that agentic coding is
      useless or inefficient, but it is @it{painful}.
    }
    @para{
      It roots in that SE holds a weird position between engineering and math. One hand, we do  
      care about, and we mostly only care about practical, real-world problems in SE, in 
      contrast to @link["https://teorth.github.io/tao-web/slides/math-2-0-caltech-2026.pdf"]{Terence Tao's Math 2.0 Presentation}
      in which he inappropriately gives a conceptual scenario of people not understanding
      medicine. We do math for fun, at least in the past 50 years, and we have to admit that math 
      has ventured into a mind game built in thin air, and we should not pretend that we study
      math mainly in hope that it has practical uses.
    }
    @blockquote{
        Thus mathematics may be defined as the subject in which we never know what we are talking
        about, nor whether what we are saying is true. People who have been puzzled by the 
        beginnings of mathematics will, I hope, find comfort in this definition, and will 
        probably agree that it is accurate.
        @cite["russellMysticismLogicOther1917"]
    }
    @para{
      That was a little deviation, but this is not a strict paper anyway; let's get back to SE.
      With that said, SE also differs from traditional engineering in which the connection to the
      physics world is very thin. We still model problems with a-priori constructions like other
      engineering disciplines, but we mainly deal with human intention and demands rather than
      nature. The latter has a ground truth while the former is not. This gives SE insane
      flexibility at carrying out formal descriptions (code), which becomes a problem.
    }
    @para{
      CS roughly consists of two parts, theoretical and applied. Theoretical mainly consists of
      discrete math and complexity theory, and applied has more nuances of managing and 
      coordinating people, structuring formal language (code) such that it caters for future
      needs. The essence of "applied" CS, i.e. SE, is to translate blurry, natural languages
      into formal languages.
    }
    @para{
      During the process of SE, one of the two scenarios will apply, exhausively:
      @ol{
        @item{
          You state your demand in a formal way. Given that it is empirically observed that LLMs
          seem to behave really well at solving well-defined, formal problems (such as
          @link["https://www.phoronix.com/news/Linus-Torvalds-Claude-Code"]{optimization},
          @link["https://openai.com/index/hugging-face-incident-and-the-road-ahead/"]{reverse engineering / cybersecurity},
          or @link["https://github.com/openai/math/"]{just general, a-priori math problems}), 
          most of the time it will work.
          @bold{But at this point you are essentially writing code yourself, and most SE can be 
          seen as proof by construction.}
        }
        @item{
          You don't state your demand in a formal way. In this case, LLM starts to guess and fill
          out the gaps in your natural language. Because of the nature, the formal construction
          can get pretty arbitrary. Sometimes they happen to be correct as guided by LLM company
          RL imposing "best practices" into models, and sometimes they diverge. @bold{It results  
          in inevitably loss of control and deviation from intention.}
        }
      }
    }
    @para{
      Some anecdotes may help but anyone done SE should see this immediately obvious so I'll just
      be lazy here (see Dijkstra@cite["dijkstraFoolishnessNaturalLanguage1978"]).
      It boils down to we don't actually fully understand our demand until we implement and
      iterate it. Funnily this is why we hire architects and product managers in the first place.
    }
    @para{
      One can definitely argue that "theoretically LLMs can do whichever thing human is doing",
      but up till now I don't see any signs of it. They have never come up with beautiful,
      insightful math abstractions, nor have they decide autonomously one abstraction is better
      than another given some situation. 
    }
  }
)

; 翻译提示：SE翻译为“软工”，是软件工程简写。CS翻译为“计科”，计算机科学。RL指强化学习，这里应该翻译为“后训练”。

(provide post)
