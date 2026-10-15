#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["Three Years of LLMs: Past and Future" "2026-03-27"]{
    @para{
      OpenAI's ChatGPT was released at the end of 2022. Thanks to overseas phone-number SMS-receiving services, I was able to use it immediately and was amazed by the breakthrough in artificial intelligence. In the blink of an eye, over the past three years, LLMs have undeniably permeated countless households.
    }

    @heading["history"]{A Brief History}
    @para{
      The Transformer model was first proposed by Google in 2017; its core idea is to explicitly express semantic relationships between words through the Self-Attention mechanism@cite["vaswaniAttentionAllYou2017"]. In 2018, OpenAI released the GPT-1 model for the first time, simplifying the architecture to decoder-only autoregressive word prediction@cite["radfordImprovingLanguageUnderstanding2018"]. Since then, the overall architecture of LLMs has been settled, and subsequent models such as GPT-2 and GPT-3 all extended the model size and dataset scale on this basis. Not limited to text, Transformer also performs well in the vision domain@cite["kolesnikovImageWorth16x162021"]. Why large models can @it{emerge} with powerful capabilities remains unknown. In 2021, Anthropic discovered the Induction Heads structure in an extremely simplified model@cite["geshkovskiMathematicalPerspectiveTransformers2025"], but just as biology first discovered red blood cells, we are still far from truly understanding how LLMs work.
    }

    @heading["my-experience"]{My Experience}

    @para{@bold{Simple Text Generation and Search Engines}}
    @para{
      As I recall, the first-generation GPT-3.5 still hallucinated frequently, and its output often required manual fact-checking. Essay tasks that have no serious meaning in themselves and require no strict verification are best handed to GPT, which is arguably a return to its essential function of text continuation.
    }
    @para{
      After GPT gained internet access, its usefulness improved significantly. Compared with traditional search engines, GPT's advantages are: first, it quickly summarizes and distills information. Google embedded AI Overview into its search engine, and the actual experience is indeed more convenient; second, and most importantly, it solves the search engine problem of "not knowing what keywords to search for." For example, if I want to know "how to implement adaptive character animation in 3D games," the LLM will directly tell me that I should search for "Inverse Kinematics." This is difficult for traditional keyword-based search engines to achieve.
    }

    @para{@bold{LLM as Teacher}}
    @para{
      LLMs have enormous potential in teaching. Teaching tasks align closely with LLMs: not only does the model itself possess a large amount of a priori elementary knowledge (repeated in the training set), textbooks can also provide ample context, and most student questions are small-scale and well-defined, requiring only that the LLM re-explain them.
    }
    @para{
      There is no need to say much about ordinary Q&A. After I got Claude Code, I tried feeding Harvard's @link["https://nlp.seas.harvard.edu/annotated-transformer"]{The Annotated Transformer} and Karpathy's @link["https://github.com/karpathy/nanoGPT"]{nanoGPT} into Claude Code, having it compare the two materials and write a tutorial on building GPT from scratch. The @link["https://github.com/yikerman/learn-attn/commit/8864b8dacb70b4219de6efe951064e46b5d6b7b2"]{first version} was fairly complete, but as a textbook it failed to properly handle the reader's reading order and background knowledge. I read and studied it in order, and whenever I found something unclear, I gave explicit instructions on how to rewrite it. In the end, I completed a @link["https://github.com/yikerman/learn-attn/blob/b193e0b5b687d35e9fc825e85b66c75462b899ca/learn/babygpt-tutorial.pdf"]{tutorial I consider to be of decent quality} in two days. This shows that although LLMs still need human guidance, the efficiency improvement is very significant.
    }
    @para{
      If used improperly, LLMs can also cause the expected trouble—if all you know is copy and paste, the knowledge never passes through your brain@cite["kosmynaYourBrainChatGPT2025"]. Such a result makes one ashamed! (Sent from my phone)
    }

    @para{@bold{Multimodality and Agents}}
    @para{
      Although the concept of agents has been hyped to the skies by outsiders, the idea is actually very simple: in the prompt, teach the LLM to invoke external tools (such as reading files, crawling web pages, etc.) in a fixed format, and add deterministic code results to the LLM context. When agents were first introduced, they seemed capable of greatly improving LLM intelligence, but fundamentally it is still about providing correct and sufficient context. It is essentially no different from humans manually providing context (such as pasting a framework's documentation into the dialog box); agents merely automate this process. Programmers are the biggest beneficiaries of agents because they need to interact frequently with code repositories. LLM coding ability has been discussed many times; likewise, without explicit guidance, LLMs like to write code with no design and full of unnecessary redundancy. People with software engineering skills can greatly improve efficiency through LLMs; otherwise, they will most likely go astray.
    }
    @para{
      Multimodal capabilities are very useful, but they are a bit less stable than text. I tried using @link["https://github.com/yikerman/math-notes/blob/90ac740f7d2509aa48f0bf4bef64d6b3ca8cd7e0/CLAUDE.md"]{Claude Code to transform my terrible handwritten math notes into neatly typeset @math{\LaTeX} documents}. The results were quite good; the text almost needed no manual intervention, TikZ diagrams had about a 50% success rate, and most needed manual adjustment. I noticed that some outputs were mathematically correct but inconsistent with my original notes. A reasonable guess is that the LLM only roughly summarized the content of my notes from the images, and for some details it used prior knowledge to guess and fill in.
    }

    @heading["outlook"]{Future Outlook}

    @para{@bold{Is There an AI Bubble?}}
    @para{
      After the LLM boom, two types of products became especially irritating. First, large companies, to please short-sighted shareholders, forcibly implant AI crap into their products, such as the Copilot built into Windows, whose stench is unbearable. Second, there are @link["https://github.com/yikerman/awesome-ai-slop"]{catastrophic products written by small teams or individuals}; even a pig can fly when standing at the wind's mouth—honorable mention to OpenClaw. Both prove that people in finance and journalism are either stupid or malicious.
    }
    @para{
      Not only that, even for AI companies with real expertise (Google, OpenAI, Anthropic, Alibaba, etc.—at least they are doing real work), profitability remains very difficult; OpenAI is still burning through investors' principal to this day. High leverage combined with an overall trend of economic stagnation/downturn is not a good sign. Considering that AI is still useful (unlike the recent Web3 and Meta, which were pure scams), I lean more toward AI being like the dot-com bubble: the waves wash away the sand and leave valuable products, except that when the bubble bursts in the middle, it is unclear whether there will be a soft landing or a hard landing.
    }

    @para{@bold{Do LLMs Really Understand?}}
    @para{
      Current LLM intelligence is already good enough, but it is still essentially different from human intelligence@cite["dawidIntroductionLatentVariable2024"]. From an end-to-end perspective, LLMs are merely probabilistic fitting, and they inevitably produce plausible but false things; context has a @it{very} significant influence on output. Early Prompt Engineering intended to solve this problem, although it was more hype than technique. In part, LLMs take rumors as facts and believe the prompt content unquestioningly. This is rather disastrous in automated workflows: for example, if an internet-connected LLM Agent obtains incorrect information from a web page it finds, it will summarize and present it in a seemingly very credible way. Context also influences in subtler ways. LLMs try their best to imitate the context; the consequence is that if there are hidden bugs or bad architecture in the code, the LLM will continue to follow the erroneous approach, piling up problems until they become intractable.
    }
    @para{
      In short: LLM outputs are strongly correlated with inputs, and much knowledge still needs to be provided a posteriori. It becomes even more important for humans to provide correct context and "taste" for the overall direction.
    }

    @para{@bold{Will Everyone Lose Their Jobs?}}
    @para{
      Based on the above, there is clearly still a considerable gap between LLMs and humans. A more apt analogy is that LLMs are the textile machine of mental labor—replacing trivial mental labor, such as filler text. Naturally, @it{if} there is a global wave of unemployment and economic downturn afterward, LLMs are at most just the fuse: total productivity has increased, so why would living standards decline instead? It must be a distribution problem; there is no need to feel an existential crisis because of LLMs.
    }
    @para{
      An interesting side effect is that LLMs demystify professions such as teachers, scientists, and programmers. (This is not to say these professions do not deserve respect. And there is no need to be discouraged: AI can do it because we have done it repeatedly too many times (in the training data); it is time to take a break.) New tools reveal that @it{most} of the work content of these professions is equally trivial and, with existing technology, easy to automate. Office white-collar workers no longer have any reason to look down on factory blue-collar workers; in essence, everyone is just a beast of burden working hard for a living.
    }

    @para{@bold{Does LLM Have a Bottleneck?}}
    @para{
      My personal guess is that LLMs will encounter a bottleneck, due to the degradation of training data. The internet is increasingly flooded with low-quality content rewritten by LLMs; future LLM training will either refrain from introducing new data or gradually degenerate into distilling previous-generation LLMs. But distillation is only a specialized technique for small models; training a model on degraded data can only yield degraded results@cite["shumailovAIModelsCollapse2024"]. The architectural ceiling of the models themselves is still unclear—after all, humans still do not even understand why Transformer gives rise to so much intelligence.
    }
    @para{
      I also have some miscellaneous thoughts: recently there has been much research attempting to extend LLM context. But if one carefully examines human memory and thought, short-term working memory is not that large; the more important abilities are abstraction and intuition—within an abstraction (such as a mathematical axiom), the lower-level details are transparent to me. I only need to know the relationship between conditions and results, and rely to some extent on intuition to judge when to invoke which abstraction to solve a problem.
    }
  })

(provide post)