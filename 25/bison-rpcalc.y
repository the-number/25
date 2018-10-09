
/* bison-rpcalc example from (info bison) 2.1.1 */

%{
  #define YYSTYPE double
  #include <math.h>
  int yylex (void);
  void yyerror (char const *);
%}

%token NUM

%% /* Grammar, semantics */

input:
  /* empty */
| input line
;

line:
  '\n'
| exp '\n'       { printf ("%.10g\n", $1); }
;

exp:
 NUM             { $$ = $1; }
| exp exp '+'    { $$ = $1 + $2; }
| exp exp '-'    { $$ = $1 - $2; }
| exp exp '*'    { $$ = $1 * $2; }
| exp exp '/'    { $$ = $1 / $2; }
| exp exp '^'    { $$ = pow ($1,$2); }
| exp 'n'        { $$ = -$1; }
;
%%
