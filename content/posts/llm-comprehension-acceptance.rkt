#lang at-exp racket/base

(require ycao-net/lib/markup)

;; more skin in the game => normative agency?????

(define post
  @article["We Dislike LLM Output, not Because of Comprehension" "2026-11-08"]{
    @para{
      While LLMs till now still @link["/posts/ai-se-dilemma.html"]{possess significantly different observable (as in functionalism) output patterns from humans},
      do note that (I) Humans slop and hallucinate from time to time. We have seen countless 
      shitshows emitted by our dearest co-workers; (II) As in the last paragraph of my linked post, @it{"One can definitely argue that 'theoretically LLMs can do whichever thing human is doing'"}.
      This is, of course, debatable but hard and non-trivial, but we cannot deny that LLMs are already
      showing superhuman behaviors and excel in various (honestly mainly math) fields. But there is
      still more to argue for why we should not just hand everything over to LLMs.
    }
    @para{
      We usually argue that we should limit or intervene in the use of LLMs because we need human comprehension.
      But comprehension itself is already quite troublesome. The Chinese Room Argument@cite["searleMindsBrainsPrograms1980"]
      was intended to fight strong functionalism and computationalism, yet it in turn bites itself
      by arguing on top of the dubious Cartesian assumption: that genuine "understanding" consists in
      an isolated internal mental state possessing intrinsic intentionality. Wittgenstein's rule-following and Private Language
      Argument aimed directly at this (and broader Methodological / Semantic Solipsism)@cite["wittgensteinPhilosophicalInvestigations1953"]. As synthesized 
      by SEP (Sec. 1)@cite["candlishPrivateLanguage2019"]: @code{The conclusion is that a language in principle unintelligible to anyone but its originating user is impossible. The reason for this is that such a so-called language would, necessarily, be unintelligible to its supposed originator too, for he would be unable to establish meanings for its putative signs.}
    }
    @para{
      The problem does not lie in comprehension. It lies in normativity. Note that when we argue, we say
      "we @bold{should} not hand everything over to LLMs". Regardless of the PLA, even if we indeed 
      have measurable neurobiological states, or "Qualia", etc., they are @it{normatively inert} facts.
      The Chinese Room mistakes a factual assertion of understanding/comprehension for a normative
      standing. In isolation, neither a biological brain nor a self-attention block possesses semantic normativity@cite["sellarsEmpiricismPhilosophyMind1956"].
    }
    @para{
      But in reality, we do have normative objects, e.g. legal contracts, a program emitting right
      or wrong results. By normative pragmatism@cite["brandomMakingItExplicit1994"], the normativity is gained from 
      external social structures and communal practices - when we say someone "understands" a concept, it is not some pure 
      private mental process, but a social standing: undertaking commitments and liabilities @it{in the game of giving and asking for reasons}.
    }
    @para{
      Reframing understanding as normative accountability reveals why we feel unsettled about 
      the Chinese Room scenario again - and why human slop differs from AI slop. Humans are also black boxes to one another,
      yet they are bound by social structures and existential stakes (@it{skin in the game}). Because artificial tools lack
      such stakes, they can't function as full-fledged normative agents@cite["haugelandHavingThoughtEssays1998"];
      instead, their integration into society relies on their status as @it{auditable instruments} whose
      human operators bear the responsibility. But in modern deep learning, this auditability dissolves into massive 
      pretraining on whatever giant corpora AI companies can acquire, and into mysteriously interacting weights:
      it is @it{epistemic opacity}, that is, the cognitive impossibility for human agents to inspect, 
      decompose, or trace the warrant-generating elements of a computational process@cite["humphreysPhilosophicalNoveltyComputer2009"].
    }
    @para{
      Worth noting that overcoming epistemic opacity is not equivalent to the Cartesian myth of seeking 
      "intrinsic semantics" (and thus falling back into PLA), but rather a @it{pragmatic intelligibility}: the public ability 
      to grasp counterfactual dependencies, diagnose errors, and intervene@cite["deregtUnderstandingScientificUnderstanding2017"].
      In which case, compared to traditional tools, humanity faces a @it{normative disempowerment}: we
      cannot hold the system accountable as a peer, nor can we audit and revise it as a tool, to the
      extent accountability demands@cite["matthiasResponsibilityGapAscribing2004"].
    }
    @para{
      Additionally, consider pharmacology, in which one might argue that medicine has long relied on
      empirically effective drugs. Pharmacology actually faces the same dilemma as in LLM use. 
      A lot of medicine, while not fully understood end-to-end, is still made partially mechanistically
      decomposable (e.g., AstraZeneca turns to the 5R Framework@cite["morganImpactFivedimensionalFramework2018"]),
      on top of which strict clinical regulation and institutional liability shift the @it{skin in the game} onto the pharmaceutical companies and prescribing doctors.
    }
    @para{
      Since we cannot give weights genuine existential stakes (or can we? It would be more troublesome if we actually can), 
      I really hope MechInterp can bring LLMs to a somewhat similar place as pharmacology. It would be a nice pragmatic middle ground.
    }
  })

(provide post)
