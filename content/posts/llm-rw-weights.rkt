#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["Thoughts on LLMs Editing Weights: What's New?" "2026-11-02"]{
    @para{
      The results shown in @link["https://rikiyat.github.io/blog/weight-space-programming/"]{@it{LLMs can natively read & write neural network weights}}
      are quite surprising. It indeed has some overstatements like "an LLM improved the math ability of a small model".
      I mean, certainly it is true, but it would be better to write "an LLM identified and tweaked a
      reasoning-loop bug in the weights"... Also the framing undersells how much groundwork the 
      interpretability community has already done.
      Nonetheless, it is still quite startling and has implications for fine-tuning and interpretability,
      especially another case on what LLM can achieve. It will be very interesting to have a bench
      on it.
    }
    @heading["output"]{What is in the output?}
    @para{
      It is apparent that OpenAI refuses to show us the CoT, but we can still poke around in the model
      output stored in @link["https://github.com/RikiyaT/lm_understand-logs"]{the GitHub repo}. We
      can conclude that, at least it seems that, while the methodology is not very far from what a human
      would do, the LLM just has so much more attention span than human working memory that it does not
      need scratch paper or a calculator or matplotlib to do the heavy lifting up to a certain amount.
      Some of my thoughts:
    }
    @para{
      @bold{EXP1 and EXP2.} Not a lot is present here due to the hidden CoT.
      It implies that the LLM can detect and visualize patterns in the first-layer weights which can strongly
      suggest training data patterns (e.g. what data are ignored). Humans may need some plotting, but the LLM can just "see" it.
      Additionally, since the LLM knows the input is a grid that goes into the first layer, the hard
      part of permutation invariance can be worked around. Similar to EXP1, EXP2 suggests that
      the LLM is looking at the output-layer weights and spotting templates of output. Its heuristics and limitations
      are also well addressed in the original blog post.
    }
    @para{
      @bold{EXP3.} Familiar induction-head identification.@cite["elhageMathematicalFrameworkTransformer2021"]@cite["olssonIncontextLearningInduction2022"]
    }
    @para{
      @bold{EXP4.} An interesting case. Astra has information about the physics scenario and has overridden the
      network's behavior: @code{I will retain the learned network except for a small isolated control path} and
      @code{Once green’s centre passes x = 0.95... the override switches off. The bias offsets cancel its inactive outputs}.
      The edits are very large weights over a small number of neurons.
      A historical parallel is Maclin and Shavlik's work on inserting advice into neural reinforcement-learning
      agents,@cite["maclinIncorporatingAdviceAgents1994"]@cite["maclinCreatingAdvicetakingReinforcement1996"]
      although their approach adds network structure and uses subsequent learning to refine the advice.
    }
    @para{
      @bold{EXP5 and EXP6.} The EXP5 runs use roughly 17–26k reasoning tokens, with summaries like @code{Calculating F(x+8)}
      and @code{Checking reflection formula}. It can be suspected that CoT is used as a calculator
      that simulates, at least partially, what a rollout will be like. Otherwise, an explanation of the weight-writing
      methodology is in the original post. I am not very familiar with Go in EXP6. The network is built heuristically, though:
      @code{These heuristics should exploit tactical mistakes while maintaining territory and living groups.}
      Hand-designed Go heuristics have a long history,@cite["zobristModelVisualOrganization1969"] and constructing
      neural networks without training also has precedents, including program-to-weight compilers such as
      Tracr.@cite["lindnerTracrCompiledTransformers2023"] But building a neural network from scratch without
      training is still very wild to me.
    }
    @para{
      @bold{EXP7.} Much closer to what a human would do. Related work identifies sycophancy-related heads
      attending to user cues,@cite["genadiSycophancyHidesLinearly2026"] sparse early heads carrying user
      opinions,@cite["chenTracingMechanismsSycophantic2026"] and a small subset of heads (approximately 4%
      in the reported experiments) with a substantial influence on sycophantic outputs.@cite["chenYesMenTruthTellers2024"]
    }
    @para{
      @bold{EXP8.} What all the hype is about. The prompt gives it a hint tho: @code{for example, if the model often fails because it repeats itself and never finishes, finding and fixing what drives that repetition counts}.
      Also a steering-vector fix. This can be done by a human. Turner et al. introduced activation
      addition,@cite["turnerActivationAdditionSteering2023"] with related work on contrastive activation
      addition@cite["rimskySteeringLlamaContrastive2024"] and representation engineering.@cite["zouRepresentationEngineering2023"]
      More directly, Arditi et al. remove a behavioral direction through weight orthogonalization,@cite["arditiRefusalLanguageModels2024"]
      although their target is refusal rather than repetitive reasoning. The original blog post cites this work too.
    }
    @heading["learn"]{How is this ability gained?}
    @para{
      It would be very tempting to say this ability "emerges" in an LLM. But as we know, real-life LLM training
      is complex and heavily depends on both pretraining and post-training. As noted @link["https://x.com/AlexKrentsel/status/2117376683724660898"]|{by @AlexKrentsel on X}|,
      it seems that only frontier models work. We can reasonably assume that it might be an attempt
      by OpenAI or Anthropic's engineers doing RSI or some other work by fine-tuning models on these
      tasks.
    }
    @para{
      While it is neither sufficient nor necessary, we can also reasonably argue that if somehow
      a model acquired these skills purely from pretraining, models of similar intelligence should have
      similar raw-weight-poking ability. I @link["https://github.com/yikerman/llm-rw-weight-extended-test/blob/master/report/replication.pdf"]{did a quick test}
      on the SOTA models in terms of general intelligence as measured by Artificial Analysis, assuming that the
      evaluation is fair. Interestingly, among frontier models, @it{Kimi K3.1 Pro} is the outlier
      that does the task at a mediocre level while it has roughly the same AA score as @it{Fable 5.1}.
      It is either that it is an emergent ability and Kimi is just a bad model benchmaxxing, or Google,
      OpenAI and Anthropic specifically fine-tuned during their post-training and experimented with
      related ideas while Moonshot, being a Chinese model company, just has different points of emphasis
      and didn't cater for this task.
    }
    @para{
      Note: substantial research work on past literature was assisted by an LLM.
    }
  })

(provide post)
