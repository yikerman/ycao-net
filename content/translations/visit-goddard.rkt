#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["参观 NASA 戈达德太空飞行中心" "2023-08-01" #:lang "zh"]{
    @para{
      2023 年 8 月 1 日，我参观了 NASA 戈达德太空飞行中心（Goddard Space Flight Center）。能亲眼看到真正的航天器及其背后的研发人员，体验棒极了。更令人兴奋的是，游客中心允许拍照，所以我可以在这里分享一些照片。
    }
    @img["/files/20230801/dustless.jpg"]{无尘洁净室}
    @para{
      这是组装航天器的无尘洁净室。室内的空气经过过滤，去除了灰尘和其他颗粒物；温湿度也受到严格控制，以防发生腐蚀等问题。
    }
    @para{
      左上角的大型框架结构是一个模型，供工程师检验各个部件能否与最终的航天器严丝合缝。
    }
    @img["/files/20230801/indicator.jpg"]{指示灯}
    @img["/files/20230801/assembly.jpg"]{正在组装的工程师}
    @para{太空中心的另一个重要部分是测试设施。}
    @para{
      航天器会在真空室中接受测试，以模拟太空环境。真空室可以降温或加热到极端温度，还能模拟辐射等其他太空隐患。
    }
    @img["/files/20230801/can.jpg"]{测试罐}
    @img["/files/20230801/chamber.jpg"]{测试室}
    @para{
      如镜中所示，航天器还会在振动台上接受测试，以模拟发射过程。
    }
    @img["/files/20230801/shake.jpg"]{振动台}
  })

(provide post)