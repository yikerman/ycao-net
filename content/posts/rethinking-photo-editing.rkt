#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["Rethinking (FOSS) Photo Editing for Non-Scientists" "2026-11-17"]{
    @heading["problem"]{The Problem}
    @para{
      According to @link["https://eng.aurelienpierre.com/2026/07/who-are-the-darktable-users-in-2022/"]{Aurélien Pierre's survey},
      Darktable mainly reaches a user group of heavily American/European, male, and most importantly
      mainly science people - almost none are professional visual artists and/or do photography for a 
      living.
    }  
    @para{
      And yet it seems that no one cares. With the help of AI there are @link["https://discuss.pixls.us/t/the-whole-host-of-photo-editors-that-have-just-landed/61124"]{much more "yet another dt" projects}
      that are just engineers mindfucking themselves (confession: I also tried) or straight up AI slop,
      and seriously why would one want a photo editor like a coding IDE, just say it is vkdt but much
      less thoroughly thought and designed. As I put in the same thread:
    }
    @blockquote{
      @para{Whenever you present a project, since presenting usually implies that others should have a reason to use it, you need to state its novelties and inspect past literatures. Why would I use yours instead of dt or vkdt? Better UX? Better algorithm? Better implementation? What is novel.}
      @para{Some case studies: ...snipped...}
      @para{Additionally, one thing I really want to quote here is Aurelien’s survey on dt user. dt users are mainly American/European STEM people, and is not reaching the general art public. If I were to build some photo editing software, this design question really need to be answered first.}
    }
    @para{
      Also consider: Darktable deliberately shows all its internal math to give user predictability, 
      given that one fully understand the ISP, which is hard and by previous empirical data what this
      proposal aims to avoid. But copying Adobe Lightroom is also not
      the brightest way. Its opaque controls often couple several operations at once, e.g. increasing
      Exposure also progressively rolls off highlights rather than simply applying a uniform gain.
      This can produce pleasing results, but the photographer must learn the control's additional
      behavior to predict its effects. For example @link["https://www.reddit.com/r/Lightroom/comments/1i1hgqa"]{"What do sliders actually, technically do in Lightroom?"},
      "I had no idea the shadows slider is mask-based, which explains some of the annoyance I have with
      it some of the time.". Or @link["https://www.lightroomqueen.com/community/threads/whats-the-difference-between-the-mask-adjustments-noise-slider-and-the-6-sliders-under-noise-reduction-in-the-global-adjustments-panel.47254/"]{"What's the difference between the mask adjustment's Noise slider and the 6 sliders under Noise Reduction in the global adjustments panel?"}
      showing that because of the complexity, knowledge does not migrate. However it seems that artists
      are living with these just fine? Probably they just keep trying and Adobe engineered such that
      keep trying often get things right? Since "looking correct" is the best kind of correct in art 
      anyway... I still think the following proposal valuable, given the potential to reduce complexity
      and mental burden.
    }
    @para{
      Interestingly, Aurélien's @link["https://github.com/aurelienpierreeng/ansel/wiki#roadmap"]{2023 Ansel roadmap}
      identified a transition to vkdt as the long-term goal, though he
      @link["https://ansel.photos/en/news/complete-pipeline-overhaul/#conclusion"]{reversed that position in 2026}
      for unknown reasons? In my view, vkdt races toward the steep
      learning curve further than Darktable, and the adoption among users is just very poor in contrast to 
      its SOTA algorithms and performance. Consider other node editors: In DaVinci Resolve’s Color 
      page, a corrector node bundles grading controls with an optional selection, so it can represent 
      an intention such as "brighten this face". The same controls work globally or locally, while the
      graph organizes the relationships between corrections. vkdt is exposing too much low-level details
      that hinders the user from actually using it.
    }
    @para{
      With all the case studies, a clearer picture emerges. The problem boils down to
      actually the same problem as software engineering, that is: how to turn an intention into formal
      language? Here are the three criterias I'd like every software to consider:
    }
    @ul{
      @item{The workflow is confined s.t. there is one and only one obvious way to do a thing.}
      @item{Every operation is easily predictable and intuitive.}
      @item{A small core language of operations to minimize learning and mental burden, plus flexible
      composing.}
    }
    @heading["proposal"]{My Proposal}
    @para{
      I propose an editor organized around three explicit stages: @it{restoration}, @it{creative adjustments}, 
      and @it{output rendering}. While the underlying pipeline and algorithm is mostly mature, the 
      design task is to bring them together in a consistent interface that artists can learn without
      having to fully understand or manage the math behind the processing pipeline.
    }
    @para{
      The proposal draws on several existing editors:
    }
    @ul{
      @item{ART's local adjustments.}
      @item{RapidRAW's stable mask inputs.}
      @item{vkdt's computation model.}
      @item{DaVinci Resolve's correction nodes, which bundle grading controls with optional selections.}
    }
    @para{
      The aim is to turn these capabilities into a small vocabulary of operations whose
      behavior remains consistent as they are combined.
    }
    @para{
      The three stages has a precedent in the Academy Color Encoding System @cite["acesSystemOverview"].
      My restoration stage is broader than an ACES input transform: it also establishes the photographic
      starting point that all creative selections refer to, since @it{creative adjustments} will be very
      local-heavy, it would be better to have a stable and meaningful single source of truth when doing
      masking shenanigans.
    }
    @para{
      @bold{The first stage is @it{restoration}: establishing the photographic starting point
      for subsequent creative adjustments.} It includes purely objective capture-related processing such
      as demosaicing and lens correction, alongside subjective decisions such as overall exposure
      and white balance, which is put here for, consider these scenes: (i) a night view (ii) a sunset
      shot. It would be irresponsible to assume a middle grey auto-exposure or grey world auto-wb.
    }
    @para{
      Restoration can be completed in one run because its goal of getting a netual as in perception
      restoration is well-defined and clearly bounded; further artistic changes belong in the creative stage.
      This boundary is enforced because changing that starting point can alter subsequent
      parametric masks, forcing users to revisit edits they have already made.
    }
    @para{
      @bold{Second stage is @it{creative adjustments}.} Inspect what an artist may demand: "make this face brighter".
      It specifies both a change and a region. Creative editing can therefore be organized as a collection
      of adjustments, each describing what to change and where to apply it. Many specialized controls 
      can fit into this generalized model: e.g. traditional "shadow" "midtone" "highlight" tonal settings
      can be generalized into apply the some same change over a parametric mask. This provides the
      small, reusable vocabulary. Also presets and shared selections can make common tasks convenient
      without introducing different underlying mechanisms.
    }
    @para{
      There are, of course, still tons of unresolved details and nuances, and these details would very
      largely determine if the entire thing is actually usable or not. Here are some ideas: 
    }
    @para{
      Mask atom selections could come from lightness
      or color ranges, brushes, shapes, gradients, or AI-assisted tools using text and
      strokes, such as demonstrated by SEEM.@cite["zouSegmentEverythingEverywhere2023"]
      All would produce a soft mask @math{m(x) \in [0,1]}, describing how strongly
      the adjustment applies at pixel @math{x}.
    }
    @para{
      Masks could be combined through union, intersection, subtraction, and inversion.
      For example, "the shadows on this face" combines an object selection with a tonal
      selection. Software can should a couple of examples in the docs for users to draw inspiration on.
      (@link["https://diataxis.fr/"]{Diátaxis is a methodology worth taking on.})
    }
    @para{
      Blending overlapping adjustments is another open and very serious design question, and we should
      demand some algebraic properties to make it predicable, composable and comprehensible. e.g. 
      Commutativity would allow independent intentions to be expressed in either order without changing
      the result. Existing editors offer useful precedents, such as
      Resolve's parallel mixing and ordered layer mixing. Which rules best support this
      model remains open.
    }
    @para{
      @bold{The final stage is @it{output rendering}.} The problem is that even before a delivery medium is chosen,
      let it be sRGB SDR or P3 HDR or some printing, etc. which are mostly trivial to proof to,
      editing already requires an output rendering. The editing display has a finite luminance
      range and color gamut, so the working image must be rendered within those limits. What the photographer
      sees is unfortunately and inevitably always a rendering to this specific display. Since final 
      tonemapping and gamut mapping can affect the visible result of every creative adjustment, my
      proposal is actually fix this stage (or expose settings only for advanced users). DaVinci Resolve's
      color-managed workflow provides a precedent: creative adjustments can be judged through a consistent
      output transform configured independently of the grade.
    }
    @para{
      Note: it's a bit unconvincing for me to write this up - since I am also a science people, and I 
      clearly slipped some PL ideas here... Probably get some artists' eye on this post?
    }
  })

(provide post)
