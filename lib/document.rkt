#lang racket/base

;;;; the document AST: a pure data model, independent of any output backend.
;;;; `inline?`/`block?` are the union predicates used by the traversal
;;;; (lib/analyze.rkt) and by boundary contracts.

(require racket/contract)

;;; inline nodes

(struct text (content) #:transparent)
(struct bold (content) #:transparent)
(struct it (content) #:transparent)
(struct code (content) #:transparent) ; inline monospace; content is a string
(struct link (url content) #:transparent)
(struct cite (key) #:transparent)
(struct math (tex) #:transparent)
(struct eqref (label) #:transparent)

(define (inline? x)
  (or (text? x) (bold? x) (it? x) (code? x) (link? x) (cite? x) (math? x) (eqref? x)))

;;; block nodes

(struct para (content) #:transparent)
(struct heading (id content) #:transparent)
(struct code-block (lang code) #:transparent)
(struct math-block (tex label) #:transparent) ; label is a string or #f
(struct disp-math (tex) #:transparent) ; un-numbered display math (no \label/\eqref)
(struct img (url alt) #:transparent) ; url + caption; alt is a string or #f
(struct quote-block (content) #:transparent) ; blockquote; content is inlines
(struct list-block (ordered? items) #:transparent) ; items: (listof (listof inline?))
(struct raw-html (html) #:transparent) ; verbatim HTML escape hatch; html is a string

(define (block? x)
  (or (para? x) (heading? x) (code-block? x) (math-block? x) (disp-math? x)
      (img? x) (quote-block? x) (list-block? x) (raw-html? x)))

(struct article (title date body) #:transparent)

(define (cite-key->anchor-id key)
  (format "cite-~a" key))

(define (cite-key->anchor-str key)
  (string-append "#" (cite-key->anchor-id key)))

(define (eq-label->anchor-id label)
  (format "eq-~a" label))

(define (eq-label->anchor-str label)
  (string-append "#" (eq-label->anchor-id label)))

(provide (struct-out text)
         (struct-out bold)
         (struct-out it)
         (struct-out code)
         (struct-out link)
         (struct-out cite)
         (struct-out math)
         (struct-out eqref)
         (struct-out img)
         (struct-out para)
         (struct-out heading)
         (struct-out code-block)
         (struct-out math-block)
         (struct-out disp-math)
         (struct-out quote-block)
         (struct-out list-block)
         (struct-out raw-html)
         (struct-out article)
         inline? block?
         (contract-out
           [cite-key->anchor-id (-> string? string?)]
           [cite-key->anchor-str (-> string? string?)]
           [eq-label->anchor-id (-> string? string?)]
           [eq-label->anchor-str (-> string? string?)]))
