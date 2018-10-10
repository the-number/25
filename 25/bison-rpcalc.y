
/* bison-rpcalc example from (info bison) 2.1.1 */

%{
  #define YYSTYPE double
  #include <stdio.h>
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

%% /* Lexer */

#include <ctype.h>

int
yylex (void)
{
  int c;

  while ( (c=getchar()) == ' ' || c == '\t' )
    {
      continue;
    }
  if ( c == '.' || isdigit (c) )
    {
      ungetc (c, stdin);
      scanf ("%lf", &yylval);
      return NUM;
    }
  if ( c == EOF )
    {
      return 0;
    }
  return c;
}


/* (info bison 2.1.4) The controller */

int
main (void)
{
  return yyparse ();
}

/* (info bison 2.1.6) in error */

void
yyerror (char const *s)
{
  fprintf (stderr, "%s\n", s);
}

