#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post-llm-after-three-years
  @article["三年LLM：过去和未来" "2026-03-27"]{
    @para{
      OpenAI的ChatGPT于2022年年底发布。得益于境外手机号接码渠道，我第一时间就用上并惊叹于人工智能的突破。一转眼，LLM在过去的三年里已无可辩驳地渗透至千家万户。
    }

    @heading["history"]{一小段历史}
    @para{
      Transformer模型最早于2017年由谷歌提出，核心思路是通过Self-Attention机制显式地表达词语之间语义联系@cite["vaswaniAttentionAllYou2017"]。OpenAI在2018年首次发布GPT-1模型，将架构简化为Decoder-only的Autoregressive词语预测@cite["radfordImprovingLanguageUnderstanding2018"]。自此，LLM的总体架构尘埃落定，后续的GPT-2、GPT-3等皆在此基础上扩展模型大小和数据集的规模。不仅局限于文字，Transformer在视觉领域表现也很好@cite["kolesnikovImageWorth16x162021"]。为何大模型能够@it{涌现}出强大的能力仍不得而知。Anthropic于2021年在一个极度简化的模型中发现了Induction Heads结构@cite["geshkovskiMathematicalPerspectiveTransformers2025"]，但如同生物学第一次发现红细胞，我们离真正理解LLM的工作原理相差甚远。
    }

    @heading["my-experience"]{我的经历}

    @para{@bold{朴素文本生成与搜索引擎}}
    @para{
      记忆中，初代GPT-3.5尚且幻觉频发，其输出往往需人工核查事实。那些本身不具严肃意义、亦无需严格验证的作文任务，最宜交由GPT处理，这也算是回归了其文本续写的本质功能。
    }
    @para{
      GPT在联网后实用性显著提升。比起传统搜索引擎，GPT的优势在于：其一，迅速地总结和提炼信息。谷歌在搜索引擎中嵌入了AI Overview，实际体验确实更加方便；其二，也是最重要的——解决了搜索引擎“不知道搜什么关键字”的问题。比如我想知道“3D游戏中角色自适应动画如何实现”，LLM会直接告诉我我应该搜索“Inverse Kinematics”。这是传统基于关键词的搜索引擎难以企及的。
    }

    @para{@bold{LLM即老师}}
    @para{
      LLM在教学方面潜力巨大。教学任务与LLM高度契合：不仅模型本身具备大量先验的初等知识（训练集中反复），教材也能提供充足的上下文，学生的问题大多也是小规模良定义的，只需要LLM重新解释一遍即可。
    }
    @para{
      常规问答必不多言。拿到Claude Code后，我试着将哈佛的@link["https://nlp.seas.harvard.edu/annotated-transformer"]{The Annotated Transformer}和Karpathy的@link["https://github.com/karpathy/nanoGPT"]{nanoGPT}投喂进Claude Code，令其对照两份材料，撰写一份从零构建GPT的教程。@link["https://github.com/yikerman/learn-attn/commit/8864b8dacb70b4219de6efe951064e46b5d6b7b2"]{第一版}完成度尚可，但是作为教材未能妥善处理读者的阅读顺序和知识背景。我顺序阅读并学习，遇见觉得不通顺的地方就给予明确指示如何重写，最终两天完成一份在我认为@link["https://github.com/yikerman/learn-attn/blob/b193e0b5b687d35e9fc825e85b66c75462b899ca/learn/babygpt-tutorial.pdf"]{质量不错的教程}。可见虽LLM仍需人类引导，效率提升非常显著。
    }
    @para{
      若使用不当，LLM也会带来意料之中的麻烦——倘若只知复制粘贴，知识终究未曾过脑@cite["kosmynaYourBrainChatGPT2025"]。這種成績，使人汗顏！（发自我的手机）
    }

    @para{@bold{多模态和Agent}}
    @para{
      Agent概念虽被外界炒作得天花乱坠，思路其实非常朴素：在prompt中教LLM以固定的格式引用外部工具（如读取文件、爬取网页等），确定性代码结果加入LLM上下文。Agent刚被引入时看上去能大幅度提升LLM智力，究其根本还是提供了正确充分的上下文，与人类手动提供上下文（如将一个框架的文档粘贴进对话框）本质没有区别，Agent只是自动化了这个过程。程序员是Agent的最大受益者，因其需频繁与代码仓库交互。LLM代码能力已被多次探讨过，同样的，在缺乏显式引导下LLM喜欢写毫无设计且充斥着不必要冗余的代码。有软工水平的人可以通过LLM大幅提升效率，反之则大概率误入歧途。
    }
    @para{
      多模态能力很有用，但相较于文字稍不稳定一些。我试图用@link["https://github.com/yikerman/math-notes/blob/90ac740f7d2509aa48f0bf4bef64d6b3ca8cd7e0/CLAUDE.md"]{Claude Code将我糟糕的手写数学笔记转化为整齐编排的@math{\LaTeX}文档}。效果相当好，文字几无人工干预需要，TikZ画图有大概50%成功率，大多需要人工调整。我注意到有些输出数学上正确，却和我原有笔记不一致。合理猜测LLM只是从图片大致概括得我的笔记内容，对于一些细节都采用了先验知识猜测和补全。
    }

    @heading["outlook"]{未来展望}

    @para{@bold{AI存在泡沫吗？}}
    @para{
      LLM爆发后，两类产品尤为惹人生厌。其一，大公司为取悦短视股东，生硬地在产品中植入AI大粪，如Windows自带Copilot，臭不可闻。再者是一些@link["https://github.com/yikerman/awesome-ai-slop"]{小团队或者个人写的灾难级产品}，哪怕是猪，站在风口上也能飞起来，荣誉提名OpenClaw。两者都证明了搞金融和做新闻的人非蠢即坏。
    }
    @para{
      不仅如此，即使对有真才实学的AI公司（Google、OpenAI、Anthropic、阿里等，好歹是干实事的），盈利仍非常困难，OpenAI至今都在烧投资人的本金。高杠杆加上总体的经济停滞/下行趋势并不是一个好兆头。考虑到AI仍是有用的（不像前阵子Web3和Meta纯粹的骗局），我更倾向于AI会像互联网泡沫一样，大浪淘沙留下有价值的产品，只是中间泡沫破裂不知会软着陆还是硬着陆。
    }

    @para{@bold{LLM真的理解吗？}}
    @para{
      现有LLM智能已足够好，但和人类智能还有本质上的区别@cite["dawidIntroductionLatentVariable2024"]。从端到端的角度看，LLM只是概率拟合，无可避免的会给似是而非的东西，上下文对输出的影响@it{非常}显著。早期Prompt Engineering就意图解决这个问题，尽管本身噱头大于技术。一部分，LLM听风是雨，对Prompt内容深信不疑。这点在自动化流程中比较灾难，如一个联网的LLM Agent在搜得网页中获取了错误信息，它会以看上去非常可信的方式总结和呈现。上下文也有更微妙的影响方式。LLM会尽力模仿上下文，后果是若代码里有隐藏的bug或不良的架构，LLM会继续沿用错误的方式，将问题越堆得积重难返。
    }
    @para{
      简而言之：LLM的输出与输入强相关，且很多知识仍需后验提供。人类提供正确上下文和对大方向的“品味”反而更加的重要。
    }

    @para{@bold{大家都会失业吗？}}
    @para{
      据上述，LLM与人类显然仍具不少差距。更恰当的类比为，LLM是脑力劳动领域的纺织机——取代trivial的脑力劳动，如水文字。自然的，@it{若}之后有全球范围的失业潮和经济下行，LLM充其量也只是引火线而已：总生产力提升了，为何生活水平反而下降？那必然是分配问题，大可不必因LLM感到存在危机。
    }
    @para{
      有趣的副作用是，LLM祛魅了如教师、科学家、程序员等职业的神秘性。（并不是说这些职业不值得被尊重。且不必沮丧：AI能做是因为我们（在训练数据里）反复做过太多次，是时候休息一下了）新工具揭露了这些职业@it{大部分}工作内容同样的trivial，在现有技术下易于自动化。坐办公室的白领再也没有理由看不起工厂的蓝领，大家本质都是讨辛苦饭的牛马打工人。
    }

    @para{@bold{LLM有瓶颈吗？}}
    @para{
      个人的猜测是LLM将会遇到瓶颈，原因是训练数据的劣化。互联网上愈发的充斥着LLM洗稿低质量内容，之后的LLM训练要么不引入新的数据，要么会逐渐退化为蒸馏前代LLM。但蒸馏只是面向小模型的特化技巧，用劣化的数据训练模型只能得到劣化的结果@cite["shumailovAIModelsCollapse2024"]。模型本身的架构上限尚不明确，毕竟人类连Transformer为何涌现出如此多的智能还不清楚。
    }
    @para{
      我还有一些闲杂的思绪：近来有很多试图拓展LLM上下文的研究。但仔细审视人类的记忆和思维，短时工作记忆并没有那么高，更重要的能力是抽象和直觉——一个抽象中（如一个数学公理）下层细节对我是透明（transparent）的，我只需要知道条件和结果之间的关系，并一定程度依靠直觉判断何时调用哪种抽象来解决问题。
    }
  })

(provide post-llm-after-three-years)
