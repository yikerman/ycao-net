#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["On Programming Languages" "2024-05-01"]{
    @para{
      While it is true that most of the time while developing software, we just
      pick either C++, Java, Python, etc. and start coding simply because A these
      languages are already well-established and have a lot of libraries and B we
      are already familiar with them. Yet new languages still emerge from time to
      time, such as Rust, TypeScript, and Julia, which are happily adopted (and
      hated) by developers. But few have thought about @it{what are we actually
      creating}.
    }

    @heading["by-computation"]{By computation, you mean...}
    @para{
      Computers, by definition, compute. And we utilize programming languages to
      instruct the computer to compute. However, we actually have no idea what
      computing means. You may simply argue against this stating that "Well I
      know Turing Machine!" Indeed,
      @link["https://en.wikipedia.org/wiki/Turing_machine"]{Turing machine} is a
      great computational model. Along with it also comes the
      @link["https://en.wikipedia.org/wiki/Lambda_calculus"]{@math{\lambda}-calculus}
      (also my @link["/posts/an-introduction-to-lambda-calculus.html"]{blog post}),
      @link["https://en.wikipedia.org/wiki/General_recursive_function"]{@math{\mu}-recursive functions},
      etc. Surprisingly, these intuitively vastly different models are actually
      equivalent in terms of computability, which is known as
      @link["https://en.wikipedia.org/wiki/Turing_completeness"]{Turing equivalent}.
      We also have created problems that are
      @link["https://en.wikipedia.org/wiki/Undecidable_problem"]{undecidable}
      @link["https://math.stackexchange.com/a/2268351/738593"]{and} uncomputable.
      But what makes Turing machine / @math{\lambda}-calculus special? Why do
      these (fundamentally identical) computational models decide what is
      computable? Back to the question, what is computation? It turns out that
      @bold{we have no idea}. The
      @link["https://en.wikipedia.org/wiki/Church%E2%80%93Turing_thesis"]{Turing-Church Conjecture}
      states that these computational models are identical because they all
      capture the essence of computation. But what is the essence of computation?
      It's never formally defined. (You can't define it by stating that Turing
      machine means computation, after all the concept "@it{essence of
      computation}" is there because we have so many coincidentally equivalent
      models and that may imply some deeper meaning of being computable.) Maybe
      there exist some other models that have different computational power (in
      terms of computationability) that we have never thought of. Maybe some
      problems are computable but not by Turing machine. We simply don't know.
    }

    @heading["why-care"]{That's enough metaphysics nonsense. Why would I care?}
    @para{
      The fact is while these models are the same in terms of Math, they still
      differ in terms of mind and what's more, performance. Functional guys
      trying to lure you into their nasty world of @math{\lambda}-calculus because
      most of the time functional stuff is more expressive and concise. But you
      may fight back saying their code going Stack Overflow because of using lazy
      evaluation wrong is hilarious and absurd. Modern languages no longer base
      themselves on Turing machine or @math{\lambda}-calculus but
      @link["https://en.wikipedia.org/wiki/Random-access_machine"]{RAM-access machines}
      simply because the model approximates real-world computers. (It would be
      great if @link["https://en.wikipedia.org/wiki/Lisp_machine"]{LISP machines}
      still exist.) While it holds that a Turing machine emulates a RAM-access
      machine, it does so in
      @link["https://cs.stackexchange.com/a/22419/160863"]{polynomial time}, which
      is stopping you from
      @link["https://en.wikipedia.org/wiki/Brainfuck"]{coding like this}.
    }

    @heading["jmp-load-store"]{But I don't code using @code{JMP} and @code{LOAD}/@code{STORE} either!}
    @para{
      Indeed. Our poor little brains (except
      @link["https://en.wikipedia.org/wiki/Lists_of_mathematicians"]{theirs}) have
      already been proven to not have the ability to code in assembly, and
      Haskell isn't just about @math{\lambda}-calculus. Abstraction comes into
      place to free our tiny RAM. By abstraction, I would like to elaborate on it
      as "working on partial information". For example, I know that whichever
      input @math{f} always gives the same output if the input is the same simply
      because @math{f} is a function. In the C language, we define functions to
      hide away actual procedures working solely on the underlying meaning. Good
      languages free our brains and less-en the information we are working on.
      It's abstraction all the way down.
    }

    @heading["creating-languages"]{And by creating languages you mean...}
    @para{
      Abstractions are great, but (in terms of software engineering) when it
      comes to abstraction there are no underlying metaphysics implications (thank
      god) nor formal definitions. It's about doing whatever the cuss a developer
      would like to. In Golang you have @code{interface}s, in C you have
      functions, in C++ you have @code{class}es, in Haskell, you have functions
      all over the place. For
      @link["https://en.wikipedia.org/wiki/Expression_problem"]{the expression problem},
      some choose to dispatch methods vertically while some do it horizontally.
      Types are not primitives but abstractions too. Everything is just bits and
      bytes, interpreting an IEEE double as a short won't cause any fundamental
      troubles, and sometimes we do it intentionally. Types present because most
      of the time we want to keep it consistent. All of these show that
      abstraction is largely ruled by relativism. That's where LISP comes into
      place. It, again I'd like to elaborate as, abstracts abstraction by using
      macros. Consider the following program:
    }
    @code-block["scheme"]|{
(define-syntax unless
  (syntax-rules ()
    ((_ condition body ...)
     (if (not condition) (begin body ...)))))

(unless (= x 0)
  (display "x is not zero")
  (newline))
}|
    @para{It defines a macro that expands to}
    @code-block["scheme"]|{
(if (not (= x 0))
    (begin
      (display "x is not zero")
      (newline)))
}|
    @para{
      at compile time. One thing that is truly great about LISP macros is that
      you can do arbitrary computation at compile time. For example, for C++ guys
      who love classes, there exists CLOS (Common Lisp Object System) that is
      written in LISP itself, without going into your
      indeed-turing-complete-but-all-cluttered-together-only-god-can-understand-CPP-templating-nonsense.
    }

    @heading["tricks"]{Don't you play tricks on me}
    @para{
      Indeed, a compiler, by its definition, does calculations at compile time.
      What LISP provides can be seen as a well-designed, modular compiler
      framework. It blurs the line between a language and the tech behind a
      language. I think we can happily conclude that by creating languages, we are
      creating new ways of abstracting data and procedures that fit our needs. PLs
      will just keep evolving. It's not a proven fact, it's some kind of art
      created by humans.
    }
    @img["/files/20240501/whackygpt.png"]{GPT fond of LISP}
    @para{
      And it also turns out that even GPT is fond of LISP, so you'd better check
      it out.
    }
  })

(provide post)
