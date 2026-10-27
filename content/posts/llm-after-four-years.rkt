#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["AI、智力工作、人类和未来" "2026-10-27" #:lang "zh"]{
    @para{
      不好意思，这又是一篇关于LLM的博客。距上一篇@link["/posts/llm-after-three-years.html"]{《三年LLM》}其实只过去半年，但是半年中确是发生了太多，主要是OpenAI的NS爆破解，七百多个数学证明，还有@link["https://openai.com/index/building-scientific-understanding-with-academic-communities/"]{今天发布的，三个极难问题的解}。假设LLM只是大号搜索引擎或者在人类知识取凸包显然是不可能的了。现在可以断言的是，对于形式化的、先验的问题，LLM可以极大程度地帮助（帮助！毕竟普通人用astra prompt显然是做不出成果的——我试着把Lean写的Infinitely Many Mersenne Primes Conj喂给astra，它试了一个小时后摆烂放弃了。但是数学学者显然从AI身上获益良多）人类探索，并且完成以前做不出的成果。这离AGI还有好些距离，但是已经足够推翻之前的假设，做出一些新的判断了。
    }
    @para{
      LLM会遇到瓶颈吗？我不知道…… 只能说，新证据表明scaling law依然有效，而且站在行业前沿的人并没有见到显然的障碍。站在一个指数发展的曲线中部，它突然停下才是让人惊讶的事情。@cite["stanfordhai2026ConferencePhysics2026"] 有趣的是，最新的一波进步和Lean 4的发展和使用联系相当紧密。Prior Art中不乏利用纯先验（Tabula Rasa）RL解决形式化数学问题，但是都以无实用价值告终。@cite["wuTacticZeroLearningProve2021"] 问题很多来源于奖励过于稀疏，解空间过大，训练无法扩展。可以合理猜测LLM学习了人类数学后以此作为起点，利用Lean成功bootstrap了数学RL。@cite["hubertOlympiadlevelFormalMathematical2026"]LLM对别的学科影响尚不清楚，但是显然接近理论/形式化的都难逃死手。
    }
    @para{
      AI安全？这件事确实可以严肃讨论了。若是看传统的安全，@link["https://cloud.google.com/blog/topics/threat-intelligence/vulnerability-discovery-and-exploitation-trends-in-the-ai-era"]{2026年CVE达到了前所未有的数量}。不过对此我并不太担心，毕竟红队就是网安的一部分，他们找出了这么多CVE，这是好事啊。鉴于AI还可以助力形式化验证，以后的软件甚至终于有资源可以出正确性的证明（初步尝试见@link["https://github.com/kim-em/lean-zip"]{lean-zip}和@link["https://www.anthropic.com/research/formal-verification"]{OSS-Fuzz}）。（形式化目前为止还存在一些pitfall，比如@link["https://www.lesswrong.com/posts/zHhGa3iQBQcdSifFL/a-critical-look-at-lean4-1"]{Lean 4的soundness}、还有Trusting Trust@cite["thompsonReflectionsTrustingTrust1984"]，不过这些都是存在可接受解决方案的。）
      @img["/files/20261026/good-thing-meme.jpg" #:scale 0.3]{这是好事啊}
    }
    @para{
      另一值得考量的AI安全问题是Reward Hacking，在LessWrong上作为AI doom经常讨论到，著名思想实验包括@link["https://www.lesswrong.com/w/paperclip-maximizer"]{回形针工厂}。我个人也的确遇到过，在测试Command Code的时候遇到了一个bug，让AI自行解决。符合人类道德标准的方法是上网搜文档和issue区，但是AI直接把这个闭源软件逆向了。它的确完成了我的目标，但是使用的方法却是不符合道德的。抛开我对LessWrong上硅谷病态伪善文化的私人恩怨，我对此也并不过于担心：既然AI如此精通于形式化，我们可以形式化一些相当强的条件，比如“任意AI都有强制关闭的方法”或者“完全无副作用的沙箱”或者“任意操作都能在有限时间内完全反转”，这比起“不准伤害人类”显然是易于形式化得多的。更显然的解法还包括人类模仿等，把利害纯形式化分析不出问题才怪，毕竟这玩意（道德哲学）充斥着矛盾、模糊和相对主义。当然本文不立志解决AI安全，况且其研究还相当早期。
    }
    @para{
      人类价值…… 多么痛苦的话题。我们一直自认因为智力而独一无二，凌驾于各物种之上。而现在步入的时代描绘的前景却和《人类科学之演变》@cite["chiangTheEvolutionHumanScience2016"] 一样，科学家捡拾着AI残羹剩饭。这是令人沮丧的…… 吗？对于大多数人，总是存在智力（假设智力是有序的）比你高的人，但你也从未因此觉得沮丧。笔者曾为此焦虑不已，归根结底还是所受教育灌输了过多优绩主义和功利主义——你为什么一定要比一个人（现在是一个东西）好（通常是智识上好）才可以快乐？如果想好受一点的话，笔者一位相当有洞见的朋友指出，从认知科学的角度“人类怎么在这么蠢的同时还能做到这么多？已经很了不起了”。确实，智人大脑绝大多数时间优化的方向都是社交、捕猎@cite["dunbarSocialBrainHypothesis1998"]；从这个角度看，文明在短时间内将形式化答案搜索推进到现代几乎已是无法可想的@cite["dehaeneCulturalRecyclingCortical2007"]。输给机器并不丢人。另外，在假设AGI的情况下，完全可以想见AI可以提升人类智力，回到研究前沿（当然显然此处何为人类存在些道德问题）。
      （不过本文在此将不深入探讨人的价值（虚无主义？存在主义？），笔者本人仍非常欠缺哲学素养。）
    }
    @para{
      相反，更值得关注的是社会价值和分配。工业革命重组了传统劳动方式，而生产率提高的收益并没有立即惠及普通劳动者。之后所谓智力工作者，顶层是企业家、政客，之后是科研人员，程序员等，踩在了社会阶梯的顶层和中层。而现在这些脑力工作者也尝到了十九世纪下岗工人的味道@cite["allenEngelsPauseTechnical2009"]。延续《三年》，我们（尤其是中国）必须意识到不应该将智力定性为衡量人价值的标准——事实上不应该有任何标准，这个标准的功利性价值都快结束了。人每天需要找两千大卡进账、不病死、剩下的都是干点自己想干的事情，病态的社会评价体系终将被抛弃。经济上的分配更是迫在眉睫。AI能改善人的生活是显然的：不妨构造一个平凡解——现有所有生产关系不变，AI取代一些工作后所有人都留在原来岗位上，大多数时间改成吃干饭或者放假等，且节省的成本足以覆盖AI的运行成本。这严格好于无AI的时代，但现实却是股市节节攀升，人民生活却似乎更差了。这还是回到了生产关系和生产能力错位的问题，显然某主义国家的某主义并没有发挥作用。额外的，也有对终产者的担忧，OpenAI和Anthropic当下已经有相当病态的文化和垄断倾向。不过好在中国实验室一直在发开源模型，智能和前沿SOTA模型并无本质代沟，我觉得垄断资本大获全胜可能性还是相当小的。
    }
    @blockquote{
      It was the best of times, it was the worst of times, it was the age of wisdom, it was the age of foolishness, it was the epoch of belief, it was the epoch of incredulity, it was the season of light, it was the season of darkness, it was the spring of hope, it was the winter of despair.
    }
  }
)

(provide post)
