#lang racket/base

;;;; discovers every post under content/posts/ and the LLM translations under
;;;; content/translations/, both keyed by file name as slug

(require file/glob
         racket/path
         racket/runtime-path)

(define-runtime-path posts-glob "posts/*.rkt")
(define-runtime-path translations-glob "translations/*.rkt")

(define (post-path->slug path)
  (path->string (path-replace-extension (file-name-from-path path) #"")))

(define (load-posts pattern)
  (for/list ([path (sort (glob pattern) path<?)])
    (cons (post-path->slug path)
          (dynamic-require path 'post))))

(define all-posts (load-posts posts-glob))
(define all-translations (load-posts translations-glob))

(provide all-posts all-translations)
