#! /usr/bin/env guile
  lambda-parser
  2018 (c) Gunter Liszewski
  Church, Curry, Kleene, ... expressive terms
!#

(use-modules (system base lalr))

(define lambda-parser
  (lalr-parser

;;; --- token

(*( *) *(\ *v *')

;;; --- grammar

(<\-term>        (<variable>)
                 (<application>)
                 (<abstraction>))

(<variable>      (*v)
                 (<variable> *'))

(<application>   (*( <\-term> <\-term> *))

(<abstraction>   (*(\ <variable> <\-term>))))

;;; --- lexer

(define make-lexer e)
  (lambda ()
    (define (a b c)
      (cond ((eof-object? b) '*eoi*)              ; eof
            ((or (char=? b #\space) (char=? b #\tab))
             (a (read-char) b))                   ; skip space
            ((and (char=? c #\() (char=? b #\\)
             '*(\))                               ; (\
            ((char=? b #\()
              '*())                               ; (
            ((and (or (char=? c #\v) (char=? c #\'))
                  (char=? b #\'))
             '#\')                                ; prime
            ((char=? b #\v)
             '*v)                                 ; v
            ((char=? b #\))
             '*))                                 ; )
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

