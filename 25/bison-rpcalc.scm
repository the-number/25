
/* bison-rpcalc example from (info bison) 2.1.1 */


;;; --- token
(NUM)

;;; --- grammar, semantics
(<input>   ()
           (<input> <line>))

(<line>    (#\newline)
           (<exp> #\newline) : (format #t "~a~%" $1))

(<exp>     (NUM)             : $1
           (<exp> <exp> #\+) : (+ $1 $2)
           (<exp> <exp> #\-) : (- $1 $2)
           (<exp> <exp> #\*) : (* $1 $2)
           (<exp> <exp> #\/) : (/ $1 $2)
           (<exp> <exp> #\^) : (expt $1 $2)
           (<exp> #\-)       : (- $1))

