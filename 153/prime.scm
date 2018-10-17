#! /usr/bin/env guile
  prime?
  2018 (c) Gunter Liszewski
!#

(define (prime? a)
  (= (smallest-divisor a) a))

(define (smallest-divisor a)
  (find-divisor a 2))

(define (find-divisor a test-divisor)
  (cond ((> test-divisor a) a)
        ((divides? test-divisor a) test-divisor)
        (else (find-divisor a
                            (+ test-divisor 1)))))

(define (divides? a b)
  (= (remainder b a) 0))
