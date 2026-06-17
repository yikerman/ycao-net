#lang racket/base

;;;; site-wide configuration: base URL (absolute, no trailing slash),
;;;; site title, and author. Consumed by index, feed, and sitemap generators.

(require ycao-net/lib/site)

(define config (site-config "https://ycao.net" "Yi's Blog" "Yi Cao"))

(provide config)
