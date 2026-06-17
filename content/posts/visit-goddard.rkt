#lang at-exp racket/base

(require ycao-net/lib/markup)

(define post
  @article["Visiting NASA Goddard Space Flight Center" "2023-08-01"]{
    @para{
      I have visited NASA Goddard Space Flight Center on August 1st, 2023. It's
      a great experience to see the real spacecrafts and the people behind them.
      What's more exciting is that photos are allowed in the visitor center, so I
      can share some of them here.
    }
    @img["/files/20230801/dustless.jpg"]{Dustless Clean Room}
    @para{
      This is the dustless clean room where the spacecrafts are assembled. The
      air is filtered to remove dust and other particles. The temperature and
      humidity are also controlled to prevent corrosion and other problems.
    }
    @para{
      The big frame structure in the left upper corner is a model for engineers
      to see if parts fit the final spacecraft.
    }
    @img["/files/20230801/indicator.jpg"]{Indicator Light}
    @img["/files/20230801/assembly.jpg"]{Engineers Assembling}
    @para{Another important part of the space center is the testing facilities.}
    @para{
      The spacecrafts are tested in a vacuum chamber to simulate the space
      environment. The chamber can be cooled or heated to extreme temperatures.
      It can also simulate radiation and other space hazards.
    }
    @img["/files/20230801/can.jpg"]{Testing Can}
    @img["/files/20230801/chamber.jpg"]{Testing Chamber}
    @para{
      The spacecrafts are also tested in a vibration table to simulate the
      launch as shown in the mirror.
    }
    @img["/files/20230801/shake.jpg"]{Vibration Table}
  })

(provide post)
