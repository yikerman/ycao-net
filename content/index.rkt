#lang racket/base

;;;; generates index.html

(require ycao-net/lib/document
         ycao-net/lib/output
         ycao-net/lib/render
         ycao-net/lib/site)

(define (post-list-item p)
  (define art (site-post-art p))
  `(li (span ([class "date"]) ,(article-date art))
       " "
       (a ([href ,(post-rel-url p)]) ,(article-title art))))

(define (generate-index s)
  (define title (site-config-title (site-cfg s)))
  (list
    (out-file-from-xml
      (render-html-page s title '()
        (list
          `(div
             (h1 ,title)
             (ul ([class "post-list"])
                 ;; posts are already sorted newest-first by build-site
                 ,@(map post-list-item (site-posts s))))))
      (string->path "index.html"))))

(provide generate-index)
