#!
  bison-rpcalc example from (info bison 2.1.1) 

  2018 (c) Gunter Liszewski

  models for this, for example:
   info bison 2.1.1
   lalr-scm/calc.scm
   dynamo.iro.umontreal.ca/wiki/index.php/Lalr-example

!#

(define bison-rpcalc-parser
  (lalr-parser

;;; --- token

(NUM #{\xa;}# + - * / ^ n)

;;; --- grammar, semantics

(<input>   ()
           (<input> <line>))

(<line>    (#{\xa;}#)
           (<exp> #{\xa;}#) : (format #t "~a~%" $1))

(<exp>     (NUM)            : $1
           (<exp> <exp> +)  : (+ $1 $2)
           (<exp> <exp> -)  : (- $1 $2)
           (<exp> <exp> *)  : (* $1 $2)
           (<exp> <exp> /)  : (/ $1 $2)
           (<exp> <exp> ^)  : (expt $1 $2)
           (<exp> n)        : (- $1))))

;;; --- lexer

(define (make-lexer e)
 (lambda ()
   (define (a b)
     (cond ((eof-object? b) '*eoi*)              ; eof
           ((or (char=? b #\space) (char=? b #\tab))
            (a (read-char)))                     ; skip spaces
           ((or (char-numeric? b) (char=? b #\.))
            (unread-char b)
            (make-lexical-token 'NUM #f (read))) ; number
           (else
             (string->symbol (string b)))))      ; operator, with trust or hope
   (a (read-char))))

;;; --- errors

(define e
  (lambda (a . b)
    (define c (lambda (a) (display a (current-error-port))))
    (c a)
    (for-each c b)
    (newline)))

;;; --- control
