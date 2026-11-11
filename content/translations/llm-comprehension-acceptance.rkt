#lang at-exp racket/base

(require ycao-net/lib/markup)

;; more skin in the game => normative agency?????

(define post
  @article["我们不喜欢 LLM 的输出，原因不在“理解”" "2026-11-08" #:lang "zh"]{
    @para{
      尽管到目前为止，LLM @link["/posts/ai-se-dilemma.html"]{在可观测（就功能主义而言）的输出模式上仍与人类大相径庭}，
      但有两点值得注意：（一）人类也时不时敷衍糊弄（slop）、产生幻觉，我们最亲爱的同事搞出的烂摊子早已数不胜数；（二）正如上文链接末段所言，@it{“人们完全可以争辩说，‘理论上人类正在做的任何事，LLM 都能做’”}。
      这固然尚存争议，也是个棘手而深刻的问题；但不可否认，LLM 已然展现出超人水准，在诸多领域（坦白说主要是数学）表现卓越。不过，为什么我们不该把一切都一股脑交给 LLM，背后还有更深层的理由。
    }
    @para{
      人们通常认为，之所以要限制或干预 LLM 的使用，是因为我们需要人类的“理解”。
      但“理解”本身就是个麻烦重重的概念。中文房间论证（Chinese Room Argument）@cite["searleMindsBrainsPrograms1980"]本意是反击强功能主义与计算主义，结果却反噬了自身，因为它的立论建立在一个可疑的笛卡尔式假设之上：真正的“理解”在于某种孤立的、具有内在意向性（intrinsic intentionality）的内部心理状态。维特根斯坦的遵循规则问题与私人语言论证（Private Language Argument）矛头直指这一假设——以及更广义的方法论与语义唯我论（Methodological / Semantic Solipsism）@cite["wittgensteinPhilosophicalInvestigations1953"]。正如《斯坦福哲学百科全书》（SEP）第 1 节所概括的@cite["candlishPrivateLanguage2019"]：@code{The conclusion is that a language in principle unintelligible to anyone but its originating user is impossible. The reason for this is that such a so-called language would, necessarily, be unintelligible to its supposed originator too, for he would be unable to establish meanings for its putative signs.}
    }
    @para{
      症结不在于理解，而在于规范性（normativity）。注意我们在争论时的说法：“我们@bold{不该}把一切都交给 LLM”。抛开私人语言论证（PLA）不谈，就算我们确实拥有可测量的神经生物状态，或是“感受质”（Qualia）之类，它们也只是@it{规范上惰性的}（normatively inert）事实。
      中文房间把关于“理解”的事实断言错当成了规范地位。孤立来看，无论是生物大脑还是自注意力模块（self-attention block），都不具备语义规范性@cite["sellarsEmpiricismPhilosophyMind1956"]。
    }
    @para{
      但现实中确实存在规范性客体，比如法律合同，或是输出对错结果的程序。按照规范实用主义（normative pragmatism）@cite["brandomMakingItExplicit1994"]的观点，规范性源于外部社会结构与共同体实践——说某人“理解”一个概念，指的并非某种纯粹私密的心理过程，而是一种社会地位：@it{在给出理由与索取理由的游戏（the game of giving and asking for reasons）中}承担承诺与责任。
    }
    @para{
      将“理解”重构为规范问责（normative accountability），便能再次揭示中文房间思想实验为何令人不安——以及人类产出的垃圾与 AI 垃圾（AI slop）有何不同。人与人之间彼此也是黑箱，
      但人类受制于社会结构与生存利害（@it{切身利害}，即 @it{skin in the game}）。人造工具缺乏这种利害关系，无法充当完全的规范主体（normative agents）@cite["haugelandHavingThoughtEssays1998"]；
      相反，它们之所以能融入社会，靠的是作为@it{可审计的工具}，由人类操作者承担责任。然而在现代深度学习中，AI 公司搜罗各种庞大语料进行大规模预训练，海量权重之间发生着神秘的交互，这种可审计性随之消解：
      这便是@it{认识论不透明性}（epistemic opacity），即人类主体在认知上根本无法检查、拆解或追溯计算过程中产生正当性依据（warrant-generating）的要素@cite["humphreysPhilosophicalNoveltyComputer2009"]。
    }
    @para{
      值得注意的是，克服认识论不透明性并不等于重蹈笛卡尔式的覆辙去寻求“内在语义”（从而再次落入 PLA 的靶心），而是追求一种@it{实用可理解性}（pragmatic intelligibility）：一种能够把握反事实依赖、诊断错误并加以干预的公共能力@cite["deregtUnderstandingScientificUnderstanding2017"]。
      在这种情况下，与传统工具相比，人类正面临一种@it{规范性失权}（normative disempowerment）：按照问责所要求的程度，我们既无法把系统当作同侪来追责，也无法把它当作工具来审计和修正@cite["matthiasResponsibilityGapAscribing2004"]。
    }
    @para{
      不妨再看看药理学。有人或许会说，医学长期以来一直依赖经验上有效的药物。其实药理学面临着与使用 LLM 同样的困境。看看药理学在实用主义上的权衡吧：
      许多药物虽然尚未实现端到端的完全理解，但仍在一定程度上做到了机制可拆解（例如阿斯利康转向了 5R 框架（5R Framework）@cite["morganImpactFivedimensionalFramework2018"]），
      在此基础上，严格的临床监管与制度追责将@it{切身利害}转嫁到了制药公司与开方医生身上。
    }
    @para{
      既然我们没法赋予模型权重真正的生存利害（还是说其实可以？真要可以那麻烦就更大了），
      我衷心希望机制可解释性（MechInterp）能让 LLM 走到类似药理学的位置。那会是一个不错的实用主义折中方案。
    }
  })

(provide post)