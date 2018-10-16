#! /usr/bin/env guile
  amb
  from SICP amb, require
  2018 (c) Gunter Liszewski
!#

(define *f* #f)

(define-syntax abc
  (syntax-rules ()
    ((abc) (*f*))
    ((abc ?a) ?a)
    ((abc ?a ?b)
      (let ((c *f*))
        ((call/cc 
           (lambda (d)
             (set! *f*
               (lambda ()
                 (set! *f* c)
                 (d (lambda () ?b))))
             (lambda () ?a))))))
    ((abc ?a ?e ...)
      (abc ?a (abc ?e ...)))))

(list (abc 'noun 'hauptwort 'nomen) (abc 'verb 'tatwort 'the-verb))
