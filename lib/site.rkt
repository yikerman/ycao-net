#lang racket/base

;;;; The Site value + the page/URL model.
;;;;
;;;; The static-site invariant: a file written to dist/X is served at /X, so a
;;;; page's destination Path is the single source of its URL (dest-path->url).
;;;; `page` is the linkable site-map entry that nav, index, and sitemap
;;;; enumerate; posts and standalone pages both *project* to it via
;;;; post->page / standalone-page->page.

(require racket/contract
         "document.rkt"
         "analyze.rkt")

;; site-wide configuration, authored in content/config.rkt
;; base-url: absolute, no trailing slash
(struct site-config (base-url title author) #:transparent)

;; one collected post: slug, AST, and the analysis computed once in build-site
(struct site-post (slug art info) #:transparent)

;; an authored non-post page (e.g. About): linkable metadata + body xexprs.
;; date may be #f (no sitemap lastmod). body is a list of xexprs (the page
;; content, spliced into <body> after the nav).
(struct standalone-page (path title date body) #:transparent)

;; the linkable site-map entry that nav / index / sitemap iterate
(struct page (path title date) #:transparent)

;; everything the generators read; posts sorted newest-first
(struct site (cfg posts standalone bib) #:transparent)

;;; collect pass

;; resolve doc-local citations against the global bib (the "linker" step):
;; produce the reference list ordered by cite number, stored under 'references.
;; This is the natural place to fail fast on a missing bib key.
(define (resolve-references info bib)
  (define cite-numbers (doc-ref info 'cite-numbers))
  (define refs
    (for/list ([entry (in-list (sort (hash->list cite-numbers)
                                     (λ (a b) (< (cdr a) (cdr b)))))])
      (define key (car entry))
      (cons key
            (hash-ref bib key
                      (λ () (error 'build-site "cites missing bib key: ~s" key))))))
  (hash-set info 'references refs))

;; analyze + resolve every post body once, then sort newest-first
(define (build-site cfg posts standalone bib)
  (define collected
    (for/list ([p (in-list posts)])
      (define info
        (resolve-references (analyze default-analyses (article-body (cdr p))) bib))
      (site-post (car p) (cdr p) info)))
  (define newest-first
    (sort collected
          (λ (a b)
            (string>? (article-date (site-post-art a))
                      (article-date (site-post-art b))))))
  (site cfg newest-first standalone bib))

;;; URL/path: the destination Path is the single source of the URL

(define (dest-path->url p)
  (string-append "/" (path->string p)))

(define (post-dest-path p)
  (string->path (format "posts/~a.html" (site-post-slug p))))

;; derived from post-dest-path, so a post's file and its URL can never drift
(define (post-rel-url p)
  (dest-path->url (post-dest-path p)))

(define (page-abs-url s rel)
  (string-append (site-config-base-url (site-cfg s)) rel))

(define (post-abs-url s p)
  (page-abs-url s (post-rel-url p)))

;;; the page table

(define (post->page p)
  (page (post-dest-path p)
        (article-title (site-post-art p))
        (article-date (site-post-art p))))

(define (standalone-page->page sp)
  (page (standalone-page-path sp)
        (standalone-page-title sp)
        (standalone-page-date sp)))

;; every linkable page, posts first (newest-first) then standalone pages
(define (site-pages s)
  (append (map post->page (site-posts s))
          (map standalone-page->page (site-standalone s))))

;; nav entries shown on every page: Home plus each standalone page
(define (nav-entries s)
  (cons (cons "Home" "/")
        (map (λ (sp) (cons (standalone-page-title sp)
                           (dest-path->url (standalone-page-path sp))))
             (site-standalone s))))

;; date of the newest post (posts are sorted newest-first); "" when empty
(define (site-updated s)
  (define posts (site-posts s))
  (if (null? posts) "" (article-date (site-post-art (car posts)))))

(provide (struct-out site-config)
         (struct-out site-post)
         (struct-out standalone-page)
         (struct-out page)
         (struct-out site)
         (contract-out
           [build-site (-> site-config? (listof (cons/c string? article?))
                           (listof standalone-page?) hash? site?)]
           [dest-path->url (-> path? string?)]
           [post-dest-path (-> site-post? path?)]
           [post-rel-url (-> site-post? string?)]
           [page-abs-url (-> site? string? string?)]
           [post-abs-url (-> site? site-post? string?)]
           [post->page (-> site-post? page?)]
           [standalone-page->page (-> standalone-page? page?)]
           [site-pages (-> site? (listof page?))]
           [nav-entries (-> site? (listof (cons/c string? string?)))]
           [site-updated (-> site? string?)]))
