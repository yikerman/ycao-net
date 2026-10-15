#lang racket/base

;;;; copies static/* to the output root

(require racket/file
         racket/path
         ycao-net/lib/output)

(define static-dir (string->path "static"))

(define (delay-file-read path)
  (out-file
    (lambda () (file->bytes path))
    (find-relative-path static-dir path)))

;; ignores the Site; copies every file under static/ to the output root
(define (generate-static _s)
  (define static-files (find-files file-exists? static-dir))
  (map delay-file-read static-files))

(provide generate-static)
