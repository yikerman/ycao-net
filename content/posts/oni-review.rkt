#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["《缺氧》玩后感" "2026-10-21" #:lang "zh"]{
    @para{
      这篇文章欠了缺氧好久。此游戏耗费我宝贵的六百七十六个小时青春。越想越觉得精妙，设计无可挑剔、难以改进。
    }
    @img["/files/20261021/yuhua.webp"]{妈的，这么牛逼，我操}
    @para{
      游戏的目的（注意区别于通俗娱乐。笔者本人极其厌恶在线游戏等以盈利为主要目的的作品，本质为资本主义剥削用户注意力，
      和短视频等批判方式相同。）与传统艺术并无不一，本质都是使得观众/游玩者获得特定的情感体验。在传统艺术的基础上，游戏
      多了“交互性”这一工具，使得艺术表达可能获得极大的拓展。@cite["sylvesterDesigningGamesGuide2013"]
    }
    @para{
      缺氧在传统故事性上几乎没下功夫，在游戏特有的“互动性”上确做到了极致。
    }
  }
)

(provide post)
