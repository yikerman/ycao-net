#lang at-exp racket/base

(require ycao-net/lib/markup)

;; more skin in the game => normative agency?????

(define post
  @article["我们抗拒大语言模型的输出，并非出于“理解”" "2026-11-08" #:lang "zh"]{
    @para{
      尽管大语言模型（LLM）迄今@link["/posts/ai-se-dilemma.html"]{在可观测（功能主义意义上）的输出模式上仍与人类大相径庭}，
      但别忘了：（一）人类也时常胡制滥造、满嘴跑火车——我们亲爱的同事们捅出的娄子还少吗？（二）正如我在前文末段所言，@it{“我们完全可以主张‘理论上人类能做的事，LLM 都能做’”}。
      这固然尚存争议、难以简单定论，但不可否认，LLM 已展现出超越常人的能力，在诸多领域（坦白说主要是数学）出类拔萃。即便如此，我们依然有充足的理由拒绝将一切全盘交由 LLM 处理。
    }
    @para{
      人们通常认为，之所以应当限制或干预 LLM 的使用，是因为我们需要属于人类的“理解”。
      但“理解”本身就是个棘手的概念。“中文房间”论证@cite["searleMindsBrainsPrograms1980"]本欲反驳强功能主义与计算主义，结果却作茧自缚，因为它立基于一个可疑的笛卡尔式预设：真正的“理解”在于某种孤立的、具有内在意向性的内部心理状态。维特根斯坦的规则遵循与“私人语言论证”（PLA）正是直指这一预设（以及更广泛的方法论与语义唯我论）@cite["wittgensteinPhilosophicalInvestigations1953"]。正如《斯坦福哲学百科全书》（第 1 节）所总结的@cite["candlishPrivateLanguage2019"]：@code{The conclusion is that a language in principle unintelligible to anyone but its originating user is impossible. The reason for this is that such a so-called language would, necessarily, be unintelligible to its supposed originator too, for he would be unable to establish meanings for its putative signs.}
    }
    @para{
      症结不在于“理解”，而在于“规范性”（normativity）。请注意，我们在争论时的措辞是：“我们@bold{不应当}将一切全盘交由 LLM 处理”。即便抛开私人语言论证不谈，哪怕我们确实拥有可测量的神经生物状态或“感受质”（Qualia）等等，它们也只是@it{在规范性上惰性的}（normatively inert）事实@cite["mcdowellMindWorld1994"]。
      “中文房间”误将关于“理解”的事实断言当成了规范性地位。孤立地看，无论是生物大脑还是自注意力模块，都不具备语义规范性@cite["sellarsEmpiricismPhilosophyMind1956"]。
    }
    @para{
      但现实中确实存在规范性客体，比如法律合同，或是输出对错结果的程序。根据规范实用主义@cite["kripkeWittgensteinRulesPrivate1982"]，规范性源于外部社会结构与共同体实践——当我们说某人“理解”一个概念时，指的并非某种纯粹私密的心理过程，而是一种社会地位：@it{在给出理由与索取理由的博弈中}承担承诺与责任@cite["brandomMakingItExplicit1994"]。
    }
    @para{
      将“理解”重构为规范性问责，便能揭示为何“中文房间”的设想依然令我们不安，以及人类的敷衍应付（slop）与 AI 的敷衍应付有何本质不同。人与人之间彼此也是黑箱，但人类受制于社会结构与切身存亡的利害关系（@it{skin in the game}，即切身利益捆绑）。人工工具缺乏这种切身利害，无法成为完全的规范性主体；它们若要融入社会，只能作为@it{可审计的工具}，由人类操作者来承担责任@cite["haugelandHavingThoughtEssays1998"]。然而在现代深度学习中，AI 公司搜罗来海量语料进行大规模预训练，无数权重在其中发生神秘的相互作用，彻底消解了这种可审计性。这就是@it{认识论上的不透明性}（epistemic opacity）：人类主体在认知上根本无法审视、拆解或追溯计算过程中产生正当性依据的要素@cite["humphreysExtendingOurselvesComputational2004"]@cite["humphreysPhilosophicalNoveltyComputer2009"]@cite["creelTransparencyComplexComputational2020"]。
    }
    @para{
      值得注意的是，克服认识论上的不透明性，并不等于重蹈笛卡尔式的覆辙去寻找“内在语义”（从而退回私人语言论证的泥淖），而是追求一种@it{实用意义上的可理解性}：即把握反事实依赖关系、诊断错误并加以干预的公共能力@cite["deregtUnderstandingScientificUnderstanding2017"]@cite["khalifaUnderstandingExplanationScientific2017"]。
      在此情形下，与传统工具相比，人类面临着一种@it{规范性失权}（normative disempowerment）：我们既无法将该系统视作同类去问责，也无法按问责制的要求，将其视作工具去审计和修正@cite["matthiasResponsibilityGapAscribing2004"]。
    }
    @para{
      此外，不妨看看药理学。有人或许会说，医学长期以来都在依赖经验上有效的药物。其实，药理学面临着与使用 LLM 相同的困境。
      许多药物虽无法做到端到端的彻底阐明，但至少在机制上实现了部分可拆解（例如业界采用的 5R 框架@cite["cookLessonsLearnedFate2014"]）；在此之上，严格的临床监管与制度性追责，将@it{切身利害}转移到了制药公司和开具处方的医生身上。
    }
    @para{
      既然我们无法赋予模型权重真正的切身存亡利害（又或者可以？若真能做到，恐怕麻烦更大），我由衷希望机械可解释性（MechInterp）研究能让 LLM 达到类似于药理学的境地。不失为一个理想而务实的折中方案。
    }
    @para{
      注：本文的前期文献调研由 LLM 深度辅助完成。
    }
  })

(provide post)