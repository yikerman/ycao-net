#lang racket/base

;;;; registers standalone (non-post) pages and renders them, mirroring
;;;; content/post.rkt

(require "pages/about.rkt"
         "pages/pgp.rkt"
         ycao-net/lib/output
         ycao-net/lib/render
         ycao-net/lib/site)

;; NOTE: register standalone pages here
(define standalone-pages
  (list about-page pgp-page))

(define (generate-standalone-pages s)
  (map (λ (sp)
         (out-file-from-xml
           (render-standalone-page s sp)
           (standalone-page-path sp)))
       (site-standalone s)))

(provide standalone-pages generate-standalone-pages)
