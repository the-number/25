#! /usr/bin/env guile

  lambda-lalr

  2018 (c) Gunter Liszewski

  comprehension of these
    Church, Curry, Kleene, ... expressive terms
!#

(use-modules (system base lalr))

(define lambda-parser
  (lalr-parser

;;; --- token

(*left *right *lambda *v *prime)

;;; --- grammar

(<\-term>        (<variable>)
                 (<application>)
                 (<abstraction>))

(<variable>      (*v)
                 (<variable> *prime))

(<application>   (*left <\-term> <\-term> *right)

(<abstraction>   (*lambda <variable> <\-term> *right))))

;;; --- lexer

(define make-lexer e)
  (lambda ()
    (define (a b c)
      (cond ((eof-object? b) '*eoi*)              ; eof
            ((or (char=? b #\space) (char=? b #\tab))
             (a (read-char) b))                   ; skip space
            ((and (char=? c #\() (char=? b #\\)
             '*lambda))                           ; (\
            ((char=? b #\()
              '*left)                             ; (
            ((and (or (char=? c #\v) (char=? c #\'))
                  (char=? b #\'))
             '*prime)                             ; '
            ((char=? b #\v)
             '*v)                                 ; v
            ((char=? b #\))
             '*right)                             ; )
           (else
             (string->symbol (string b)))))
    (a (read-char) #\space)))

;;; --- errors

(define e
  (lambda (a . b)
    (define c (lambda (a) (display a (current-error-port))))
    (c a)
    (for-each c b)
    (newline)))

;;; --- control

(define start
  (lambda ()
    (\-term-parser (make-lexer e) e)))

(start)

