#lang racket/base

;;;; generates posts/<slug>.html for every collected post, and
;;;; posts/<slug>/<lang>.html for each post's translation

(require ycao-net/lib/layout
         ycao-net/lib/output
         ycao-net/lib/site)

(define (generate-post-pages s)
  (append
    (for/list ([p (in-list (site-posts s))])
      (out-file-from-xml (render-post-page s p) (post-dest-path p)))
    (for/list ([p (in-list (site-posts s))]
               #:when (site-post-tr p))
      (out-file-from-xml (render-translation-page s p) (translation-dest-path p)))))

(provide generate-post-pages)
