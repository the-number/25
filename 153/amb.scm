#! /usr/bin/env guile
  amb
!#
 (define (*failure*) (error "Failure"))

 (define-syntax amb
  (syntax-rules ()
  ((amb) (*failure*))
  ((amb ?x) ?x)
  ((amb ?x ?y)
  (let ((old-failure *failure*))
  ((call-with-current-continuation
    (lambda (cc)
    (set! *failure* 
      (lambda () 
      (set! *failure* old-failure)
      (cc (lambda () ?y))))
    (lambda () ?x))))))
  ((amb ?x ?rest ...)
  (amb ?x (amb ?rest ...)))))
