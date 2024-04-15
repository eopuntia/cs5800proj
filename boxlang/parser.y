/* PROLOGUE */  
%{
    #include <stdio.h>
    #include <string.h>
    #include "tokens.l"

    extern "C" int yyparse();
    int yylex(void);
    extern "C" void yyerror(char *s);
%}

%union {
    std::string *string;
    int token;
}

/* TERMINALS */
%token <string> TID TINT TDBL
%token <token> LPAR RPAR TCOMMA TQTE

// /* NON TERMINALS */
%type <string> sentence screens print write draw str color 
%type <token> time x y size

%%
/* GRAMMAR RULES */

sentence:                                  
    '(' screens ',' print ',' time ')'          { scr = $2; prnt = $4; dur = $6; }
|   '(' screens ',' print ')'                   { scr = $2; prnt = $4; dur = -1; }
|   '(' screens ',' sentence ',' time ')'       { scr = $2; prnt = $4; dur = $6; }
|   '(' screens ',' sentence ')'                { scr = $2; prnt = $4; dur = -1; }
;

screens: 
    '(' screens ')'                             { $$ = $2; }
|   screens ',' TINT                            { $$ = {$1, $3}; }
|   TINT                                        { $$ = $1; }
;

time: 
    TINT                                        { $$ = $1; }
;

print: 
    '(' print ')'                               { $$ = $2; }
|   '(' print ')' '(' draw ')'                  { $$ = {$2, $5}; }
|   '(' print ')' '(' write ')'                 { $$ = {$2, $5}; }
|   draw                                        { $$ = $1; }
|   write                                       { $$ = $1; }
;

write:
    'write' '(' '\"' str '\"' ',' size ',' color ')'     
                                                { $$ = write($4, $7, $9); }
|   'write' '(' '\"' str '\"' ',' size')'       { $$ = write($4, $7, "white"); }
|   'write' '(' '\"' str '\"' ',' color')'      { $$ = write($4, 24, $7); }
|   'write' '(' '\"' str '\"' ')'               { $$ = write($4, 24, "white");}
;

draw:
    'draw' '(' x ',' y ',' color ')'            { $$ = draw($3, $5, $7); }
|   'draw' '(' x ',' y ')'                      { $$ = draw($3, $5, "white"); }
;

str: 
    TID                                         { $$ = $1; }
;

x: 
    TINT                                        { $$ = $1; }
;

y: 
    TINT                                        { $$ = $1; }
;

size:
    TINT                                        { $$ = $1; }
;

color:
    TID                                         { $$ = $1; }
;

%%
/* EPILOGUE */
#include <ctype.h>
#include <stddef.h>

int
yylex (void)
{
  int c = getchar ();

  /* Ignore white space, get first nonwhite character. */
  while (c == ' ' || c == '\t')
    c = getchar ();

  if (c == EOF)
    return YYEOF;

  /* Char starts a number => parse the number. */
  if (c == '.' || isdigit (c))
    {
      ungetc (c, stdin);
      if (scanf ("%lf", &yylval.NUM) != 1)
        abort ();
      return NUM;
    }

  /* Char starts an identifier => read the name. */
  if (isalpha (c))
    {
      static ptrdiff_t bufsize = 0;
      static char *symbuf = 0;
      ptrdiff_t i = 0;
      do
        {
          /* If buffer is full, make it bigger. */
          if (bufsize <= i)
            {
              bufsize = 2 * bufsize + 40;
              symbuf = realloc (symbuf, (size_t) bufsize);
            }
          /* Add this character to the buffer. */
          symbuf[i++] = (char) c;
          /* Get another character. */
          c = getchar ();
        }
      while (isalnum (c));

      ungetc (c, stdin);
      symbuf[i] = '\0';

      symrec *s = getsym (symbuf);
      if (!s)
        s = putsym (symbuf, VAR);
      yylval.VAR = s; /* or yylval.FUN = s. */
      return s->type;
    }

  /* Any other character is a token by itself. */
  return c;
}

#include <stdio.h>

/* Called by yyparse on error. */
void
yyerror (char const *s)
{
  fprintf (stderr, "%s\n", s);
}

int main (void) {
    return yyparse ();
}