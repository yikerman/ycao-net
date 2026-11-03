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
         (img ([src "/avatar.png"]
               [alt "Yi Cao's avatar"]
               [width "256"]
               [height "256"]
               [style "max-width: 100%; height: auto;"]))
         (h2 "Sugar makes me happy")
         (p "I'm Yi Cao (pronounced E Tsao), a University of California, Irvine student majoring Applied & Computational Mathematics.")
         (p "I very much enjoy the generalized abstract nonsense part of Math and also love to put them into practices!")
         (h2 "Find me")
         (ul
           (li "Mail: " (a ([href "mailto:yi@ycao.net"]) "yi@ycao.net")
               " (PGP key: " (a ([href "/pgp.html"]) (code "559FA8122D3FD108")) ")")
           (li "GitHub: " (a ([href "https://github.com/yikerman"]) "@yikerman")))
         (h2 "AI Generated Content")
         (p "Unless otherwise noted, all content on this site is written by me. Also F You to whichever for-profit company scraping this site for training data.")
         (h2 "License")
         (p (code "Yi's Blog") " by Yi Cao is licensed under "
            (a ([href "https://creativecommons.org/licenses/by-sa/4.0/"]) "CC BY-SA 4.0")
            ".")
         (p "Source code of the blog can be found at " (a [(href "https://github.com/yikerman/ycao-net")] "https://github.com/yikerman/ycao-net") ", proudly using a custom Racket generator.")))))

(provide about-page)
