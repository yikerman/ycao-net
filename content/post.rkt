#lang racket/base

(require file/glob
         racket/path
         racket/runtime-path
         ycao-net/lib/output
         ycao-net/lib/render
         ycao-net/lib/site)

(define-runtime-path posts-glob "posts/*.rkt")

(define (post-path->slug path)
  (path->string (path-replace-extension (file-name-from-path path) #"")))

(define all-posts
  (for/list ([path (sort (glob posts-glob) path<?)])
    (cons (post-path->slug path)
          (dynamic-require path 'post))))

(define (generate-post-pages s)
  (map (λ (p)
         (out-file-from-xml
           (render-page s (site-post-art p) (site-post-info p))
           (post-dest-path p)))
       (site-posts s)))

(provide all-posts generate-post-pages)
