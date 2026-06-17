#lang racket/base

(require racket/contract
         racket/file
         xml)

;; data: a thunk producing the bytes to write, plus the destination path
(struct out-file (data path) #:transparent)

(define (out-file-from-string str path)
  (out-file (lambda () (string->bytes/utf-8 str)) path))

(define (out-file-from-xml xexpr path)
  (let ([str (xexpr->string xexpr)])
    (out-file-from-string (format "<!DOCTYPE html>\n~a" str) path)))

;; like out-file-from-xml but prepends an XML declaration instead of a
;; doctype; for non-HTML XML artifacts (Atom feed, sitemap)
(define (out-file-from-xml-doc xexpr path)
  (let ([str (xexpr->string xexpr)])
    (out-file-from-string
      (format "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n~a" str) path)))

(define (write-out-file file base-path)
  (define p (build-path base-path (out-file-path file)))
  (make-parent-directory* p)
  (displayln (format "Writing ~a" p))
  ;; notice out-file-data is a thunk and needs (evaled)
  (display-to-file ((out-file-data file)) p #:exists 'replace))

(define (write-out-files files base-path)
  (for ([f files])
    (write-out-file f base-path)))

(provide (struct-out out-file)
         (contract-out
           [out-file-from-string (-> string? path? out-file?)]
           [out-file-from-xml (-> xexpr/c path? out-file?)]
           [out-file-from-xml-doc (-> xexpr/c path? out-file?)]
           [write-out-file (-> out-file? path? void?)]
           [write-out-files (-> (listof out-file?) path? void?)]))
