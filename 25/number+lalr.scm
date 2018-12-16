#! /usr/bin/env guile

  number+lalr

  2018 (c) Gunter Liszewski

  Of the introduction of the semantics paper
    Scott and Strachey
!#

(use-modules (system base lalr))

(define lambda-parser
  (lalr-parser

;;; --- token

(#{\xa;}# *1 *0)

;;; --- grammar

(<input>         ()
                 (<input> <line>))

(<line>          (#{\xa;}#)
                 (<nu> #{\xa;}#)   : (format #t "~a~%" $1)
                 (error #{\xa;}#)  : (list 'recover $1 $2))

(<nu>            (*1)              : 1
                 (<nu> *0)         : (* 2 $1)
                 (<nu> *1)         : (+ (* 2 $1) 1))))

;;; --- lexer

(define (make-lexer e)
  (lambda ()
    (define (a b c)
      (cond ((eof-object? b) '*eoi*)              ; eof
            ((or (char=? b #\space) (char=? b #\tab))
             '*space)                             ; space
            ((char=? b #\0)
             '*0)                                 ; 0
            ((char=? b #\1)
             '*1)                                 ; 1
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

