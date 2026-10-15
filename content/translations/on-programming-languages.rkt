#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["论编程语言" "2024-05-01" #:lang "zh"]{
    @para{
      开发软件时，大多数时候我们确实只是挑 C++、Java、Python 之类，然后开始写代码，理由无非是一来这些语言已经很成熟，库也多，二来我们自己又熟。可新语言仍时不时冒出来，比如 Rust、TypeScript、Julia，开发者一边乐于采用，一边又恨得牙痒。但很少有人想过，@it{我们到底在创造什么}。
    }

    @heading["by-computation"]{所谓计算，你指的是……}
    @para{
      计算机，顾名思义，就是用来计算的。我们借助编程语言来让计算机计算。可我们其实并不知道“计算”到底是什么意思。你也许会反驳：“图灵机我总知道吧！”确实，@link["https://en.wikipedia.org/wiki/Turing_machine"]{图灵机}是很好的计算模型。与它相伴的还有 @link["https://en.wikipedia.org/wiki/Lambda_calculus"]{@math{\lambda}-演算}（也是我的 @link["/posts/an-introduction-to-lambda-calculus.html"]{博客文章}）、@link["https://en.wikipedia.org/wiki/General_recursive_function"]{@math{\mu}-递归函数}等等。出人意料的是，这些直觉上大相径庭的模型，在可计算性上竟然彼此等价，也就是所谓的 @link["https://en.wikipedia.org/wiki/Turing_completeness"]{图灵等价}。我们还构造出了 @link["https://en.wikipedia.org/wiki/Undecidable_problem"]{不可判定} @link["https://math.stackexchange.com/a/2268351/738593"]{且} 不可计算的问题。可图灵机 / @math{\lambda}-演算有什么特别？为什么这些（本质上相同的）计算模型决定了什么是可计算的？回到那个问题：计算是什么？结果发现，@bold{我们不知道}。@link["https://en.wikipedia.org/wiki/Church%E2%80%93Turing_thesis"]{图灵-丘奇猜想}说，这些计算模型之所以相同，是因为它们都抓住了计算的本质。可计算的本质又是什么？它从未被正式定义过。（你不能说“图灵机就意味着计算”就算定义了它；毕竟，“@it{计算的本质}”这个概念之所以存在，是因为我们有这么多碰巧等价的模型，而这或许暗示着可计算性背后有某种更深的含义。）也许还存在我们从未想到过的其他模型，它们的计算能力（就可计算性而言）并不相同。也许有些问题可计算，但不是图灵机可计算。我们就是不知道。
    }

    @heading["why-care"]{形而上学废话够了。我为什么要在乎？}
    @para{
      事实是，这些模型在数学上相同，在思路上却仍有差别，更重要的是，在性能上也有差别。函数式的人总想把你诱进他们那套讨厌的 @math{\lambda}-演算世界，因为多数时候函数式的东西更善于表达、也更简洁。但你可以反击说，他们用错惰性求值，把代码搞到栈溢出，既好笑又荒唐。现代语言不再以图灵机或 @math{\lambda}-演算为基础，而是以 @link["https://en.wikipedia.org/wiki/Random-access_machine"]{随机访问机}为基础，只因为这个模型更接近现实中的计算机。（要是 @link["https://en.wikipedia.org/wiki/Lisp_machine"]{LISP 机器}还在，那该多好。）图灵机固然能模拟随机访问机，但要在 @link["https://cs.stackexchange.com/a/22419/160863"]{多项式时间}内完成，这就让你没法 @link["https://en.wikipedia.org/wiki/Brainfuck"]{这样写代码}。
    }

    @heading["jmp-load-store"]{可我也不用 @code{JMP} 和 @code{LOAD}/@code{STORE} 写代码啊！}
    @para{
      确实。我们可怜的小脑袋（@link["https://en.wikipedia.org/wiki/Lists_of_mathematicians"]{他们的}除外）早就被证明没能力用汇编写代码，而 Haskell 也不只是 @math{\lambda}-演算。抽象就是来解放我们那点小内存的。说到抽象，我想把它解释成“只处理部分信息”。比如，我知道无论输入是什么，只要输入相同，@math{f} 给出的输出就总相同，因为 @math{f} 是个函数。在 C 语言里，我们定义函数，把只围绕底层含义运作的实际过程藏起来。好的语言解放大脑，减少我们要处理的信息。一路往下，都是抽象。
    }

    @heading["creating-languages"]{而所谓创造语言，你指的是……}
    @para{
      抽象很好，但（从软件工程的角度说）抽象并没有什么底层形而上学含义（谢天谢地），也没有正式定义。它只关乎开发者想怎么折腾就怎么折腾。Golang 里有 @code{interface}，C 里有函数，C++ 里有 @code{class}，Haskell 里到处都是函数。面对 @link["https://en.wikipedia.org/wiki/Expression_problem"]{表达式问题}，有人选择纵向分派方法，有人选择横向分派。类型也不是原语，同样是抽象。一切都不过是比特和字节，把 IEEE double 解释成 short 不会造成什么根本麻烦，有时我们还会故意这么干。类型之所以存在，是因为大多数时候我们想保持一致。这些都表明，抽象很大程度上由相对主义支配。LISP 就在这时登场。它——我还是想这样解释——用宏把抽象再抽象。看下面这个程序：
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
    @para{它定义了一个宏，展开为}
    @code-block["scheme"]|{
(if (not (= x 0))
    (begin
      (display "x is not zero")
      (newline)))
}|
    @para{
      在编译期展开。LISP 宏真正了不起的一点，是你能在编译期做任意计算。比如，对喜欢类的 C++ 程序员来说，有 CLOS（Common Lisp 对象系统），它本身就用 LISP 写，不必碰那套确实图灵完备、却全搅在一起、只有上帝才看得懂的 C++ 模板鬼东西。
    }

    @heading["tricks"]{别跟我耍花招}
    @para{
      确实，编译器按其定义，就是在编译期做计算。LISP 提供的东西可以看成一套设计良好、模块化的编译器框架。它模糊了语言与语言背后技术之间的界线。我想我们可以欣然得出结论：创造语言，就是在创造新的方式，用来按我们的需要抽象数据和过程。编程语言只会继续演化。这不是什么被证明的事实，而是人类创造出的某种艺术。
    }
    @img["/files/20240501/whackygpt.png"]{GPT 喜欢 LISP}
    @para{
      而且事实证明，连 GPT 都喜欢 LISP，所以你最好去看一看。
    }
  })

(provide post)