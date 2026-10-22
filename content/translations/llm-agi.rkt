#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["[有错误] LLM 永远不会成为 AGI：证明" "2024-08-20" #:lang "zh"]{
    @para{
      借助复杂性理论的一个必要条件，这个证明很简单。所有 LLM 都在
      @math{O(n)} 的复杂度下运行，其中 @math{n} 是输出的长度。
    }
    @para{
      假设 LLM 是 AGI，那么它能解决任何人类能解决的问题。考虑下面这个问题：
    }
    @blockquote{
      给定一个长度为 @math{n} 的字符串 @math{s}，判断 @math{s} 是否为回文串。若是，回答 "Y"；否则回答 "N"。
    }
    @para{
      显然，人类能解决这个问题，而且容易证明，这个问题至少需要 @math{O(n)} 时间才能解决。
    }
    @para{
      由于这个问题的输出长度是常数，LLM 必须在 @math{O(1)} 时间内解决它，这产生了矛盾。于是，LLM 无法解决人类能解决的问题。因此，LLM 不是 AGI。
      @math{\blacksquare}
    }
    @para{
      更新：思维链打破了这个证明，使 LLM 能花任意长的时间解决这个问题。
    }
  })

(provide post)