#lang racket/base

;;;; at-exp-friendly constructors for the document AST.
;;;; posts should require this instead of document.rkt and use
;;;; #lang at-exp racket/base

(require (prefix-in ast: "document.rkt"))

;; internal: turn bare strings in an arg list into text nodes
(define (coerce-inlines args)
  (map (λ (a) (if (string? a) (ast:text a) a)) args))

;; internal: drop the whitespace strings the reader puts between @item s
(define (keep-items items)
  (filter (λ (x) (not (string? x))) items))

;; the post root: title, date, then block content (whitespace between blocks
;; is dropped; stray text is an error)
;; @article["My Post" "2024-05-01"]{ @heading["a"]{A} @para{Hi.} }
(define (article title date . body)
  (ast:article title date
               (for/list ([b (in-list body)]
                          #:unless (and (string? b) (regexp-match? #px"^\\s*$" b)))
                 (if (string? b)
                     (error 'article "text outside a block in article body: ~s" b)
                     b))))

;; a paragraph of inline content
;; @para{Some text with @bold{emphasis}.}
(define (para . content)
  (ast:para (coerce-inlines content)))

;; an h2 heading that registers in toc
;; @heading["intro"]{Introduction}
(define (heading id . content)
  (ast:heading id (coerce-inlines content)))

;; a syntax-highlighted code block; lang is a highlight.js language name
;; @code-block["python"]|{print("hi")}|
(define (code-block lang . code)
  (ast:code-block lang (apply string-append code)))

;; a numbered display equation; optional #:label is the target for @eqref
;; @math-block[#:label "euler"]{e^{i\pi} + 1 = 0}
(define (math-block #:label [label #f] . tex)
  (ast:math-block (apply string-append tex) label))

;; bold inline text
;; @bold{important}
(define (bold . content)
  (ast:bold (coerce-inlines content)))

;; italic inline text
;; @it{emphasized}
(define (it . content)
  (ast:it (coerce-inlines content)))

;; inline monospace; use @code|{...}| if it contains @ or braces
;; @code{printf()}
(define (code . content)
  (ast:code (apply string-append content)))

;; a hyperlink; url in brackets, link text in braces
;; @link["https://example.com"]{example}
(define (link url . content)
  (ast:link url (coerce-inlines content)))

;; a numbered citation to a key in bib.rkt; renders as a [n] superscript
;; @cite["vaswaniAttentionAllYou2017"]
(define (cite key)
  (ast:cite key))

;; inline math (TeX, rendered by MathJax)
;; @math{d_k}
(define (math . tex)
  (ast:math (apply string-append tex)))

;; a reference to a labeled @math-block; renders that equation's number
;; @eqref["euler"]
(define (eqref label)
  (ast:eqref label))

;; a block figure; the optional description is both alt text and caption
;; @img["/files/x.png"]{A caption}
(define (img url . desc)
  (ast:img url (and (pair? desc) (apply string-append desc))))

;; un-numbered display math; use @dmath|{...}| for \begin{align}/matrices etc.
;; @dmath{F = ma}
(define (dmath . tex)
  (ast:disp-math (apply string-append tex)))

;; a block quotation of inline content
;; @blockquote{To be, or not to be.}
(define (blockquote . content)
  (ast:quote-block (coerce-inlines content)))

;; one list item; only valid inside @ul / @ol
;; @item{first point}
(define (item . content)
  (coerce-inlines content))

;; a bulleted list of @item s
;; @ul{ @item{one} @item{two} }
(define (ul . items)
  (ast:list-block #f (keep-items items)))

;; a numbered list of @item s
;; @ol{ @item{first} @item{second} }
(define (ol . items)
  (ast:list-block #t (keep-items items)))

;; raw HTML escape hatch (videos, embeds); content passed through verbatim.
;; use @xml|{...}| so braces and @ inside the HTML are taken literally
;; @xml|{<video controls><source src="/x.mp4" type="video/mp4"></video>}|
(define (xml . content)
  (ast:raw-html (apply string-append content)))

(provide article para heading code-block math-block dmath
         bold it code link cite math eqref img
         blockquote item ul ol xml)
