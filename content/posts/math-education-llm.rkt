#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post-math-education-llm
  @article["Math Education, and LLM" "2026-06-16"]{
    @para{@it{
        Abstract: This article defines math and math education, and argues for a lower bound of 
        human effort required to learn mathematics (or any other abstraction-heavy subject) regardless
        of LLM capability.
    }}

    @para{
      LLMs are evolving rapidly; within a year AIs are able to tackle math problems - we had
      thought of them as the hardest for AI to automate - but they are getting there. Let it be OpenAI's
      @link["https://openai.com/index/model-disproves-discrete-geometry-conjecture/"]{marketing bluff} 
      or not (of course humans helped, how much? we can never know...), we can at least say that 
      frontier models are useful for assisting with math research. The natural question to ask here is 
      that, is AI helpful at math education? To what extent?
    }

    @para{
      Mathematics is a truly unique subject from all other sciences, in that it is not 
      natural at all, despite the fact that universities like to put math in a physical science
      building of some sort. While it originates in counting and measuring the physical world, it has  
      evolved out of its physics context into a discipline purely focused on a-priori reasoning and 
      abstraction during the @link["https://en.wikipedia.org/wiki/Formalism_(philosophy_of_mathematics)"]{formalism} 
      movement. My preferred way to define math is "the study of a-priori constructions". I'd also
      like to think of all math knowledge as an infinitely large graph of theorems where one node 
      points to another if one can be deduced from the other by the axioms chosen. In this interesting
      perspective, math is much like art, poetry, or music, where every theorem already @link["https://en.wikipedia.org/wiki/G%C3%B6del_numbering"]{exists somewhere}
      and we are just discovering them. An implication of this view is that, humans have to occupy a 
      position in math research, since we are the ultimate judge to say whether an abstraction or
      theorem is interesting and worth developing or not. Math is tightly connected to personal and 
      collective taste and intellect: @it{"The product of mathematics is clarity and understanding. 
      Not theorems, by themselves."} @cite{budneyWhatsMathematician2010}
    }

    @para{
      As a result, calculation or theorem proving is only a small part of doing math, and the goal is
      rather to cultivate good instinct @cite{taoThereMoreMathematics2026} - the ability to fluently 
      navigate and manipulate some levels of abstraction, and thus "sense" how to get from one node to
      another or which nodes are worth exploring. People used to develop abstraction out of physical
      properties, such as the invention of calculus which was used to describe continuous physical 
      phenomena. But now, the abstraction is so far removed from the physical world that it is often
      the case that mathematical abstractions are invented before any application is found: Riemannian
      geometry, a 19th-century invention, is now the language of general relativity (1915). 
    }

    @para{
      Math education gets hard here, since the properties of good math education, in contrast to math
      itself, the most rigorous of subjects, are interestingly ill-defined, heavily depending on human
      creativity and interpretation. I can only name properties of good math education: I learn math
      best when I am in the middle of the material, and suddenly I "click" and can predict what comes
      next. The "moment of insight" reminds me of Grant Sanderson's repeatedly emphasized "want you to
      feel like you could have reinvented <math topic> yourself" in his @link["https://www.youtube.com/@3Blue1Brown"]{channel}.
      It also aligns with the "generation effect" @cite{slameckaGenerationEffect1978} in cognitive 
      psychology, which states that people remember better if they generate the answer themselves 
      instead of just reading it. In my experience, it is non-trivial to write a prompt
      as it is non-trivial to write a textbook which is good enough to guide students to have the
      "moment of insight".
    }

    @para{
      Regardless of LLM capability, it still requires a non-trivial minimum human effort to learn math;
      since math is all about building intuition about abstractions, the old, usual, and perhaps the 
      only way is to see and practice a lot of concrete examples, after which the motivation for 
      building some abstraction can be understood, and after which the abstraction itself can be fully
      grasped. For example, the "group" abstraction requires one to see a lot of integers, reals,
      polynomials, modular arithmetic, matrices, and so on before knowing why we want such a thing.
      It's unskippable.
    }

    @para{
      I was motivated to write this after reading @link["https://www.dailycal.org/news/campus/academics/failing-grades-soar-as-professors-see-greater-ai-usage-dwindling-math-skills-in-uc-berkeley/article_16fad0bf-02cb-4b8c-8d88-888ffd9f8608.html"]{the Daily Californian's report on UCB}
      that soaring failing grades @it{correlates} with increasing AI usage. It is consistent with my 
      above point that one always needs to grind through to build math skills, and also reveals the 
      problematic side, not on LLM itself but on the problem of laziness in human. It does not imply
      students have gotten more lazy because of AI though, but rather that AI removes a lot of
      friction for laziness: people used to copy each other's homework, google an answer key, and now
      they can simply ask AI to solve arbitrary math problems. Since there do exist people who are 
      genuinely willing to throw their entire lives into math, laziness may not be a human nature but
      rather a product of a flawed education system. The solution is beyond the scope of this essay,
      but it certainly won't be found by simply trying to "ban AI".
    }
  })

(provide post-math-education-llm)
