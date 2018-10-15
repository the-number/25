#! /usr/bin/env guile
   cons
   2018 (c) Gunter Liszewski
   SICP p91
!#
(define (cons a b)
"CONS -- from SICP p91"
  (define (dispatch c)
    (cond ((= 0 c) a)
          ((= 1 c) b)
          (else (error "not 0 or 1 -- CONS" c))))
  dispatch)

(define (car a) (a 0))
(define (cdr a) (a 1))
