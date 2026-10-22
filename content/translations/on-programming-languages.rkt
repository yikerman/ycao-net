#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["论编程语言" "2024-05-01" #:lang "zh"]{
    @para{
      诚然，开发软件时，我们大多数时候只是挑 C++、Java、Python 等语言然后开始写代码，原因无非是：一是这些语言已经成熟、库很多，二是我们已经熟悉它们。然而，新语言仍不时出现，比如 Rust、TypeScript 和 Julia，开发者乐于采用（也乐于讨厌）它们。但很少有人想过 @it{我们究竟在创造什么}。
    }

    @heading["by-computation"]{所谓计算，你指的是……}
    @para{
      计算机按定义就是做计算的。我们用编程语言指示计算机去计算。可是，我们其实并不知道计算意味着什么。你也许可以反驳说：“可我知道图灵机！”的确，@link["https://en.wikipedia.org/wiki/Turing_machine"]{图灵机}是很棒的计算模型。与它相伴的还有 @link["https://en.wikipedia.org/wiki/Lambda_calculus"]{@math{\lambda}-演算}（也是我的 @link["/posts/an-introduction-to-lambda-calculus.html"]{博客文章}）、@link["https://en.wikipedia.org/wiki/General_recursive_function"]{@math{\mu}-递归函数}等。出人意料的是，这些直觉上大相径庭的模型在可计算性上竟然等价，这被称为 @link["https://en.wikipedia.org/wiki/Turing_completeness"]{图灵等价}。我们还构造出了@link["https://en.wikipedia.org/wiki/Undecidable_problem"]{不可判定}@link["https://math.stackexchange.com/a/2268351/738593"]{且}不可计算的问题。可为什么图灵机 / @math{\lambda}-演算如此特别？为什么这些（本质上相同的）计算模型决定了什么是可计算的？回到那个问题：计算是什么？结果却是 @bold{我们根本不知道}。@link["https://en.wikipedia.org/wiki/Church%E2%80%93Turing_thesis"]{图灵-丘奇猜想}称，这些计算模型之所以相同，是因为它们都抓住了计算的本质。但计算的本质是什么？从来没有正式定义。（你不能说图灵机就意味着计算，以此下定义；毕竟“计算的本质”这个概念之所以存在，是因为我们有这么多恰好等价的模型，而这可能暗示着可计算性有某种更深层的含义。）也许还存在我们从未想到过的其他模型，其计算能力（就可计算性而言）有所不同。也许有些问题可计算，但不是由图灵机计算。我们就是不知道。
    }

    @heading["why-care"]{玄学废话够了。这跟我有什么关系？}
    @para{
      事实是，这些模型在数学上虽然相同，在思考方式上仍有差异，更重要的是性能也不同。函数式拥趸总想把你拐进他们那套讨厌的 @math{\lambda}-演算世界，因为大多数时候函数式的东西更有表达力、更简洁。但你可以回敬说，他们因为用错惰性求值而把代码写爆栈，既滑稽又荒唐。现代语言不再以图灵机或 @math{\lambda}-演算为基础，而是以 @link["https://en.wikipedia.org/wiki/Random-access_machine"]{RAM 访问机}为基础，纯粹是因为这个模型更接近现实中的计算机。（要是 @link["https://en.wikipedia.org/wiki/Lisp_machine"]{LISP 机}还在就好了。）图灵机固然可以模拟 RAM 访问机，但需要 @link["https://cs.stackexchange.com/a/22419/160863"]{多项式时间}，这就让你没法 @link["https://en.wikipedia.org/wiki/Brainfuck"]{像这样写代码}。
    }

    @heading["jmp-load-store"]{可我也不用 @code{JMP} 和 @code{LOAD}/@code{STORE} 写代码啊！}
    @para{
      确实。我们可怜的小脑子（除了他们的）早已被证明没有用汇编写代码的能力，而 Haskell 也不只是 @math{\lambda}-演算。抽象登场，是为了解放我们那点可怜的 RAM。说到抽象，我想把它解释为“只处理部分信息”。比如，我知道无论输入是什么，只要输入相同，@math{f} 总是给出相同输出，原因很简单：@math{f} 是函数。在 C 语言里，我们定义函数，把只按底层含义运作的实际过程藏起来。好的语言解放我们的大脑，减少我们手头要处理的信息。一路向下，全是抽象。
    }

    @heading["creating-languages"]{而所谓创造语言，你指的是……}
    @para{
      抽象很好，但（就软件工程而言）谈到抽象，并没有什么底层的形而上学含义（谢天谢地），也没有正式定义。无非是开发者想怎么干就怎么干。在 Golang 里有 @code{interface}，在 C 里有函数，在 C++ 里有 @code{class}，在 Haskell 里到处都是函数。面对 @link["https://en.wikipedia.org/wiki/Expression_problem"]{表达式问题}，有人选择纵向分派方法，有人选择横向分派。类型也不是原语，同样是抽象。一切都只是比特和字节，把 IEEE double 解释成 short 不会造成什么根本麻烦，有时候我们还会故意这么做。类型之所以存在，是因为大多数时候我们想保持一致。这些都说明，抽象很大程度上受相对主义支配。LISP 就在这里登场。它——我还是想这样解释——用宏来抽象“抽象”本身。看下面这段程序：
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
      在编译期完成。LISP 宏真正了不起的一点，是可以在编译期做任意计算。比如，对喜欢类的 C++ 爱好者来说，有 CLOS（Common Lisp Object System），它本身就用 LISP 写成，不必掉进你那套确实图灵完备、却全搅在一起、只有上帝才看得懂的 C++ 模板胡话里。
    }

    @heading["tricks"]{你别跟我耍花招}
    @para{
      确实，编译器按定义就是在编译期做计算。LISP 提供的东西可以看作一个设计良好、模块化的编译器框架。它模糊了语言与语言背后技术之间的界线。我想我们可以欣然断定：创造语言，就是在创造新的方式，用来抽象满足我们需要的数据与过程。编程语言只会继续演化。这不是经证明的事实，而是某种由人创造的艺术。
    }
    @img["/files/20240501/whackygpt.png"]{喜欢 LISP 的 GPT}
    @para{
      而且事实证明，连 GPT 都喜欢 LISP，所以你最好去了解一下。
    }
  })

(provide post)