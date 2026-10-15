#lang racket/base

;;;; Site-aware page layouts: wraps rendered content in a full HTML document.

(require racket/contract
         xml
         "document.rkt"
         "analyze.rkt"
         "render.rkt"
         "site.rkt")

;;; HTML document chrome

;; head entries for the features the analyzed document actually uses
(define mathjax-head
  '((script ([id "MathJax-script"]
             [async "async"]
             [src "https://cdn.jsdelivr.net/npm/mathjax@4/tex-mml-chtml.js"]))))

(define highlightjs-head
  ;; NOTE: add extra highlightjs PL support here
  (let ([extra-langs '("scheme")])
    `((link ([rel "stylesheet"]
             [href "https://cdn.jsdelivr.net/gh/highlightjs/cdn-release@11.11.1/build/styles/default.min.css"]))
      (script ([src "https://cdn.jsdelivr.net/gh/highlightjs/cdn-release@11.11.1/build/highlight.min.js"]))
      ,@(map (λ (lang)
               `(script ([src ,(format "https://cdn.jsdelivr.net/gh/highlightjs/cdn-release@11.11.1/build/languages/~a.min.js" lang)])))
             extra-langs)
      (script "document.addEventListener('DOMContentLoaded', function () { hljs.highlightAll(); });"))))

;; extract extra elements that goes to <head>
(define (doc-info->extra-head info)
  (append (if (doc-ref info 'has-math?) mathjax-head '())
          (if (doc-ref info 'has-code?) highlightjs-head '())))

;; wraps a list of body elements in a full HTML document; extra-head is
;; spliced into <head>
(define (embed-base-html title extra-head body-elements)
  `(html ([lang "en"])
     (head
       (meta ([charset "utf-8"]))
       (meta ([name "viewport"] [content "width=device-width, initial-scale=1"]))
       (link ([rel "icon"] [type "image/x-icon"] [href "/favicon.ico"]))
       (link ([rel "stylesheet"] [href "/style.css"]))
       (link ([rel "alternate"] [type "application/atom+xml"] [href "/atom.xml"]))
       ,@extra-head
       (title ,title))
     (body ,@body-elements)))

;; the site nav shown on every page
(define (render-nav entries)
  `(nav ([class "site-nav"])
        ,@(map (λ (e) `(a ([href ,(cdr e)]) ,(car e))) entries)))

;; a full HTML page: head + site nav + the given body elements
(define (render-html-page s title extra-head body-elements)
  (embed-base-html title extra-head
                   (list (render-nav (nav-entries s))
                         `(main ([id "main"]) ,@body-elements))))

;;; page layouts

;; a full HTML page for a collected post: title, date, toc, body, references
(define (render-post-page s p)
  (define art (site-post-art p))
  (define info (site-post-info p))

  (define (render-reference entry) ; entry is (key . formatted-text)
    `(li ([id ,(cite-key->anchor-id (car entry))]) ,(cdr entry)))

  (define toc
    (let ([headings (doc-ref info 'headings)])
      (if (null? headings)
          '()
          (list
            `(nav ([class "toc"])
                  (ul ,@(map (λ (h)
                               `(li (a ([href ,(string-append "#" (heading-id h))])
                                       ,@(render-inlines info (heading-content h)))))
                             headings)))))))

  (define references
    (let ([refs (site-post-refs p)])
      (if (null? refs)
          '()
          (list
            `(section
               (h2 "References")
               (ol ,@(map render-reference refs)))))))

  (render-html-page
    s
    (article-title art)
    (doc-info->extra-head info)
    (list
      `(article
         (h1 ,(article-title art))
         (p ([class "date"]) ,(article-date art))
         ,@toc
         ,@(render-article-body info (article-body art))
         ,@references))))

;; a full HTML page for an authored standalone page (About, etc.)
(define (render-standalone-page s sp)
  (render-html-page s (standalone-page-title sp) '() (standalone-page-body sp)))

(provide (contract-out
           [render-html-page (-> site? string? (listof xexpr/c) (listof xexpr/c) xexpr/c)]
           [render-post-page (-> site? site-post? xexpr/c)]
           [render-standalone-page (-> site? standalone-page? xexpr/c)]))
