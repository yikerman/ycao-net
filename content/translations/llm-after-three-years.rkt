#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["Three Years of LLMs: Past and Future" "2026-03-27"]{
    @para{
      OpenAI released ChatGPT in late 2022. Thanks to a virtual overseas phone number service, I got my hands on it right away and marveled at this breakthrough in artificial intelligence. In the blink of an eye, over the past three years, LLMs have undeniably woven themselves into the fabric of everyday life.
    }

    @heading["history"]{A Brief History}
    @para{
      The Transformer architecture was first proposed by Google in 2017, built around the core idea of explicitly modeling semantic relationships between words through a Self-Attention mechanism@cite["vaswaniAttentionAllYou2017"]. In 2018, OpenAI released the first GPT-1 model, simplifying the architecture into a decoder-only framework for autoregressive token prediction@cite["radfordImprovingLanguageUnderstanding2018"]. Since then, the overarching architecture of LLMs has largely settled, with subsequent models like GPT-2 and GPT-3 mainly scaling up parameter counts and dataset sizes on this foundation. Beyond text, Transformers have also excelled in computer vision@cite["kolesnikovImageWorth16x162021"]. Why large models exhibit @it{emergent} capabilities remains an open question. In 2021, Anthropic discovered Induction Heads in an extremely simplified model@cite["geshkovskiMathematicalPerspectiveTransformers2025"], yet much like when biologists first discovered red blood cells, we are still far from truly understanding how LLMs work under the hood.
    }

    @heading["my-experience"]{My Experience}

    @para{@bold{Vanilla Text Generation and Search Engines}}
    @para{
      As I recall, the original GPT-3.5 was prone to frequent hallucinations, and its outputs often required manual fact-checking. Unimportant writing tasks that carried little weight and required no rigorous verification were best handed off to GPT—which, in a way, was a return to its fundamental nature as a text completion engine.
    }
    @para{
      Once connected to the internet, GPT's practical utility improved dramatically. Compared to traditional search engines, GPT offers two distinct advantages. First, it rapidly summarizes and distills information; Google has since embedded AI Overviews into its search results, which has indeed made things much more convenient in practice. Second—and most importantly—it solves the classic search engine dilemma of "not knowing which keywords to search for." For example, if I want to know "how adaptive character animations are implemented in 3D games," an LLM will directly tell me that the term I should be looking for is "Inverse Kinematics." This is something traditional keyword-based search engines struggle to match.
    }

    @para{@bold{The LLM as a Teacher}}
    @para{
      LLMs hold immense potential in education. Teaching tasks align remarkably well with the strengths of LLMs: not only do the models possess vast prior foundational knowledge (repeated countless times in their training sets), but textbooks also provide ample context, and student questions are mostly small-scale and well-defined, requiring the LLM merely to rephrase or re-explain concepts.
    }
    @para{
      Routine Q&A goes without saying. After getting access to Claude Code, I tried feeding it Harvard's @link["https://nlp.seas.harvard.edu/annotated-transformer"]{The Annotated Transformer} alongside Karpathy's @link["https://github.com/karpathy/nanoGPT"]{nanoGPT}, instructing it to cross-reference the two materials and write a tutorial on building GPT from scratch. The @link["https://github.com/yikerman/learn-attn/commit/8864b8dacb70b4219de6efe951064e46b5d6b7b2"]{first draft} was reasonably complete, but as teaching material, it failed to properly account for the reader's progression and background knowledge. I read and studied it sequentially, giving explicit instructions on how to rewrite whenever I hit a clunky section, and ultimately produced what I consider a @link["https://github.com/yikerman/learn-attn/blob/b193e0b5b687d35e9fc825e85b66c75462b899ca/learn/babygpt-tutorial.pdf"]{solid tutorial} in just two days. Clearly, while LLMs still require human guidance, the boost in efficiency is remarkable.
    }
    @para{
      When misused, however, LLMs bring predictable trouble—if all you do is copy and paste, the knowledge bypasses your brain entirely@cite["kosmynaYourBrainChatGPT2025"]. Such results are truly humbling! (Sent from my phone)
    }

    @para{@bold{Multimodality and Agents}}
    @para{
      Despite all the grandiose hype surrounding the concept of "Agents," the underlying idea is actually quite simple: instruct the LLM within the prompt to invoke external tools (such as reading files or scraping web pages) using a fixed format, and feed the deterministic execution results back into the LLM's context. When Agents were first introduced, they appeared to drastically boost LLM intelligence. At their core, however, they simply supply accurate and sufficient context—fundamentally no different from a human manually pasting a framework's documentation into a chat box. Agents merely automate this workflow. Programmers are the biggest beneficiaries of Agents, given their constant need to interact with codebases. The coding capabilities of LLMs have been discussed extensively; likewise, without explicit guidance, LLMs tend to write poorly designed code riddled with unnecessary redundancy. Those with solid software engineering skills can leverage LLMs to massively boost their productivity, whereas those without are likely to be led astray.
    }
    @para{
      Multimodal capabilities are very useful, though slightly less reliable than text processing. I tried using @link["https://github.com/yikerman/math-notes/blob/90ac740f7d2509aa48f0bf4bef64d6b3ca8cd7e0/CLAUDE.md"]{Claude Code to convert my messy handwritten math notes into neatly typeset @math{\LaTeX} documents}. The results were quite impressive: the text required almost no manual intervention, while TikZ diagrams had roughly a 50% success rate, with most needing human tweaking. I noticed that some outputs were mathematically sound yet diverged from my original notes. It is reasonable to surmise that the LLM only extracted a rough outline from the images of my notes, relying on its prior knowledge to guess and fill in the finer details.
    }

    @heading["outlook"]{Future Outlook}

    @para{@bold{Is AI in a Bubble?}}
    @para{
      Since the LLM explosion, two types of products have become particularly obnoxious. First, tech giants awkwardly shoehorning AI slop into existing products just to appease short-sighted shareholders—like the built-in Copilot in Windows, which is an absolute eyesore. Second, @link["https://github.com/yikerman/awesome-ai-slop"]{disastrous products slapped together by small teams or individuals}; when the hype wind blows hard enough, even pigs can fly, with an honorable mention going to OpenClaw. Both phenomena prove that people in finance and journalism are either stupid or malicious.
    }
    @para{
      Furthermore, even for genuinely capable AI companies (Google, OpenAI, Anthropic, Alibaba, etc., which are at least doing real work), turning a profit remains an uphill battle; OpenAI is still burning through investor capital to this day. High leverage coupled with broader economic stagnation or downturn is hardly a good omen. Considering that AI is genuinely useful (unlike the pure scams of Web3 and the Metaverse a while back), I am inclined to believe AI will play out much like the dot-com bubble: when the tide goes out, valuable products will remain, though it is anyone's guess whether the bursting of the bubble will result in a soft or hard landing.
    }

    @para{@bold{Do LLMs Truly Understand?}}
    @para{
      Current LLM intelligence is already plenty capable, yet it remains fundamentally distinct from human intelligence@cite["dawidIntroductionLatentVariable2024"]. Viewed end-to-end, LLMs are merely performing probabilistic curve-fitting; they inevitably produce specious outputs, and the context exerts a @it{profound} influence on the result. Early "Prompt Engineering" sought to address this very issue, even if it was more gimmick than actual engineering. On one hand, LLMs are gullible, taking whatever is in the prompt as gospel. This can be disastrous in automated pipelines—for instance, if a web-browsing LLM Agent retrieves misinformation from a search result, it will summarize and present it in a thoroughly convincing manner. Context also exerts its influence in subtler ways. Because an LLM tries its best to mimic its context, if an existing codebase harbors hidden bugs or poor architecture, the LLM will faithfully perpetuate those anti-patterns, compounding the technical debt until it becomes intractable.
    }
    @para{
      In short: an LLM's output is strongly correlated with its input, and a great deal of knowledge still needs to be supplied @it{a posteriori}. Human judgment—both in providing the right context and exercising good "taste" regarding the overarching direction—has become more vital than ever.
    }

    @para{@bold{Will Everyone Lose Their Jobs?}}
    @para{
      As discussed above, a significant gap clearly remains between LLMs and humans. A more fitting analogy is that the LLM is the power loom of intellectual labor—replacing trivial mental work, such as churning out boilerplate text. Naturally, @it{if} a global wave of unemployment and economic downturn does occur down the line, LLMs will at best be the spark rather than the root cause: if overall productivity has risen, why would living standards fall? That is inevitably a problem of wealth distribution, so there is really no need to have an existential crisis over LLMs.
    }
    @para{
      An interesting side effect is that LLMs have demystified professions like teachers, scientists, and programmers. (Which is not to say these professions don't deserve respect. Nor is there any need for despair: AI can do these things only because we have done them over and over again in the training data—perhaps it's time we took a breather.) These new tools have exposed that @it{much} of the day-to-day work in these fields is equally trivial and readily automatable with existing technology. White-collar office workers no longer have any grounds to look down on blue-collar factory workers; at the end of the day, we are all just beasts of burden grinding away for a living.
    }

    @para{@bold{Will LLMs Hit a Wall?}}
    @para{
      My personal guess is that LLMs will hit a bottleneck, driven by the degradation of training data. As the internet becomes increasingly flooded with low-quality, LLM-regurgitated content, future LLM training will either have to avoid ingesting new web data or gradually devolve into distilling outputs from predecessor models. Yet distillation is merely a specialized technique meant for smaller models; training models on degraded, synthetic data will only yield degraded results@cite["shumailovAIModelsCollapse2024"]. The theoretical ceiling of the architecture itself remains unclear—after all, humanity still doesn't fully understand why Transformers exhibit such emergent intelligence in the first place.
    }
    @para{
      A final stray thought: lately, there has been a lot of research aimed at expanding the context window of LLMs. Yet if we closely examine human memory and cognition, our short-term working memory isn't actually that large. What matters far more are our capacities for abstraction and intuition—within an abstraction (such as a mathematical axiom), the underlying low-level details remain transparent to me; I only need to grasp the relationship between premises and conclusions, relying to some extent on intuition to judge when and which abstraction to invoke to solve a problem.
    }
  })

(provide post)