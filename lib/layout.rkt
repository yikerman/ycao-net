#lang racket/base

;;;; Site-aware page layouts: wraps rendered content in a full HTML document.

(require racket/contract
         xml
         "document.rkt"
         "analyze.rkt"
         "render.rkt"
         "site.rkt")

;;; languages: "en" and "zh" (see lib/markup.rkt)

(define html-langs (hash "en" "en" "zh" "zh-CN"))
(define lang-labels (hash "en" "En" "zh" "中文"))

;; shown atop a translation, in the translation's language
(define tr-notices
  (hash "en" "This post was translated from Chinese by an LLM. The original is authoritative: "
        "zh" "本文由 LLM 从英文原文翻译，以原文为准："))

;; the small " (中文)" / " (En)" link after a title, to its other-language version
(define (lang-link url lang)
  (list " " `(a ([class "lang-link"] [href ,url]) ,(format "(~a)" (hash-ref lang-labels lang)))))

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
(define (embed-base-html lang title extra-head body-elements)
  `(html ([lang ,(hash-ref html-langs lang)])
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
(define (render-html-page s title extra-head body-elements #:lang [lang "en"])
  (embed-base-html lang title extra-head
                   (list (render-nav (nav-entries s))
                         `(main ([id "main"]) ,@body-elements))))

;;; page layouts

;; a full HTML page for an article: title, date, toc, body, references.
;; title-extra follows the title; notice follows the date.
(define (article-page s art info refs title-extra
                      #:notice [notice '()] #:extra-head [extra-head '()])
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
    (if (null? refs)
        '()
        (list
          `(section
             (h2 "References")
             (ol ,@(map render-reference refs))))))

  (render-html-page
    s
    (article-title art)
    (append extra-head (doc-info->extra-head info))
    (list
      `(article
         (h1 ,(article-title art) ,@title-extra)
         (p ([class "date"]) ,(article-date art))
         ,@notice
         ,@toc
         ,@(render-article-body info (article-body art))
         ,@references))
    #:lang (article-lang art)))

;; the link from a post to its translation; '() when it has none
(define (post-tr-link p)
  (define tr (site-post-tr p))
  (if tr
      (lang-link (translation-rel-url p) (article-lang (site-translation-art tr)))
      '()))

(define (render-post-page s p)
  (article-page s (site-post-art p) (site-post-info p) (site-post-refs p)
                (post-tr-link p)))

;; a post's translation: marked as such, linked back to the post, and kept
;; out of search indexes
(define (render-translation-page s p)
  (define art (site-post-art p))
  (define tr (site-post-tr p))
  (define tr-art (site-translation-art tr))
  (article-page s tr-art (site-translation-info tr) (site-translation-refs tr)
                (lang-link (post-rel-url p) (article-lang art))
                #:notice `((p ([class "tr-notice"])
                              ,(hash-ref tr-notices (article-lang tr-art))
                              (a ([href ,(post-rel-url p)]) ,(article-title art))))
                #:extra-head '((meta ([name "robots"] [content "noindex"])))))

;; a full HTML page for an authored standalone page (About, etc.)
(define (render-standalone-page s sp)
  (render-html-page s (standalone-page-title sp) '() (standalone-page-body sp)))

(provide (contract-out
           [render-html-page (->* (site? string? (listof xexpr/c) (listof xexpr/c))
                                  (#:lang string?)
                                  xexpr/c)]
           [render-post-page (-> site? site-post? xexpr/c)]
           [render-translation-page (-> site? (and/c site-post? site-post-tr) xexpr/c)]
           [post-tr-link (-> site-post? (listof xexpr/c))]
           [render-standalone-page (-> site? standalone-page? xexpr/c)]))
