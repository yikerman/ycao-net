#lang racket/base

;;;; the PGP Key standalone page; registered in content/pages.rkt.
;;;; body is a list of xexprs spliced into <body> after the site nav.

(require ycao-net/lib/site)

(define public-key
  (string-append
   "-----BEGIN PGP PUBLIC KEY BLOCK-----\n"
   "\n"
   "mDMEZxMwhBYJKwYBBAHaRw8BAQdAiJ0VN/9gQix0322NT0s2OQmZ5o3fAhfyRFBs\n"
   "7+yp0ZG0FFlpIENhbyA8eWlAeWNhby5uZXQ+iJMEExYKADsWIQSzG9JszGfWoByY\n"
   "TiVVn6gSLT/RCAUCZxMwhAIbAwULCQgHAgIiAgYVCgkICwIEFgIDAQIeBwIXgAAK\n"
   "CRBVn6gSLT/RCGXPAP4unILT7GwEc+jyFUq8bO2oCsJ4W5sPx+FhRIykiUBUIgD/\n"
   "QXTOUMNxtiLDm9j99Ap29t38NPbWwc3fm2rR4rxE9gu4OARnEzCEEgorBgEEAZdV\n"
   "AQUBAQdAeAqLhcpfk7HfuXoahJ7SziF6L5QDgivFgqRFboUrEh0DAQgHiHgEGBYK\n"
   "ACAWIQSzG9JszGfWoByYTiVVn6gSLT/RCAUCZxMwhAIbDAAKCRBVn6gSLT/RCI57\n"
   "AQCKn5bAiPyuccxrTKwvm1fQO3LfSFuwrvfD36eIFgCdjAD7BGievNhtK9iFDYol\n"
   "vbK7YhdXosgZsbHR4PbuQ5NtPAA=\n"
   "=envx\n"
   "-----END PGP PUBLIC KEY BLOCK-----\n"))

(define pgp-page
  (standalone-page
    (string->path "pgp.html")
    "PGP Key"
    #f
    (list
      `(article
         (h1 "PGP Key")
         (p "Email: " (a ([href "mailto:yi@ycao.net"]) "yi@ycao.net"))
         (p "Fingerprint: " (code "B31B D26C CC67 D6A0 1C98 4E25 559F A812 2D3F D108"))
         (p "Download public key: "
            (a ([href "/yi_public.asc"]) "ASCII armored asc file"))
         (pre (code ([class "language-plaintext"]) ,public-key))))))

(provide pgp-page)
