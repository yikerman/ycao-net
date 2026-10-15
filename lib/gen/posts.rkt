#lang racket/base

;;;; generates posts/<slug>.html for every collected post

(require ycao-net/lib/layout
         ycao-net/lib/output
         ycao-net/lib/site)

(define (generate-post-pages s)
  (map (λ (p)
         (out-file-from-xml
           (render-post-page s p)
           (post-dest-path p)))
       (site-posts s)))

(provide generate-post-pages)
