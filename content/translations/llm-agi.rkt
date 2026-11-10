#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["[有误] LLM 永远不会成为 AGI：证明" "2024-08-20" #:lang "zh"]{
    @para{
      借助复杂性理论中的一个必要条件，这个证明是显而易见的。所有大语言模型（LLM）都在 @math{O(n)} 的复杂度下运行，其中 @math{n} 是输出的长度。
    }
    @para{
      假设 LLM 是通用人工智能（AGI），那么它就能解决人类能解决的任何问题。考虑以下问题：
    }
    @blockquote{
      给定一个长度为 @math{n} 的字符串 @math{s}，判断 @math{s} 是否为回文串。若是则回答 "Y"，否则回答 "N"。
    }
    @para{
      显然，人类可以解决这个问题，而且很容易证明解决该问题至少需要 @math{O(n)} 的时间。
    }
    @para{
      由于该问题的输出长度是常数，LLM 必须在 @math{O(1)} 时间内解决它，这便产生了矛盾。因此，LLM 无法解决这个人类能解决的问题。故 LLM 不是 AGI。@math{\blacksquare}
    }
    @para{
      订正：思维链（Chain of Thoughts）打破了这个证明，它使 LLM 能够消耗任意时间来解决该问题。
    }
  })

(provide post)