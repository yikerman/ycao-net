#lang racket/base

;;;; discovers every post under content/posts/, keyed by file name as slug

(require file/glob
         racket/path
         racket/runtime-path)

(define-runtime-path posts-glob "posts/*.rkt")

(define (post-path->slug path)
  (path->string (path-replace-extension (file-name-from-path path) #"")))

(define all-posts
  (for/list ([path (sort (glob posts-glob) path<?)])
    (cons (post-path->slug path)
          (dynamic-require path 'post))))

(provide all-posts)
