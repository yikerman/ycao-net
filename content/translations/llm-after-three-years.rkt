#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["Three Years of LLMs: Past and Future" "2026-03-27"]{
    @para{
      OpenAI's ChatGPT was released at the end of 2022. Thanks to overseas phone-number verification-code channels, I got to use it right away and was amazed by the breakthrough in artificial intelligence. In the blink of an eye, over the past three years LLMs have incontrovertibly permeated countless households.
    }

    @heading["history"]{A Brief History}
    @para{
      The Transformer model was first proposed by Google in 2017; its core idea is to explicitly express the semantic relations between words through the Self-Attention mechanism@cite["vaswaniAttentionAllYou2017"]. In 2018, OpenAI released the GPT-1 model for the first time, simplifying the architecture to Decoder-only autoregressive word prediction@cite["radfordImprovingLanguageUnderstanding2018"]. Since then, the overall architecture of LLMs has settled, and subsequent GPT-2, GPT-3, etc. all extended model size and dataset scale on this basis. Not limited to text, Transformer also performs very well in the vision domain@cite["kolesnikovImageWorth16x162021"]. Why large models can @it{emerge} with such powerful capabilities remains unknown. In 2021, Anthropic discovered the Induction Heads structure in an extremely simplified model@cite["geshkovskiMathematicalPerspectiveTransformers2025"], but just as when biology first discovered red blood cells, we are still far from truly understanding how LLMs work.
    }

    @heading["my-experience"]{My Experience}

    @para{@bold{Plain Text Generation and Search Engines}}
    @para{
      As I recall, the first-generation GPT-3.5 still hallucinated frequently, and its output often required manual fact-checking. Those writing tasks that are not serious in themselves and do not need strict verification are best handled by GPT—which is arguably a return to its essential function of text continuation.
    }
    @para{
      GPT's usefulness improved markedly after it gained internet access. Compared with traditional search engines, GPT's advantages are: first, it quickly summarizes and distills information. Google embedded AI Overview into its search engine, and the actual experience is indeed more convenient; second, and most importantly, it solves the search engine problem of "not knowing what keywords to search for." For example, if I want to know "how to implement adaptive character animation in 3D games," the LLM will directly tell me that I should search for "Inverse Kinematics." Traditional keyword-based search engines can hardly match this.
    }

    @para{@bold{LLM as Teacher}}
    @para{
      LLMs have enormous potential in teaching. Teaching tasks are highly compatible with LLMs: not only does the model itself possess a large amount of prior elementary knowledge (repeatedly present in the training set), but textbooks can also provide ample context; most student questions are small-scale and well-defined, and the LLM only needs to explain them again.
    }
    @para{
      No need to elaborate on ordinary Q&A. After I got Claude Code, I tried feeding Harvard's @link["https://nlp.seas.harvard.edu/annotated-transformer"]{The Annotated Transformer} and Karpathy's @link["https://github.com/karpathy/nanoGPT"]{nanoGPT} into Claude Code, having it compare the two materials and write a tutorial on building GPT from scratch. The @link["https://github.com/yikerman/learn-attn/commit/8864b8dacb70b4219de6efe951064e46b5d6b7b2"]{first version} was reasonably complete, but as teaching material it did not properly handle the reader's reading order and background knowledge. I read and studied it in order, and whenever I encountered places that did not read smoothly, I gave clear instructions on how to rewrite them. In the end, I completed in two days what I consider a @link["https://github.com/yikerman/learn-attn/blob/b193e0b5b687d35e9fc825e85b66c75462b899ca/learn/babygpt-tutorial.pdf"]{decent-quality tutorial}. It can be seen that although LLMs still need human guidance, the efficiency gain is very significant.
    }
    @para{
      If used improperly, LLMs will also bring expected trouble—if all you know is copy and paste, the knowledge never passes through your brain@cite["kosmynaYourBrainChatGPT2025"]. Such results make one blush with shame! (Sent from my mobile phone)
    }

    @para{@bold{Multimodality and Agents}}
    @para{
      Although the concept of agents has been hyped to the skies by outsiders, the idea is actually very simple: in the prompt, teach the LLM to invoke external tools (such as reading files, scraping web pages, etc.) in a fixed format, and add the results of deterministic code to the LLM context. When agents were first introduced, they seemed able to greatly boost LLM intelligence, but fundamentally this was still just providing correct and sufficient context; it is essentially no different from a human manually providing context (such as pasting a framework's documentation into the chat box). Agents merely automated this process. Programmers are the biggest beneficiaries of agents because they need to interact frequently with code repositories. LLM coding ability has been discussed many times; likewise, without explicit guidance, LLMs like to write code that has no design and is full of unnecessary redundancy. Those with software-engineering skill can greatly improve their efficiency through LLMs; those without it will most likely go astray.
    }
    @para{
      Multimodal capabilities are very useful, but somewhat less stable than text. I tried using @link["https://github.com/yikerman/math-notes/blob/90ac740f7d2509aa48f0bf4bef64d6b3ca8cd7e0/CLAUDE.md"]{Claude Code to convert my terrible handwritten math notes into neatly typeset @math{\LaTeX} documents}. The effect was quite good: the text needed almost no manual intervention, and TikZ drawing had about a 50% success rate, with most requiring manual adjustment. I noticed that some outputs were mathematically correct yet inconsistent with my original notes. A reasonable guess is that the LLM only roughly summarized my note content from the images, and for some details used prior knowledge to guess and fill in.
    }

    @heading["outlook"]{Future Outlook}

    @para{@bold{Is There an AI Bubble?}}
    @para{
      After the LLM explosion, two kinds of products have become especially annoying. First, big companies, to please short-sighted shareholders, forcibly implant AI crap into their products, such as the built-in Copilot in Windows—it stinks to high heaven. Second are some @link["https://github.com/yikerman/awesome-ai-slop"]{disaster-level products written by small teams or individuals}; even a pig can fly if it stands in the right wind, with an honorable mention for OpenClaw. Both prove that people in finance and journalism are either stupid or malicious.
    }
    @para{
      Moreover, even for AI companies with real expertise (Google, OpenAI, Anthropic, Alibaba, etc.—at least they are doing real work), profitability remains very difficult; OpenAI to this day is still burning investors' principal. High leverage plus the overall trend of economic stagnation/downturn is not a good sign. Considering that AI is still useful (unlike the pure scams of Web3 and Meta a while ago), I lean toward AI being like the internet bubble: the great waves wash away the sand and valuable products remain—it is just unclear whether the bubble's bursting in between will be a soft landing or a hard landing.
    }

    @para{@bold{Does the LLM Really Understand?}}
    @para{
      Current LLM intelligence is already good enough, but it is still essentially different from human intelligence@cite["dawidIntroductionLatentVariable2024"]. From an end-to-end perspective, LLMs are merely probabilistic fitting, and inevitably give plausible-sounding but wrong things; the influence of context on output is @it{very} significant. Early prompt engineering intended to solve this problem, although it was more gimmick than technique. In part, LLMs take rumors for facts and are utterly convinced of the prompt content. This is rather disastrous in automated workflows: for example, if an internet-connected LLM agent obtains erroneous information from a webpage it searches, it will summarize and present it in a way that looks very credible. Context also has subtler ways of influencing. LLMs try their best to imitate the context; the consequence is that if there are hidden bugs or poor architecture in the code, the LLM will continue to follow the wrong approach, piling up problems until they become intractable.
    }
    @para{
      In short: LLM output is strongly correlated with input, and much knowledge still needs to be supplied a posteriori. It becomes even more important for humans to provide the correct context and a sense of "taste" for the big picture.
    }

    @para{@bold{Will Everyone Lose Their Jobs?}}
    @para{
      Based on the above, there is still clearly quite a gap between LLMs and humans. A more appropriate analogy is that LLMs are the textile machines of mental labor—replacing trivial mental labor, such as writing filler text. Naturally, @it{if} there is a global wave of unemployment and economic downturn afterward, LLMs are at most just the fuse: total productivity has increased, so why would living standards decline instead? That must be a distribution problem; there is no need at all to feel an existential crisis because of LLMs.
    }
    @para{
      An interesting side effect is that LLMs have demystified professions such as teachers, scientists, and programmers. (This is not to say these professions do not deserve respect. And no need to be depressed: AI can do it because we have done it over and over too many times (in the training data); it is time for a break.) The new tools have revealed that @it{most} of the work content of these professions is likewise trivial and, under existing technology, easy to automate. Office white-collar workers no longer have any reason to look down on factory blue-collar workers; in essence, everyone is just a beast of burden working hard for a living.
    }

    @para{@bold{Does LLM Have a Bottleneck?}}
    @para{
      My personal guess is that LLMs will hit a bottleneck, due to the degradation of training data. The internet is increasingly filled with low-quality content rewritten by LLMs; future LLM training will either introduce no new data or gradually degenerate into distilling previous generations of LLMs. But distillation is only a specialization technique for small models; training a model on degraded data can only yield degraded results@cite["shumailovAIModelsCollapse2024"]. The architectural ceiling of the models themselves is still unclear—after all, humans do not even understand why Transformers give rise to so much intelligence.
    }
    @para{
      I also have some miscellaneous thoughts: recently there has been a lot of research trying to extend LLM context. But if one carefully examines human memory and thought, short-term working memory is not that large; the more important abilities are abstraction and intuition—within an abstraction (such as a mathematical axiom), the lower-level details are transparent to me. I only need to know the relationship between conditions and results, and to some extent rely on intuition to judge when to invoke which abstraction to solve a problem.
    }
  })

(provide post)