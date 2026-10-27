#lang racket/base

;;;; bibtex but worse, copy manually in IEEE style, shared among all articles.

(define bib-db
  #hash(
        ;;; legacy non-standarized

        ;; asus-ux5406-review
        ("asus-ux5406-1" . "https://www.macworld.com/article/2130071/entry-level-m3-macbook-pro-8gb-memory-ram-performance.html")
        ("asus-ux5406-2" . "https://linux.slashdot.org/story/16/10/09/0755231/why-linus-torvalds-prefers-x86-over-arm")
        ("asus-ux5406-3" . "Anyway, I want a fun device, not a dull Apple one :P")
        ("asus-ux5406-4" . "Citation needed.")

        ;; ds-review
        ("ds-review-1" . "Kassandra, \"Review for DEATH STRANDING DIRECTOR'S CUT,\" Steamcommunity.com, Oct. 20, 2025. https://steamcommunity.com/id/KassandraAlmightyEagleBearer/recommended/1850570/ (accessed Nov. 15, 2025).")
        ("ds-review-2" . "T. Ogilvie, \"Death Stranding Review,\" IGN, Nov. 01, 2019. https://www.ign.com/articles/2019/11/01/death-stranding-review (accessed Nov. 15, 2025).")
        ("ds-review-3" . "\"Death Stranding user reviews,\" Metacritic.com, 2019. https://www.metacritic.com/game/death-stranding/user-reviews/?platform=playstation-4 (accessed Nov. 15, 2025).")
        ("sylvesterDesigningGamesGuide2013" . "T. Sylvester, Designing games : a guide to engineering experiences. Sebastobpol, Calif: O'reilly, 2013.")

        ;;; by citation key and IEEE
        ("vaswaniAttentionAllYou2017" . "Vaswani, A., et al. \"Attention is all you need,\" in Advances in neural information processing systems, vol. 30, 2017.")
        ("radfordImprovingLanguageUnderstanding2018" . "A. Radford, K. Narasimhan, T. Salimans, and I. Sutskever, \"Improving language understanding by generative pre-training,\" OpenAI, San Francisco, CA, USA, Tech. Rep., 2018.")
        ("kolesnikovImageWorth16x162021" . "A. Kolesnikov et al., \"An Image is Worth 16x16 Words: Transformers for Image Recognition at Scale,\" in Proc. Int. Conf. Learn. Represent. (ICLR), 2021.")
        ("geshkovskiMathematicalPerspectiveTransformers2025" . "B. Geshkovski, C. Letrouit, Y. Polyanskiy, and P. Rigollet, “A mathematical perspective on Transformers,” Aug. 21, 2025, arXiv: arXiv:2312.10794. doi: 10.48550/arXiv.2312.10794.")
        ("kosmynaYourBrainChatGPT2025" . "N. Kosmyna et al., “Your Brain on ChatGPT: Accumulation of Cognitive Debt when Using an AI Assistant for Essay Writing Task,” Dec. 31, 2025, arXiv: arXiv:2506.08872. doi: 10.48550/arXiv.2506.08872.")
        ("dawidIntroductionLatentVariable2024" . "A. Dawid and Y. LeCun, “Introduction to latent variable energy-based models: a path toward autonomous machine intelligence,” J. Stat. Mech., vol. 2024, no. 10, p. 104011, Oct. 2024, doi: 10.1088/1742-5468/ad292b.")
        ("shumailovAIModelsCollapse2024" . "I. Shumailov, Z. Shumaylov, Y. Zhao, N. Papernot, R. Anderson, and Y. Gal, “AI models collapse when trained on recursively generated data,” Nature, vol. 631, no. 8022, pp. 755–759, Jul. 2024, doi: 10.1038/s41586-024-07566-y.")
        ("budneyWhatsMathematician2010" . "W. Thurston, “What’s a mathematician to do?,” MathOverflow. Accessed: May 11, 2026. [Online]. Available: https://mathoverflow.net/q/43690")
        ("slameckaGenerationEffect1978" . "N. J. Slamecka and P. Graf, “The generation effect: Delineation of a phenomenon,” Journal of Experimental Psychology: Human Learning and Memory, vol. 4, no. 6, pp. 592–604, 1978, doi: 10.1037/0278-7393.4.6.592.")
        ("taoThereMoreMathematics2026" . "T. Tao, “There’s more to mathematics than rigour and proofs.” Accessed: Jun. 17, 2026. [Online]. Available: https://terrytao.wordpress.com/career-advice/theres-more-to-mathematics-than-rigour-and-proofs/")
        ("michaelLateChunking2025" . "Günther, Michael, Isabelle Mohr, Daniel James Williams, Bo Wang, and Han Xiao. “Late Chunking: Contextual Chunk Embeddings Using Long-Context Embedding Models.” arXiv:2409.04701. Preprint, arXiv, July 7, 2025. https://doi.org/10.48550/arXiv.2409.04701.")
        ("anthropicContextualRetrieval2026" . "Anthropic. “Contextual Retrieval in AI Systems.” Accessed August 3, 2026. https://www.anthropic.com/engineering/contextual-retrieval.")
        ("cormackReciprocalRankFusion2009" . "Cormack, Gordon V., Charles L. A. Clarke, and Stefan Buettcher. “Reciprocal Rank Fusion Outperforms Condorcet and Individual Rank Learning Methods.” Proceedings of the 32nd International ACM SIGIR Conference on Research and Development in Information Retrieval (New York, NY, USA), SIGIR ’09, July 19, 2009, 758–59. https://doi.org/10.1145/1571941.1572114.")
        ("robertsonProbabilisticRelevance2009" . "Robertson, Stephen, and Hugo Zaragoza. “The Probabilistic Relevance Framework: BM25 and Beyond.” Foundations and Trends in Information Retrieval 3, no. 4 (2009): 333–89. https://doi.org/10.1561/1500000019.")
        ("russellMysticismLogicOther1917" . "B. Russell, Mysticism and logic, and other essays. London : G. Allen & Unwin, 1917. Accessed: Oct. 16, 2026. [Online]. Available: http://archive.org/details/mysticismlogicot00russ")
        ("dijkstraFoolishnessNaturalLanguage1978" . "E. W. Dijkstra, “On the Foolishness of ‘Natural Language Programming,’” in Program Construction, International Summer School, Berlin, Heidelberg: Springer-Verlag, Jul. 1978, pp. 51–53.")
        ("stanfordhai2026ConferencePhysics2026" . "Stanford HAI. 2026 Conference on Physics and AI: Jascha Sohl-Dickstein. (Jun. 30, 2026). Accessed: Oct. 25, 2026. [Online Video]. Available: https://www.youtube.com/watch?v=3LZN2UUxDos")
        ("wuTacticZeroLearningProve2021" . "M. Wu, M. Norrish, C. Walder, and A. Dezfouli, “TacticZero: Learning to prove theorems from scratch with deep reinforcement learning,” in Adv. Neural Inf. Process. Syst., vol. 34, 2021, pp. 9330–9342.")
        ("hubertOlympiadlevelFormalMathematical2026" . "T. Hubert et al., “Olympiad-level formal mathematical reasoning with reinforcement learning,” Nature, vol. 651, no. 8106, pp. 607–613, Mar. 2026, doi: 10.1038/s41586-025-09833-y.")
        ("thompsonReflectionsTrustingTrust1984" . "K. Thompson, “Reflections on trusting trust,” Commun. ACM, vol. 27, no. 8, pp. 761–763, Aug. 1984, doi: 10.1145/358198.358210.")
        ("chiangTheEvolutionHumanScience2016" . "T. Chiang, “The evolution of human science,” in Stories of Your Life and Others. New York, NY, USA: Vintage Books, 2016, pp. 201–204.")
        ("dunbarSocialBrainHypothesis1998" . "R. I. M. Dunbar, “The social brain hypothesis,” Evol. Anthropol., vol. 6, no. 5, pp. 178–190, 1998, doi: 10.1002/(SICI)1520-6505(1998)6:5<178::AID-EVAN5>3.0.CO;2-8.")
        ("dehaeneCulturalRecyclingCortical2007" . "S. Dehaene and L. Cohen, “Cultural recycling of cortical maps,” Neuron, vol. 56, no. 2, pp. 384–398, Oct. 2007, doi: 10.1016/j.neuron.2007.10.004.")
        ("allenEngelsPauseTechnical2009" . "R. C. Allen, “Engels’ pause: Technical change, capital accumulation, and inequality in the British industrial revolution,” Explor. Econ. Hist., vol. 46, no. 4, pp. 418–435, Oct. 2009, doi: 10.1016/j.eeh.2009.04.004.")
        ))

(provide bib-db)
