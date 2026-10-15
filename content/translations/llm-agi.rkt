#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["[HAS ERRS] LLM 绝不会成为 AGI：证明" "2024-08-20" #:lang "zh"]{
    @para{
      只需借助计算复杂性理论的一个必要条件，证明就很简单。所有 LLM 都在
      @math{O(n)} 的复杂度下运行，其中 @math{n} 是输出的长度。
    }
    @para{
      假设 LLM 是 AGI，那么它就能解决人类能解决的任何问题。考虑下面这个问题：
    }
    @blockquote{
      给定一个长度为 @math{n} 的字符串 @math{s}，判断 @math{s} 是否为回文。是则回答“Y”，否则回答“N”。
    }
    @para{
      显然，人类能解决这个问题，而且容易证明，这个问题至少需要 @math{O(n)}
      时间才能解决。
    }
    @para{
      由于这个问题的输出长度恒定，LLM 必须在 @math{O(1)} 时间内解决它，这与
      上述结论矛盾。因此，LLM 无法解决人类能解决的问题。所以，LLM 不是 AGI。
      @math{\blacksquare}
    }
    @para{
      编辑：思维链使该证明不成立，LLM 因此能用任意长的时间解决这个问题。
    }
  })

(provide post)