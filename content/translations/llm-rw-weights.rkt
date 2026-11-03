#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["关于 LLM 编辑权重的思考" "2026-11-02" #:lang "zh"]{
    @para{
      @link["https://rikiyat.github.io/blog/weight-space-programming/"]{@it{LLM 能原生读写神经网络权重}}
      展示的结果相当令人意外。里面确实有些夸大，比如“一个 LLM 提升了小模型的数学能力”。
      我的意思是，这话当然没错，但写成“一个 LLM 发现并调整了权重中导致推理循环的 bug”会更好……
      此外，这种说法也低估了可解释性社区已经打下的基础。
      尽管如此，这件事仍然很令人震惊，对微调和可解释性都有影响，尤其是它又提供了一个 LLM 能做到什么程度的案例。
      能有一个针对它的基准测试会非常有意思。
    }
    @heading["output"]{输出里有什么？}
    @para{
      显然 OpenAI 拒绝向我们展示 CoT，但我们仍能翻看存放在 @link["https://github.com/RikiyaT/lm_understand-logs"]{GitHub 仓库}里的模型输出。
      可以得出结论——至少看起来是这样——方法本身与人的做法差别不大，只是 LLM 的注意力持续时间远超人类工作记忆，
      所以在一定量级内，它不需要草稿纸、计算器或 matplotlib 来做繁重的工作。我的一些想法：
    }
    @para{
      @bold{EXP1 和 EXP2。} 由于 CoT 被隐藏，这里能看到的并不多。
      这意味着 LLM 能发现并可视化第一层权重中的模式，而这些模式能强烈暗示训练数据的特征（例如哪些数据被忽略）。
      人类可能需要画图，但 LLM 直接就能“看见”。另外，既然 LLM 知道输入是进入第一层的网格，排列不变性中困难的部分也可以绕开。
      与 EXP1 类似，EXP2 表明 LLM 会查看输出层权重并识别输出模板。原博客文章也很好地讨论了它的启发式方法和局限。
    }
    @para{
      @bold{EXP3。} 熟悉的归纳头识别。@cite["elhageMathematicalFrameworkTransformer2021"]@cite["olssonIncontextLearningInduction2022"]
    }
    @para{
      @bold{EXP4。} 一个有趣的案例。Astra 知道物理场景的信息，并且覆盖了网络的行为：@code{I will retain the learned network except for a small isolated control path} 和
      @code{Once green’s centre passes x = 0.95... the override switches off. The bias offsets cancel its inactive outputs}。
      这些修改是在少量神经元上施加很大的权重。
      历史上可类比的是 Maclin 和 Shavlik 将建议插入神经强化学习智能体的工作，@cite["maclinIncorporatingAdviceAgents1994"]@cite["maclinCreatingAdvicetakingReinforcement1996"]
      不过他们的方法增加了网络结构，并利用后续学习来改进建议。
    }
    @para{
      @bold{EXP5 和 EXP6。} EXP5 的运行大约用了 17–26k 个推理 token，摘要类似 @code{Calculating F(x+8)}
      和 @code{Checking reflection formula}。可以推测 CoT 被当作计算器，至少部分模拟一次 rollout 会是什么样。
      除此之外，关于写权重方法的解释在原文章里。我对 EXP6 里的围棋不太熟悉。不过这个网络是用启发式方法构建的：
      @code{These heuristics should exploit tactical mistakes while maintaining territory and living groups.}
      手工设计的围棋启发式由来已久，@cite["zobristModelVisualOrganization1969"]，不经过训练就构建神经网络也有先例，包括像
      Tracr 这样的程序到权重编译器。@cite["lindnerTracrCompiledTransformers2023"] 但在我看来，从零开始、不训练就搭出一个神经网络仍然非常不可思议。
    }
    @para{
      @bold{EXP7。} 这更接近人的做法。相关工作识别出与谄媚相关的头会关注用户线索，@cite["genadiSycophancyHidesLinearly2026"] 稀疏的早期头携带用户意见，@cite["chenTracingMechanismsSycophantic2026"] 以及一小部分头（在报告的实验中约占 4%）对谄媚输出有实质性影响。@cite["chenYesMenTruthTellers2024"]
    }
    @para{
      @bold{EXP8。} 这是所有炒作的重点。不过提示词给了它线索：@code{for example, if the model often fails because it repeats itself and never finishes, finding and fixing what drives that repetition counts}。
      还有一个转向向量的修复。这可以由人完成。Turner 等人提出了激活相加，@cite["turnerActivationAdditionSteering2023"]，相关工作包括对比激活相加 @cite["rimskySteeringLlamaContrastive2024"] 和表征工程。@cite["zouRepresentationEngineering2023"]
      更直接地，Arditi 等人通过权重正交化移除一个行为方向，@cite["arditiRefusalLanguageModels2024"]，尽管他们的目标是拒绝而非重复推理。原博客文章也引用了这项工作。
    }
    @heading["learn"]{这种能力从何而来？}
    @para{
      很容易想说这种能力是在 LLM 中“涌现”出来的。但如我们所知，现实中的 LLM 训练很复杂，并且高度依赖预训练和后训练。正如 @link["https://x.com/AlexKrentsel/status/2117376683724660898"]|{由 @AlexKrentsel 在 X 上}| 所指出的，
      似乎只有前沿模型才行。我们可以合理假设，这可能是 OpenAI 或 Anthropic 的工程师在做 RSI 或其他工作时刻意用这些任务微调模型的结果。
    }
    @para{
      虽然这既不充分也不必要，但我们也可以合理地说，如果一个模型纯粹从预训练中获得了这些技能，那么智能水平相近的模型应该也有相似的直接摆弄原始权重的本领。我 @link["https://github.com/yikerman/llm-rw-weight-extended-test/blob/master/report/replication.pdf"]{做了一个快速测试}，
      对象是 Artificial Analysis 所衡量的一般智能水平上的 SOTA 模型，前提是这项评测公平。有趣的是，在前沿模型中，@it{Kimi K3.1 Pro} 是个异类：
      它做这项任务只有平庸水平，而它的 AA 分数大致与 @it{Fable 5.1} 相同。另外，虽然 @it{6.1 Sol} 可以说是更弱的模型，它做这项任务却比 Kimi 更好。
      要么这是一种涌现能力，而 Kimi 只是个擅长刷榜的差模型，要么就是 Google、OpenAI 和 Anthropic 在后训练中特意微调并试验过相关想法，
      而 Moonshot 作为中国模型公司，侧重点不同，没有专门照顾这项任务。
    }
    @para{
      免责声明：关于现有工作的大量调研得到了 LLM 的协助。
    }
  })

(provide post)