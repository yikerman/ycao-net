#lang racket/base

;;;; registers standalone (non-post) pages, each authored in content/pages/

(require "pages/about.rkt"
         "pages/pgp.rkt")

;; NOTE: register standalone pages here
(define standalone-pages
  (list about-page pgp-page))

(provide standalone-pages)
