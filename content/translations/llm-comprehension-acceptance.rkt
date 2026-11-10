#lang at-exp racket/base

(require ycao-net/lib/markup)

;; more skin in the game => normative agency?????

(define post
  @article["我们不喜欢 LLM 的输出，并非因为理解" "2026-11-08" #:lang "zh"]{
    @para{
      尽管 LLM 至今仍然 @link["/posts/ai-se-dilemma.html"]{表现出与人类显著不同的可观察输出模式（就功能主义而言）}，
      但请注意：(I) 人类也会时不时地产出低劣内容并产生幻觉。我们见过我们最亲爱的同事制造的无数灾难现场；
      (II) 正如我所链接文章最后一段所说，@it{“完全可以主张‘理论上 LLM 能做人类正在做的任何事情’”}。
      这当然有争议，而且困难且并不简单，但我们不能否认 LLM 已经表现出超人行为，并在各个领域（老实说主要是数学）出类拔萃。
      但仍有更多理由说明，为什么我们不应把一切都直接交给 LLM。
    }
    @para{
      我们通常主张应当限制或干预 LLM 的使用，因为我们需要人类理解。
      但理解本身就已经相当麻烦。中文屋论证@cite["searleMindsBrainsPrograms1980"]
      原本是为了反驳强功能主义和计算主义，却反过来咬了自己一口：
      它依据可疑的笛卡尔式假设来论证，即真正的“理解”在于一种孤立的内在心理状态，并具有内在意向性。
      维特根斯坦的规则遵循和私人语言论证正直接针对这一点（以及更广泛的方法论/语义唯我论）@cite["wittgensteinPhilosophicalInvestigations1953"]。
      正如 SEP（第 1 节）@cite["candlishPrivateLanguage2019"] 所总结的：@code{The conclusion is that a language in principle unintelligible to anyone but its originating user is impossible. The reason for this is that such a so-called language would, necessarily, be unintelligible to its supposed originator too, for he would be unable to establish meanings for its putative signs.}
    }
    @para{
      问题不在于理解，而在于规范性。注意，当我们论证时，我们会说
      “我们 @bold{不该} 把一切交给 LLM”。且不论 PLA，即使我们确实
      拥有可测量的神经生物学状态，或“感受质”等等，它们也是 @it{规范上惰性的} 事实@cite["mcdowellMindWorld1994"]。
      中文屋把关于理解/领会的事实断言误当成了规范性
      地位。孤立地看，无论是生物大脑还是自注意力模块，都不具有语义规范性@cite["sellarsEmpiricismPhilosophyMind1956"]。
    }
    @para{
      但在现实中，我们确实有规范性对象，例如法律合同、一个会输出正确
      或错误结果的程序。按照规范性实用主义@cite["kripkeWittgensteinRulesPrivate1982"]，规范性来自
      外部的社会结构和共同体实践——当我们说某人“理解”一个概念时，那并不是某种纯粹
      私人的心理过程，而是一种社会地位：@it{在给出理由与索取理由的游戏中}承担承诺和责任@cite["brandomMakingItExplicit1994"]。
    }
    @para{
      把理解重新表述为规范性问责，会再次揭示我们为何对
      中文屋情景感到不安——以及为何人类的低劣输出不同于 AI 的低劣输出。人与人之间同样是黑箱，
      但他们受社会结构和存在性利害（@it{切身利害}）约束。人工工具缺乏
      这样的利害，因此无法充当成熟的规范性行动者；相反，它们融入社会要靠其作为
      @it{可审计工具} 的地位，而人类操作者承担相应责任@cite["haugelandHavingThoughtEssays1998"]。但在现代深度学习中，这种可审计性消解为对 AI 公司所能获取的任何庞大数据集进行大规模
      预训练，也消解为神秘互动的权重：
      这就是 @it{认识论不透明性}，即人类行动者在认知上不可能检查、
      分解或追踪一个计算过程中生成证成的要素@cite["humphreysExtendingOurselvesComputational2004"]@cite["humphreysPhilosophicalNoveltyComputer2009"]@cite["creelTransparencyComplexComputational2020"]。
    }
    @para{
      值得注意的是，克服认识论不透明性并不等同于追寻
      “内在语义”的笛卡尔神话（从而又退回到 PLA），而是一种 @it{实用可理解性}：公众有能力
      把握反事实依赖、诊断错误并进行干预@cite["deregtUnderstandingScientificUnderstanding2017"]@cite["khalifaUnderstandingExplanationScientific2017"]。
      在这种情况下，与传统工具相比，人类面临一种 @it{规范性失能}：我们
      既不能像对待同侪那样让系统承担责任，也不能像对待工具那样审计和修改它，达到
      问责所要求的程度@cite["matthiasResponsibilityGapAscribing2004"]。
    }
    @para{
      此外，想想药理学。有人可能会说，医学长期依赖
      经验上有效的药物。药理学其实面临与 LLM 使用相同的困境。
      许多药物虽然尚未被端到端地完全理解，却仍能部分地从机制上分解
      （例如，业界转向 5R 框架@cite["cookLessonsLearnedFate2014"]），
      在此之上，严格的临床监管和机构责任把 @it{切身利害} 转移给药企和开药医生。
    }
    @para{
      既然我们不能给权重赋予真正的存在性利害（还是说可以？如果我们真的可以，那反而更麻烦），
      我真心希望 MechInterp 能把 LLM 带到与药理学有些相似的位置。那会是一个不错的实用折中。
    }
    @para{
      注：过去的文献研究大量借助了 LLM。
    }
  })

(provide post)