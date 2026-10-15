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

;; one collected post: slug, AST, the analysis computed once in build-site,
;; its reference list ((key . formatted-text) pairs ordered by cite number),
;; and its site-translation or #f
(struct site-post (slug art info refs tr) #:transparent)

;; an LLM translation of a post into its other language. Not a post: it is
;; reachable only through site-post-tr, so nothing iterating posts sees it.
(struct site-translation (art info refs) #:transparent)

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
;; produce the reference list ordered by cite number.
;; This is the natural place to fail fast on a missing bib key.
(define (resolve-references info bib)
  (for/list ([entry (in-list (sort (hash->list (doc-ref info 'cite-numbers))
                                   < #:key cdr))])
    (define key (car entry))
    (cons key
          (hash-ref bib key
                    (λ () (error 'build-site "cites missing bib key: ~s" key))))))

;; analyze an article body, then resolve its citations
(define (compile-article art bib)
  (define info (analyze default-analyses (article-body art)))
  (values info (resolve-references info bib)))

(define (collect-translation slug art tr-art bib)
  (when (equal? (article-lang tr-art) (article-lang art))
    (error 'build-site "translation of ~s is in the post's own language" slug))
  (define-values (info refs) (compile-article tr-art bib))
  (site-translation tr-art info refs))

;; analyze + resolve every post (and its translation) once, then sort
;; newest-first. translations are (slug . article) pairs keyed by their post.
(define (build-site cfg posts translations standalone bib)
  (for ([t (in-list translations)]
        #:unless (assoc (car t) posts))
    (error 'build-site "translation has no post: ~s" (car t)))
  (define collected
    (for/list ([p (in-list posts)])
      (define slug (car p))
      (define art (cdr p))
      (define-values (info refs) (compile-article art bib))
      (define tr (assoc slug translations))
      (site-post slug art info refs
                 (and tr (collect-translation slug art (cdr tr) bib)))))
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

;; a post's translation lives under it: posts/<slug>/<lang>.html
(define (translation-dest-path p)
  (string->path (format "posts/~a/~a.html"
                        (site-post-slug p)
                        (article-lang (site-translation-art (site-post-tr p))))))

(define (translation-rel-url p)
  (dest-path->url (translation-dest-path p)))

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
         (struct-out site-translation)
         (struct-out standalone-page)
         (struct-out page)
         (struct-out site)
         (contract-out
           [build-site (-> site-config?
                           (listof (cons/c string? article?))
                           (listof (cons/c string? article?))
                           (listof standalone-page?) hash? site?)]
           [dest-path->url (-> path? string?)]
           [post-dest-path (-> site-post? path?)]
           [post-rel-url (-> site-post? string?)]
           [translation-dest-path (-> (and/c site-post? site-post-tr) path?)]
           [translation-rel-url (-> (and/c site-post? site-post-tr) string?)]
           [page-abs-url (-> site? string? string?)]
           [post-abs-url (-> site? site-post? string?)]
           [post->page (-> site-post? page?)]
           [standalone-page->page (-> standalone-page? page?)]
           [site-pages (-> site? (listof page?))]
           [nav-entries (-> site? (listof (cons/c string? string?)))]
           [site-updated (-> site? string?)]))
