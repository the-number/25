
/* bison-rpcalc example from (info bison) 2.1.1 */

%{
  #define YYSTYPE double
  #include <math.h>
  int yylex (void);
  void yyerror (char const *);
%}

%token NUM

%% /* Grammar, semantics */

;;; --- syntax rules
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

