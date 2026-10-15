#!/usr/bin/env racket
#lang racket/base

;;;; (re)generates LLM translations under content/translations/ through an
;;;; OpenAI-compatible chat completions endpoint, overwriting existing ones.
;;;;   ./regen-trans.rkt <post-slug> ...   translate these posts
;;;;   ./regen-trans.rkt                   regenerate every existing translation
;;;; env: LLM_BASE_URL (e.g. https://api.openai.com/v1), LLM_API_KEY, LLM_MODEL

(require file/glob
         json
         net/url
         net/url-connect
         racket/cmdline
         racket/file
         racket/path
         racket/runtime-path
         racket/string
         ycao-net/lib/document)

(define-runtime-path posts-dir "content/posts")
(define-runtime-path translations-dir "content/translations")

;; prompt templates; ~a is the post's source
(define prompt-template-en->cn #<<EOF
将下面的博客文章从英文翻译成简体中文。它是一个使用 at-exp 标记的 Racket 源文件。
只翻译供人阅读的文字，其余内容一律原样保留，包括所有 @ 形式的名称、标题 id、
引用键、公式标签、URL、数学公式、代码和原始 HTML。
在 @article 形式中，于日期之后添加 #:lang "zh"。
只回复翻译后的完整文件，不要用 Markdown 代码块包裹。
翻译在**不曲解原意的情况下**尽量避免汉语欧化。

~a
EOF
  )

(define prompt-template-cn->en #<<EOF
Translate the blog post below from Simplified Chinese into English. It is a Racket source file using at-exp markup.
Translate only the human-readable text. Keep everything else exactly as it is, including all @-form
names, heading ids, citation keys, equation labels, URLs, math, code, and raw HTML.
In the @article form, remove #:lang "zh".
Reply with the complete translated file only, without Markdown code fences.
Translation should cater for English writing conventions as much as possible WITHOUT ALTERING ORIGINAL
INTENTION AND MEANING.

~a
EOF
  )

(define (env name)
  (or (getenv name) (error 'regen-trans "~a is not set" name)))

;; one non-streaming chat completion; returns the reply text
(define (complete prompt)
  (define in
    (parameterize ([current-https-protocol 'secure])
      (post-pure-port
        (string->url (string-append (string-trim (env "LLM_BASE_URL") "/" #:left? #f)
                                    "/chat/completions"))
        (jsexpr->bytes (hasheq 'model (env "LLM_MODEL")
                               'messages (list (hasheq 'role "user" 'content prompt))))
        (list "Content-Type: application/json"
              (string-append "Authorization: Bearer " (env "LLM_API_KEY"))))))
  (define resp (read-json in))
  (close-input-port in)
  (define choices (and (hash? resp) (hash-ref resp 'choices #f)))
  (define choice (and (pair? choices) (car choices)))
  ;; anything but a finished reply (an API error, a truncated output) is fatal
  (unless (and choice (equal? (hash-ref choice 'finish_reason #f) "stop"))
    (error 'regen-trans "unexpected response: ~s" resp))
  (hash-ref (hash-ref choice 'message) 'content))

;; the model may still wrap the file in a Markdown fence
(define (strip-fence s)
  (cond [(regexp-match #px"^\\s*```[^\n]*\n(.*?)```\\s*$" s) => cadr]
        [else s]))

(define (regen slug)
  (define src (build-path posts-dir (string-append slug ".rkt")))
  (define-values (target template)
    (if (equal? (article-lang (dynamic-require src 'post)) "zh")
        (values "en" prompt-template-cn->en)
        (values "zh" prompt-template-en->cn)))
  (printf "Translating ~a into ~a\n" slug target)
  (define text (complete (format template (file->string src))))
  (make-directory* translations-dir)
  (display-to-file (strip-fence text)
                   (build-path translations-dir (string-append slug ".rkt"))
                   #:exists 'replace))

(module+ main
  (define slugs
    (command-line
      #:program "regen-trans"
      #:args slugs
      (if (null? slugs)
          (for/list ([p (in-list (glob (build-path translations-dir "*.rkt")))])
            (path->string (path-replace-extension (file-name-from-path p) #"")))
          slugs)))
  (for-each regen slugs))
