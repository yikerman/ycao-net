#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["LLM will NEVER be AGI: The Proof" "2024-08-20"]{
    @para{
      The proof is trivial with a little help of a necessary condition of
      complexity theories. All LLM runs under the complexity of @math{O(n)},
      where @math{n} is the length of the output.
    }
    @para{
      Suppose LLM is AGI, then it is able to solve any problem that a human can
      solve. Consider the following problem:
    }
    @blockquote{
      Given a string @math{s} of length @math{n}, determine whether @math{s} is a
      palindrome. Answer "Y" if it is and "N" if it isn't.
    }
    @para{
      Apprently, a human can solve this problem, and it is easy to prove that the
      problem must be solved in at least @math{O(n)} time.
    }
    @para{
      Since the output of this problem is of a constant length, LLM must solve
      this problem in @math{O(1)} time, which is a contradiction. Thus LLM cannot
      solve a problem that a human can solve. Therefore LLM is not AGI.
      @math{\blacksquare}
    }
    @para{
      EDIT: Chain of Thoughts breaks the proof, allowing LLM to solve the problem
      in arbitrary time.
    }
  })

(provide post)
