#lang racket/base

;;;; Handles non-local info, e.g. citation
;;;;
;;;; An `analysis` is a first-class value: a key plus a fold from the block
;;;; list to a value. `analyze` runs a list of them into `doc-info` - an open
;;;; hash keyed by analysis name. Adding a new non-local fact (e.g. equation
;;;; numbering) is therefore additive: write one `analysis` and cons it onto
;;;; `default-analyses`; this module is never edited.
;;;;
;;;; The traversal (fold-doc / collect-struct / node-children) is the reusable
;;;; primitive every analysis is built on.

(require racket/contract
         "document.rkt")

;;; traversal primitive

;; get the children of a general node (inline or block)
(define (node-children n)
  (cond [(bold? n) (bold-content n)]
        [(it? n) (it-content n)]
        [(link? n) (link-content n)]
        [(para? n) (para-content n)]
        [(heading? n) (heading-content n)]
        [(quote-block? n) (quote-block-content n)]
        [(list-block? n) (apply append (list-block-items n))]
        [else '()]))

;; preorder fold over the document tree: each node is visited before its
;; children, left to right.
(define (fold-doc f init blocks)
  (define (visit n acc)
    (for/fold ([acc (f n acc)])
              ([child (in-list (node-children n))])
      (visit child acc)))
  (for/fold ([acc init])
            ([b (in-list blocks)])
    (visit b acc)))

;; every node satisfying pred?, in document (preorder) order
(define (collect-struct pred? blocks)
  (reverse
    (fold-doc (λ (n acc) (if (pred? n) (cons n acc) acc))
              '()
              blocks)))

;; number nodes by first occurrence of (key node): a new key gets
;; (count-so-far + 1). Shared by citation and (later) equation numbering.
(define (number-by-first-occurrence nodes key)
  (for/fold ([numbers (hash)])
            ([n (in-list nodes)])
    (define k (key n))
    (if (hash-has-key? numbers k)
        numbers
        (hash-set numbers k (add1 (hash-count numbers))))))

;;; analyses: the open dispatch table

;; an analysis names a doc-local fact and computes it as a fold over the body
(struct analysis (key run) #:transparent)

;; doc-info := immutable hash, analysis-key -> value
(define (analyze analyses blocks)
  (for/hash ([a (in-list analyses)])
    (values (analysis-key a) ((analysis-run a) blocks))))

;; read one analysis result out of a doc-info
(define (doc-ref info key [default (λ () (error 'doc-ref "no analysis: ~a" key))])
  (hash-ref info key default))

;; the four facts the renderer currently needs; each independent and additive
(define headings-analysis
  (analysis 'headings (λ (bs) (collect-struct heading? bs))))

(define has-math?-analysis
  (analysis 'has-math? (λ (bs) (not (and (null? (collect-struct math-block? bs))
                                         (null? (collect-struct disp-math? bs))
                                         (null? (collect-struct math? bs)))))))

(define has-code?-analysis
  (analysis 'has-code? (λ (bs) (not (null? (collect-struct code-block? bs))))))

;; key -> number, in first-occurrence order
(define cite-numbers-analysis
  (analysis 'cite-numbers
            (λ (bs) (number-by-first-occurrence (collect-struct cite? bs) cite-key))))

;; amsmath-style equation numbering: number every display equation in document
;; order, and map labels to those numbers so eqrefs resolve. Returns a pair
;; (by-node . by-label) — the doc-local symbol table the renderer consults.
(define eq-numbers-analysis
  (analysis 'eq-numbers
            (λ (bs)
              (for/fold ([by-node (hasheq)]
                         [by-label (hash)]
                         #:result (cons by-node by-label))
                        ([mb (in-list (collect-struct math-block? bs))]
                         [i (in-naturals 1)])
                (values (hash-set by-node mb i)
                        (if (math-block-label mb)
                            (hash-set by-label (math-block-label mb) i)
                            by-label))))))

;; add a new non-local fact by consing one analysis onto this list — `analyze`,
;; `doc-info`, and `node-children` are never touched (cf. eq-numbers-analysis)
(define default-analyses
  (list headings-analysis has-math?-analysis has-code?-analysis
        cite-numbers-analysis eq-numbers-analysis))

(provide (struct-out analysis)
         fold-doc node-children collect-struct number-by-first-occurrence
         (contract-out
           [analyze (-> (listof analysis?) (listof block?) hash?)]
           [doc-ref (->* (hash? symbol?) (any/c) any)]
           [default-analyses (listof analysis?)]))
