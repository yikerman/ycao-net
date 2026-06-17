#lang racket/base

(require racket/cmdline
         racket/list
         "content/config.rkt"
         "content/post.rkt"
         "content/pages.rkt"
         "content/index.rkt"
         "content/static.rkt"
         "content/feed.rkt"
         "content/sitemap.rkt"
         "content/bib.rkt"
         "lib/site.rkt"
         "lib/output.rkt")

(define output-dir (make-parameter (string->path "dist")))

(module+ main
  (command-line
    #:program "ycao-net"
    #:once-each
    [("-o" "--output") dir "Output directory (default: dist)"
     (output-dir (string->path dir))])

  ;; collect pass
  (define the-site (build-site config all-posts standalone-pages bib-db))

  (define generators
    (list generate-static
          generate-post-pages
          generate-standalone-pages
          generate-index
          generate-feed
          generate-sitemap))

  (define all-files
    (append-map (λ (g) (g the-site)) generators))

  (write-out-files all-files (output-dir)))
