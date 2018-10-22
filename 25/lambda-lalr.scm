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

