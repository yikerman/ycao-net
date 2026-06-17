#lang racket/base

;;;; generates atom.xml (Atom 1.0, RFC 4287)

(require xml
         ycao-net/lib/document
         ycao-net/lib/render
         ycao-net/lib/output
         ycao-net/lib/site)

;; ISO date (YYYY-MM-DD) -> RFC 3339 timestamp
(define (date->rfc3339 d)
  (string-append d "T00:00:00Z"))

(define (feed-entry s p)
  (define art (site-post-art p))
  (define url (post-abs-url s p))
  (define body-html
    (apply string-append
           (map xexpr->string
                (render-article-body (site-post-info p) (article-body art)))))
  `(entry
     (title ,(article-title art))
     (link ([rel "alternate"] [href ,url]))
     (id ,url)
     (updated ,(date->rfc3339 (article-date art)))
     (content ([type "html"]) ,body-html)))

(define (generate-feed s)
  (define cfg (site-cfg s))
  (define home-url (page-abs-url s "/"))
  (define self-url (page-abs-url s "/atom.xml"))
  (list
    (out-file-from-xml-doc
      `(feed ([xmlns "http://www.w3.org/2005/Atom"])
             (title ,(site-config-title cfg))
             (id ,home-url)
             (link ([rel "self"] [href ,self-url]))
             (link ([rel "alternate"] [href ,home-url]))
             (updated ,(date->rfc3339 (site-updated s)))
             (author (name ,(site-config-author cfg)))
             ,@(map (λ (p) (feed-entry s p)) (site-posts s)))
      (string->path "atom.xml"))))

(provide generate-feed)
