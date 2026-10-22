#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["参观 NASA 戈达德太空飞行中心" "2023-08-01" #:lang "zh"]{
    @para{
      我于2023年8月1日参观了 NASA 戈达德太空飞行中心。能见到真实的航天器，也见到参与研制它们的人，这是一次很棒的体验。更令人兴奋的是，访客中心允许拍照，所以我可以在这里分享几张。
    }
    @img["/files/20230801/dustless.jpg"]{无尘洁净室}
    @para{
      这就是组装航天器的无尘洁净室。空气经过过滤，去除灰尘等颗粒。温度和湿度也受到控制，以防腐蚀等问题。
    }
    @para{
      左上角的大型框架结构是一个模型，供工程师检查各部件能否装入最终航天器。
    }
    @img["/files/20230801/indicator.jpg"]{指示灯}
    @img["/files/20230801/assembly.jpg"]{工程师正在组装}
    @para{航天中心的另一个重要部分是测试设施。}
    @para{
      航天器会在真空舱中接受测试，以模拟太空环境。舱内可冷却或加热到极端温度，还能模拟辐射和其他太空危害。
    }
    @img["/files/20230801/can.jpg"]{测试罐}
    @img["/files/20230801/chamber.jpg"]{测试舱}
    @para{
      航天器还会在振动台上接受测试，以模拟发射；如镜中所示。
    }
    @img["/files/20230801/shake.jpg"]{振动台}
  })

(provide post)