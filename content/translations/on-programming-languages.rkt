#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["漫谈编程语言" "2024-05-01" #:lang "zh"]{
    @para{
      在日常软件开发中，我们大多数时候确实只是随手抓起 C++、Java 或 Python 等语言就开始写代码。原因无他：一则这些语言已经非常成熟，坐拥海量第三方库；二则我们对它们早已轻车熟路。尽管如此，新的语言还是层出不穷，比如 Rust、TypeScript 和 Julia，开发者们对它们既欣然接纳，又爱恨交加。但很少有人思考过，@it{我们究竟在创造什么}。
    }

    @heading["by-computation"]{你说的“计算”，是指……}
    @para{
      顾名思义，计算机就是用来计算的，而我们则利用编程语言来指示计算机进行计算。然而，我们其实根本不知道“计算”到底意味着什么。你可能会立刻反驳：“我懂图灵机啊！”确实，
      @link["https://en.wikipedia.org/wiki/Turing_machine"]{图灵机}是一个伟大的计算模型。与它并列的还有
      @link["https://en.wikipedia.org/wiki/Lambda_calculus"]{@math{\lambda}-演算}（也可参阅我的@link["/posts/an-introduction-to-lambda-calculus.html"]{博客文章}）、
      @link["https://en.wikipedia.org/wiki/General_recursive_function"]{@math{\mu}-递归函数}等等。令人惊讶的是，这些直觉上大相径庭的模型在可计算性上居然是等价的，也就是所谓的
      @link["https://en.wikipedia.org/wiki/Turing_completeness"]{图灵等价}。
      我们也构造出了一些@link["https://en.wikipedia.org/wiki/Undecidable_problem"]{不可判定}@link["https://math.stackexchange.com/a/2268351/738593"]{以及}不可计算的问题。
      但图灵机或 @math{\lambda}-演算究竟特殊在哪里？凭什么由这些（本质上完全相同的）计算模型来决定什么是可计算的？回到最初的问题：什么是计算？事实证明，@bold{我们一无所知}。
      @link["https://en.wikipedia.org/wiki/Church%E2%80%93Turing_thesis"]{丘奇-图灵论题（Turing-Church Conjecture）}指出，这些计算模型之所以等价，是因为它们都捕捉到了计算的本质。但计算的本质又是什么？它从未有过形式化的定义。（你不能用“图灵机就代表计算”来定义它，毕竟“@it{计算的本质}”这一概念之所以存在，正是因为我们发现了这么多不谋而合的等价模型，从而暗示“可计算”背后或许隐藏着更深层的含义。）也许还存在某些我们从未设想过的模型，拥有截然不同的计算能力（就“可计算性”而言）；也许有些问题本是可计算的，只是图灵机算不出来。我们完全无从得知。
    }

    @heading["why-care"]{少扯这些形而上学的废话。这跟有什么关系？}
    @para{
      事实是，虽然这些模型在数学上毫无二致，但在思维方式乃至性能表现上却千差万别。函数式编程的拥趸总想把你拉进他们那个晦涩的 @math{\lambda}-演算世界，因为在大多数时候，函数式编程确实更具表现力、更为简洁。但你大可以反唇相讥，嘲笑他们因为误用惰性求值而导致栈溢出（Stack Overflow）是多么滑稽荒谬。现代编程语言不再以图灵机或 @math{\lambda}-演算为基础，而是基于@link["https://en.wikipedia.org/wiki/Random-access_machine"]{随机存取机（RAM-access machines）}，原因很简单：这个模型更接近现实世界中的计算机。（要是 @link["https://en.wikipedia.org/wiki/Lisp_machine"]{LISP 机器}还存在就好了。）虽然图灵机确实可以模拟随机存取机，但这种模拟需要耗费@link["https://cs.stackexchange.com/a/22419/160863"]{多项式时间}，这也正是为什么你不会去@link["https://en.wikipedia.org/wiki/Brainfuck"]{像这样写代码}。
    }

    @heading["jmp-load-store"]{但我也没用 @code{JMP} 和 @code{LOAD}/@code{STORE} 写代码啊！}
    @para{
      确实如此。事实早已证明，我们那可怜的小脑袋瓜（@link["https://en.wikipedia.org/wiki/Lists_of_mathematicians"]{他们}除外）根本应付不来直接用汇编语言写代码，而 Haskell 也绝非仅仅是 @math{\lambda}-演算。为了解放我们那少得可怜的脑容量，抽象应运而生。关于“抽象”，我更愿意将其阐述为“只基于部分信息开展工作”。举个例子，只要输入相同，无论输入什么，@math{f} 总是给出相同的输出——我之所以知道这一点，纯粹是因为 @math{f} 是一个函数。在 C 语言中，我们通过定义函数来隐藏具体的执行过程，从而只需关注其背后的语义。优秀的编程语言能够解放我们的大脑，减少我们需要处理的信息量。归根结底，自始至终都是抽象。
    }

    @heading["creating-languages"]{那么你说的“创造语言”，是指……}
    @para{
      抽象是个好东西，但在软件工程领域，谈及抽象既不涉及底层的形而上学隐喻（谢天谢地），也没有严格的形式化定义。它完全取决于开发者自己想怎么折腾。在 Golang 里你有 @code{interface}，在 C 里你有函数，在 C++ 里你有 @code{class}，而在 Haskell 里，满世界都是函数。面对@link["https://en.wikipedia.org/wiki/Expression_problem"]{表达式问题（Expression problem）}，有人选择纵向分派方法，有人则选择横向分派。类型同样不是原语，而是抽象。万物底层皆是比特与字节，把一个 IEEE 双精度浮点数当成短整型来解读并不会引发什么根本性的灾难，有时我们甚至会故意这么干。类型之所以存在，只是因为大多数时候我们希望保持一致性。凡此种种都表明，抽象在很大程度上受相对主义支配。而这正是 LISP 大显身手的地方。用我的话来说，它通过宏（macro）实现了“对抽象的抽象”。不妨看看下面这段程序：
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
    @para{它定义了一个宏，在编译期会展开为：}
    @code-block["scheme"]|{
(if (not (= x 0))
    (begin
      (display "x is not zero")
      (newline)))
}|
    @para{
      LISP 宏真正了不起的地方在于，你可以在编译期执行任意计算。例如，针对钟爱“类（class）”的 C++ 程序员，LISP 提供了完全用 LISP 自身编写的 CLOS（Common Lisp Object System），而无需陷入你们那种“虽然确实图灵完备但所有东西都乱成一团只有老天爷才看得懂的 C++ 模板胡话”中。
    }

    @heading["tricks"]{少拿我寻开心了}
    @para{
      诚然，根据定义，编译器本来就会在编译期进行计算。但 LISP 所提供的，可以看作是一个设计精良的模块化编译器框架。它模糊了语言本身与语言底层技术之间的界限。我想我们可以愉快地得出结论：创造编程语言，实际上就是在创造契合我们需求的数据与过程抽象新方式。编程语言只会不断演进。它不是一个被证明的既定事实，而是人类创造出的某种艺术。
    }
    @img["/files/20240501/whackygpt.png"]{GPT 偏爱 LISP}
    @para{
      而且事实证明，就连 GPT 也对 LISP 情有独钟，所以你最好也去了解一下。
    }
  })

(provide post)