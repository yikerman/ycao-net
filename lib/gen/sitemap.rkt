#lang racket/base

;;;; generates sitemap.xml (sitemaps.org schema 0.9), folding over site-pages

(require ycao-net/lib/output
         ycao-net/lib/site)

(define (url-entry loc lastmod)
  (if lastmod
      `(url (loc ,loc) (lastmod ,lastmod))
      `(url (loc ,loc))))

(define (generate-sitemap s)
  (list
    (out-file-from-xml-doc
      `(urlset ([xmlns "http://www.sitemaps.org/schemas/sitemap/0.9"])
               ,(url-entry (page-abs-url s "/") (site-updated s))
               ,@(map (λ (pg)
                        (url-entry (page-abs-url s (dest-path->url (page-path pg)))
                                   (page-date pg)))
                      (site-pages s)))
      (string->path "sitemap.xml"))))

(provide generate-sitemap)
