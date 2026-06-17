#lang racket/base

(require "posts/invent-wheels-with-autotools-c.rkt"
         "posts/uniform-circular-motion-acceleration.rkt"
         "posts/an-introduction-to-lambda-calculus.rkt"
         "posts/kerbalhopper.rkt"
         "posts/ssc-2023-experience.rkt"
         "posts/visit-goddard.rkt"
         "posts/simulating-gravity-lensing.rkt"
         "posts/on-programming-languages.rkt"
         "posts/llm-agi.rkt"
         "posts/asus-ux5406-review.rkt"
         "posts/ds-review.rkt"
         "posts/recreating-color-simplified.rkt"
         "posts/llm-after-three-years.rkt"
         ycao-net/lib/output
         ycao-net/lib/render
         ycao-net/lib/site)

;; NOTE: register posts here. Each post is (cons slug article). build-site sorts
;; them newest-first, so order here is just for readability.
(define all-posts
  (list (cons "invent-wheels-with-autotools-c" post-invent-wheels-with-autotools-c)
        (cons "uniform-circular-motion-acceleration" post-uniform-circular-motion-acceleration)
        (cons "an-introduction-to-lambda-calculus" post-an-introduction-to-lambda-calculus)
        (cons "kerbalhopper" post-kerbalhopper)
        (cons "ssc-2023-experience" post-ssc-2023-experience)
        (cons "visit-goddard" post-visit-goddard)
        (cons "simulating-gravity-lensing" post-simulating-gravity-lensing)
        (cons "on-programming-languages" post-on-programming-languages)
        (cons "llm-agi" post-llm-agi)
        (cons "asus-ux5406-review" post-asus-ux5406-review)
        (cons "ds-review" post-ds-review)
        (cons "recreating-color-simplified" post-recreating-color-simplified)
        (cons "llm-after-three-years" post-llm-after-three-years)))

(define (generate-post-pages s)
  (map (λ (p)
         (out-file-from-xml
           (render-page s (site-post-art p) (site-post-info p))
           (post-dest-path p)))
       (site-posts s)))

(provide all-posts generate-post-pages)
