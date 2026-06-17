#lang racket/base

;;;; bibtex but worse, copy manually in IEEE style, shared among all articles.

(define bib-db
  #hash(
        ;; asus-ux5406-review
        ("asus-ux5406-1" . "https://www.macworld.com/article/2130071/entry-level-m3-macbook-pro-8gb-memory-ram-performance.html")
        ("asus-ux5406-2" . "https://linux.slashdot.org/story/16/10/09/0755231/why-linus-torvalds-prefers-x86-over-arm")
        ("asus-ux5406-3" . "Anyway, I want a fun device, not a dull Apple one :P")
        ("asus-ux5406-4" . "Citation needed.")

        ;; ds-review
        ("ds-review-1" . "Kassandra, \"Review for DEATH STRANDING DIRECTOR'S CUT,\" Steamcommunity.com, Oct. 20, 2025. https://steamcommunity.com/id/KassandraAlmightyEagleBearer/recommended/1850570/ (accessed Nov. 15, 2025).")
        ("ds-review-2" . "T. Ogilvie, \"Death Stranding Review,\" IGN, Nov. 01, 2019. https://www.ign.com/articles/2019/11/01/death-stranding-review (accessed Nov. 15, 2025).")
        ("ds-review-3" . "\"Death Stranding user reviews,\" Metacritic.com, 2019. https://www.metacritic.com/game/death-stranding/user-reviews/?platform=playstation-4 (accessed Nov. 15, 2025).")
        ("ds-review-4" . "T. Sylvester, Designing games : a guide to engineering experiences. Sebastobpol, Calif: O'reilly, 2013.")

        ("vaswaniAttentionAllYou2017" . "Vaswani, A., et al. \"Attention is all you need,\" in Advances in neural information processing systems, vol. 30, 2017.")
        ("radfordImprovingLanguageUnderstanding2018" . "A. Radford, K. Narasimhan, T. Salimans, and I. Sutskever, \"Improving language understanding by generative pre-training,\" OpenAI, San Francisco, CA, USA, Tech. Rep., 2018.")
        ("kolesnikovImageWorth16x162021" . "A. Kolesnikov et al., \"An Image is Worth 16x16 Words: Transformers for Image Recognition at Scale,\" in Proc. Int. Conf. Learn. Represent. (ICLR), 2021.")
        ("geshkovskiMathematicalPerspectiveTransformers2025" . "B. Geshkovski, C. Letrouit, Y. Polyanskiy, and P. Rigollet, “A mathematical perspective on Transformers,” Aug. 21, 2025, arXiv: arXiv:2312.10794. doi: 10.48550/arXiv.2312.10794.")
        ("kosmynaYourBrainChatGPT2025" . "N. Kosmyna et al., “Your Brain on ChatGPT: Accumulation of Cognitive Debt when Using an AI Assistant for Essay Writing Task,” Dec. 31, 2025, arXiv: arXiv:2506.08872. doi: 10.48550/arXiv.2506.08872.")
        ("dawidIntroductionLatentVariable2024" . "A. Dawid and Y. LeCun, “Introduction to latent variable energy-based models: a path toward autonomous machine intelligence,” J. Stat. Mech., vol. 2024, no. 10, p. 104011, Oct. 2024, doi: 10.1088/1742-5468/ad292b.")
        ("shumailovAIModelsCollapse2024" . "I. Shumailov, Z. Shumaylov, Y. Zhao, N. Papernot, R. Anderson, and Y. Gal, “AI models collapse when trained on recursively generated data,” Nature, vol. 631, no. 8022, pp. 755–759, Jul. 2024, doi: 10.1038/s41586-024-07566-y.")
        ))

(provide bib-db)
