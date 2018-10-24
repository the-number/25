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

(#{\xa;}# *left *right *lambda *v *prime)

;;; --- grammar

(<input>         ()
                 (<input> <line>))

(<line>          (#{\xa;}#)
                 (<term> #{\xa;}#) : (format #t "~a~%" "ok")
                 (error #{\xa;}#)   : (list 'recover $1 $2))

(<term>          (<variable>)
                 (<application>)
                 (<abstraction>))

(<variable>      (*v)
                 (<variable> *prime))

(<application>   (*left <term> <term> *right))

(<abstraction>   (*left *lambda <variable> <term> *right))))

;;; --- lexer

(define (make-lexer e)
  (lambda ()
    (define (a b c)
      (cond ((eof-object? b) '*eoi*)              ; eof
            ((or (char=? b #\space) (char=? b #\tab))
             (a (read-char) b))                   ; skip space
            ((char=? b #\\)
             '*lambda)                            ; \
            ((char=? b #\()
              '*left)                             ; (
            ((char=? b #\')
             '*prime)                             ; '
            ((char=? b #\v)
             '*v)                                 ; v
            ((char=? b #\))
             '*right)                             ; )
            ((char=? b #\newline)
             '#{\xa;}#)                           ; new line
            (else
             (e "SCAN error : " b)
	     (a (read-char) #\space))))
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
    (drain-input (current-input-port))
    (lambda-parser (make-lexer e) e)))

(start)

