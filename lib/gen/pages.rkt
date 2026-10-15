#lang racket/base

;;;; generates one HTML file per standalone page, at its own path

(require ycao-net/lib/layout
         ycao-net/lib/output
         ycao-net/lib/site)

(define (generate-standalone-pages s)
  (map (λ (sp)
         (out-file-from-xml
           (render-standalone-page s sp)
           (standalone-page-path sp)))
       (site-standalone s)))

(provide generate-standalone-pages)
