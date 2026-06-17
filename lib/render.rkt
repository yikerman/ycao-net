#lang racket/base

;;;; Rendering an analyzed document to HTML XExprs.
;;;;
;;;; Tiers:
;;;;   render-article-body : (info, AST) -> xexprs : handles local elements
;;;;   render-html-page / render-page / render-standalone-page
;;;;        : appends site-aware chrome (head + site nav + body)

(require racket/contract
         xml
         "document.rkt"
         "analyze.rkt"
         "site.rkt")

;;; dispatch utils

;; a renderer corresponding to an AST node
;; applies?: predicate that if true use current renderer
;; run: actual render procedure (node, render-ctx) -> xexpr
(struct renderer (applies? run) #:transparent)

;; renderers: list of renderer to be dispatched
;; info: doc-info auxillary data
(struct render-ctx (renderers info) #:transparent)

;; dispatch one node to the first matching renderer
;; rc: render-ctx
(define (render rc node)
  (let loop ([rs (render-ctx-renderers rc)])
    (cond [(null? rs)
           (error 'render "no renderer for ~s" node)]
          [((renderer-applies? (car rs)) node) ((renderer-run (car rs)) node rc)]
          [else
           (loop (cdr rs))])))

(define (render* rc nodes)
  (map (λ (n) (render rc n)) nodes))

;;; inline renderers

;; NOTE: n - node, rc - render-ctx

(define text-renderer ; raw text as-is
  (renderer text? (λ (n _rc) (text-content n))))
(define bold-renderer
  (renderer bold? (λ (n rc) `(b ,@(render* rc (bold-content n))))))
(define it-renderer
  (renderer it? (λ (n rc) `(i ,@(render* rc (it-content n))))))
(define code-renderer
  (renderer code? (λ (n _rc) `(code ,(code-content n)))))
(define link-renderer
  (renderer link? (λ (n rc) `(a ([href ,(link-url n)]) ,@(render* rc (link-content n))))))
(define cite-renderer
  (renderer cite?
            (λ (n rc)
              (define cite-num (hash-ref
                                 (doc-ref (render-ctx-info rc) 'cite-numbers)
                                 (cite-key n)))
              `(sup (a ([href ,(cite-key->anchor-str (cite-key n))]) ,(format "[~a]" cite-num))))))
(define math-renderer ; \(math\) triggers mathjax
  (renderer math? (λ (n _rc) `(span ,(format "\\(~a\\)" (math-tex n))))))
(define eqref-renderer
  (renderer eqref?
            (λ (n rc)
              (define by-label (cdr (doc-ref (render-ctx-info rc) 'eq-numbers)))
              `(a ([href ,(eq-label->anchor-str (eqref-label n))])
                  ,(format "(~a)" (hash-ref by-label (eqref-label n)))))))

;;; block renderers
(define para-renderer
  (renderer para? (λ (n rc) `(p ,@(render* rc (para-content n))))))
(define heading-renderer
  (renderer heading? (λ (n rc) `(h2 ([id ,(heading-id n)]) ,@(render* rc (heading-content n))))))
(define code-block-renderer
  (renderer code-block?
            (λ (n _rc) `(pre (code ([class ,(string-append "language-" (code-block-lang n))])
                                   ,(code-block-code n))))))
(define math-block-renderer
  (renderer math-block?
            (λ (n rc)
              (define num (hash-ref (car (doc-ref (render-ctx-info rc) 'eq-numbers)) n))
              (define label (math-block-label n))
              `(div ([class "equation"] ,@(if label `([id ,(eq-label->anchor-id label)]) '()))
                    ,(format "\\[~a\\]" (math-block-tex n))
                    (span ([class "eq-number"]) ,(format "(~a)" num))))))
(define img-renderer
  (renderer img?
            (λ (n _rc)
              (define alt (img-alt n))
              `(figure
                 (img ([src ,(img-url n)] ,@(if alt `([alt ,alt]) '())))
                 ,@(if alt `((figcaption ,alt)) '())))))

;; un-numbered display math. AMS *display* environments (align, gather, …) are
;; processed by MathJax automatically at top level, and wrapping them in
;; \[...\] would nest display structures, so emit them raw. Everything else
;; (incl. bmatrix/pmatrix/cases, which need math mode) is wrapped in \[...\].
(define amsmath-display-env-rx
  #px"^\\s*\\\\begin\\{(align|alignat|gather|equation|multline|flalign|eqnarray)\\*?\\}")
(define disp-math-renderer
  (renderer disp-math?
            (λ (n _rc)
              (define tex (disp-math-tex n))
              `(div ([class "equation"])
                    ,(if (regexp-match? amsmath-display-env-rx tex)
                         tex
                         (format "\\[~a\\]" tex))))))

(define quote-block-renderer
  (renderer quote-block?
            (λ (n rc) `(blockquote ,@(render* rc (quote-block-content n))))))
(define list-block-renderer
  (renderer list-block?
            (λ (n rc)
              (define tag (if (list-block-ordered? n) 'ol 'ul))
              `(,tag ,@(map (λ (item) `(li ,@(render* rc item)))
                            (list-block-items n))))))

;; cdata is emitted unescaped by xexpr->string
(define raw-html-renderer
  (renderer raw-html? (λ (n _rc) (cdata #f #f (raw-html-html n)))))

(define html-renderers
  (list text-renderer bold-renderer it-renderer code-renderer link-renderer
        cite-renderer math-renderer eqref-renderer
        para-renderer heading-renderer code-block-renderer math-block-renderer
        disp-math-renderer img-renderer quote-block-renderer list-block-renderer
        raw-html-renderer))

;;; metadata + AST -> xexprs (used by the Atom feed and by render-page)
(define (render-article-body info blocks)
  (render* (render-ctx html-renderers info) blocks))

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
  `(html
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
                   (cons (render-nav (nav-entries s)) body-elements)))

;; a full HTML page for an article; info must carry the resolved 'references
;; (added by the collect pass in lib/site.rkt)
(define (render-page s art info)
  (define rc (render-ctx html-renderers info))

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
                                       ,@(render* rc (heading-content h)))))
                             headings)))))))

  (define references
    (let ([refs (doc-ref info 'references)])
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
           [render-article-body (-> hash? (listof block?) (listof xexpr/c))]
           [render-html-page (-> site? string? (listof xexpr/c) (listof xexpr/c) xexpr/c)]
           [render-page (-> site? article? hash? xexpr/c)]
           [render-standalone-page (-> site? standalone-page? xexpr/c)]))
