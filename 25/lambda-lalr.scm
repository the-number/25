#! /usr/bin/env guile
  lambda-lalr
  2018 (c) Gunter Liszewski
  Church, Curry, Kleene, ... expressive terms
!#

(use-modules (system base lalr))

(define lambda-parser
  (lalr-parser

;;; --- token

(*( *) *(\ *v *')

;;; --- grammar

(<\-term>)       (<variable>)
                 (<application>)
                 (<abstraction>)))
(<variable>)     (*v)
                 (*v *')))
(<application>)  (*( <\-term> <\-term> *)))
(<abstraction>)  (*(\ <variable> <\-term>)))

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
            ((and (char=? c #\') (char=? b #\v))
             '#\'))                               ; prime
            ((char=? b #\v)
             '*v)                                 ; v
            ((char=? b #\))
             '*))                                 ; )
    (a (read-char) #\space)))

;;; --- errors

;;; --- control

