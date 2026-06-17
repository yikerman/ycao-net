#lang racket/base

;;;; the About standalone page; registered in content/pages.rkt.
;;;; body is a list of xexprs spliced into <body> after the site nav.

(require ycao-net/lib/site)

(define about-page
  (standalone-page
    (string->path "about.html")
    "About"
    #f
    (list
      `(article
         (h1 "About")
         (h2 "Sugar makes me happy")
         (p "I'm Yi, a University of California Irvine student hacking around.")
         (h2 "Find me")
         (ul
           (li "Mail: " (a ([href "mailto:yi@ycao.net"]) "yi@ycao.net")
               " (PGP key: " (a ([href "/pgp.html"]) (code "559FA8122D3FD108")) ")")
           (li "GitHub: " (a ([href "https://github.com/yikerman"]) "@yikerman"))
           (li "Instagram: "
               (a ([href "https://www.instagram.com/y.i.kerman/"]) "@y.i.kerman")))
         (h2 "License")
         (p "Yi's Blog by Yi Cao is licensed under "
            (a ([href "https://creativecommons.org/licenses/by-sa/4.0/"]) "CC BY-SA 4.0")
            ".")))))

(provide about-page)
