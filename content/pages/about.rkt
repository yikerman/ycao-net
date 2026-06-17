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
         (p "I'm Yi Cao (pronounced E Tsao), a University of California Irvine student hacking around.")
         (h2 "Find me")
         (ul
           (li "Mail: " (a ([href "mailto:yi@ycao.net"]) "yi@ycao.net")
               " (PGP key: " (a ([href "/pgp.html"]) (code "559FA8122D3FD108")) ")")
           (li "GitHub: " (a ([href "https://github.com/yikerman"]) "@yikerman")))
         (h2 "AI Generated Content")
         (p "Unless otherwise noted, all content on this site is written by me without the assistance of AI. Sometimes AI is employed for research or proofreading but the final content is my own, and I claim full responsibility for it.")
         (p "To whichever for-profit company scraping this site for training data: FUCK YOU!")
         (h2 "License")
         (p (code "Yi's Blog") " by Yi Cao is licensed under "
            (a ([href "https://creativecommons.org/licenses/by-sa/4.0/"]) "CC BY-SA 4.0")
            ".")))))

(provide about-page)
