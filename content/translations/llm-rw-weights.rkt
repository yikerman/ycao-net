#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["关于大语言模型编辑权重的思考：新意何在？" "2026-11-02" #:lang "zh"]{
    @para{
      @link["https://rikiyat.github.io/blog/weight-space-programming/"]{@it{LLMs can natively read & write neural network weights}}
      一文展示的结果颇令人惊奇。文中确实有些夸大其词，比如“LLM 提升了小模型的数学能力”。
      这话倒也没错，但写成“LLM 在权重中找出并修复了导致推理死循环的漏洞”或许更贴切……此外，该文的叙事也淡化了可解释性社区此前打下的深厚基础。
      尽管如此，这一结果依然相当惊人，对模型微调与可解释性研究颇具启示，尤其它再次印证了 LLM 的能力边界。如果能为此建立一套基准测试（bench），想必会非常有趣。
    }
    @heading["output"]{输出了什么内容？}
    @para{
      显然，OpenAI 拒绝向我们展示思维链（CoT），但我们依然可以去翻看保存在 @link["https://github.com/RikiyaT/lm_understand-logs"]{GitHub 仓库}里的模型输出。
      由此似乎可以得出结论：LLM 所用的方法与人类的常规做法相去不远，只不过它的注意力广度远超人类的工作记忆。因此，在一定限度内，它无需借助草稿纸、计算器或 matplotlib 就能完成繁重的推演。
      以下是我的一些想法：
    }
    @para{
      @bold{EXP1 与 EXP2。}由于隐藏了思维链，这里展现的信息不多。
      实验表明，LLM 能够检测并在脑海中具象化第一层权重的规律，而这些规律往往强烈暗示了训练数据的分布特征（例如哪些数据被忽略了）。人类或许需要画图辅助，LLM 却能直接“看”出来。
      此外，既然 LLM 知道输入第一层的数据是网格（grid），就能设法绕过排列不变性（permutation invariance）这一难题。与 EXP1 类似，EXP2 表明 LLM 能够观察输出层权重并识别出输出模板。至于其启发式方法与局限性，原博客文章已论述得十分透彻。
    }
    @para{
      @bold{EXP3。}耳熟能详的归纳头（induction head）识别。@cite["elhageMathematicalFrameworkTransformer2021"]@cite["olssonIncontextLearningInduction2022"]
    }
    @para{
      @bold{EXP4。}这是个有趣的案例。Astra 掌握了物理场景的相关信息，并强行接管（override）了网络的行为：@code{I will retain the learned network except for a small isolated control path}，以及
      @code{Once green’s centre passes x = 0.95... the override switches off. The bias offsets cancel its inactive outputs}。
      这些修改是在极少数神经元上施加极大的权重。
      历史上与此类似的研究，是 Maclin 和 Shavlik 将人为建议植入神经强化学习智能体的工作，@cite["maclinIncorporatingAdviceAgents1994"]@cite["maclinCreatingAdvicetakingReinforcement1996"]
      只不过他们的方法会增加网络结构，并利用后续学习来微调这些建议。
    }
    @para{
      @bold{EXP5 与 EXP6。}EXP5 的运行消耗了大约 1.7 万到 2.6 万个推理 token，生成的摘要包括 @code{Calculating F(x+8)}
      和 @code{Checking reflection formula} 等。我们可以猜测，模型将思维链当成了计算器，至少在部分程度上模拟了策略展开（rollout）的过程。此外，原博客也解释了写入权重的具体方法。我对 EXP6 涉及的围棋不太熟悉，但那个网络显然是基于启发式规则构建的：
      @code{These heuristics should exploit tactical mistakes while maintaining territory and living groups.}
      人工设计围棋启发式规则由来已久，@cite["zobristModelVisualOrganization1969"]不经训练直接构建神经网络也有先例，比如 Tracr 这类将程序编译为权重的编译器。@cite["lindnerTracrCompiledTransformers2023"]但完全不经训练、从零手搓出一个神经网络，在我看来依然非常不可思议。
    }
    @para{
      @bold{EXP7。}这更接近人类的做法。相关研究曾识别出关注用户暗示的迎合（sycophancy）相关注意力头、@cite["genadiSycophancyHidesLinearly2026"]承载用户观点的早期稀疏注意力头，@cite["chenTracingMechanismsSycophantic2026"]以及对迎合性输出有重大影响的极少数注意力头（在已报告的实验中约占 4%）。@cite["chenYesMenTruthTellers2024"]
    }
    @para{
      @bold{EXP8。}这就是引发各种炒作的源头。不过提示词其实给出了暗示：@code{for example, if the model often fails because it repeats itself and never finishes, finding and fixing what drives that repetition counts}。
      这同样属于引导向量（steering-vector）修复，人类也能完成。Turner 等人提出了激活相加（activation addition），@cite["turnerActivationAdditionSteering2023"]相关工作还包括对比激活相加（contrastive activation addition）@cite["rimskySteeringLlamaContrastive2024"]与表征工程（representation engineering）。@cite["zouRepresentationEngineering2023"]
      更直接的先例是，Arditi 等人通过权重正交化（weight orthogonalization）消除了特定的行为方向，@cite["arditiRefusalLanguageModels2024"]
      只不过他们针对的是拒绝回答，而非重复推理。原博客也引用了这项工作。
    }
    @heading["learn"]{这种能力从何而来？}
    @para{
      我们很容易将其归结为 LLM 的“涌现”能力。但众所周知，实际的 LLM 训练过程错综复杂，高度依赖预训练与后训练。正如 @link["https://x.com/AlexKrentsel/status/2117376683724660898"]|{@AlexKrentsel 在 X 上}|所指出的，
      似乎只有最前沿的模型才能胜任。我们有理由推测，这或许是 OpenAI 或 Anthropic 的工程师在探索递归自我改进（RSI）或其他方向时，专门针对此类任务微调了模型。
    }
    @para{
      虽非充要条件，但我们也可以合理推测：假使模型纯粹通过预训练习得这些技能，那么智能水平相近的模型，其直接探查原始权重的能力也应相差无几。假定 Artificial Analysis 的评估足够公允，我针对其通用智能排名顶尖（SOTA）的模型@link["https://github.com/yikerman/llm-rw-weight-extended-test/blob/master/report/replication.pdf"]{做了一个快速测试}。
      有趣的是，在这些前沿模型中，@it{Kimi K3.1 Pro} 是个异类：它的 AA 评分与 @it{Fable 5.1} 大致相当，但在该任务上的表现却颇为平庸。
      这只有两种可能：要么这确实是涌现能力，而 Kimi 只是个单纯刷榜（benchmaxxing）的劣质模型；要么就是 Google、OpenAI 和 Anthropic 在后训练阶段专门做了微调并尝试了相关构想，而月之暗面（Moonshot）作为一家中国大模型公司，研发侧重点有所不同，并未针对此类任务做过迎合。
    }
    @para{
      注：本文中大量的过往文献调研工作由 LLM 协助完成。
    }
  })

(provide post)