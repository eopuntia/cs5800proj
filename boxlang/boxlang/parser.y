/* PROLOGUE */  
%{
    #include <stdio.h>
    int yyparse();
    void yyerror(char *s);
    int yylex (void);
%}


%union {
    char *string;
    int token;
}

%start sentence

/* TERMINALS */
%token <string> TID TINT TDBL
%token <token> LPAR RPAR TCOMMA TQTE

// /* NON TERMINALS */
%type <string> sentence print write draw str color 
%type <token> screens time x y size

%%
/* GRAMMAR RULES */

sentence:                                  
    '(' screens ',' print ',' time ')' { 
        printf("sentence!\n");
    }
|   '(' screens ',' print ')' { 
        printf("sentence!\n"); }
|   '(' screens ',' sentence ',' time ')'       { printf("sentence!\n"); }
|   '(' screens ',' sentence ')'                { printf("sentence!\n"); }
;

screens: 
    '(' screens ')'                             { printf("screens!\n"); }
|   screens ',' TINT                            { printf("sentence!\n"); }
|   TINT                                        { printf("sentence!\n"); }
;

time: 
    TINT                                        { printf("sentence!\n"); }
;

print: 
    '(' print ')'                               { printf("sentence!\n"); }
|   '(' print ')' '(' draw ')'                  { printf("sentence!\n"); }
|   '(' print ')' '(' write ')'                 { printf("sentence!\n"); }
|   draw                                        { printf("sentence!\n"); }
|   write                                       { printf("sentence!\n"); }
;

write:
    'write' '(' '\"' str '\"' ',' size ',' color ')' { printf("sentence!\n"); }
|   'write' '(' '\"' str '\"' ',' size')'       { printf("sentence!\n"); }
|   'write' '(' '\"' str '\"' ',' color')'      { printf("sentence!\n"); }
|   'write' '(' '\"' str '\"' ')'               { printf("sentence!\n"); }
;

draw:
    'draw' '(' x ',' y ',' color ')'            { printf("sentence!\n"); }
|   'draw' '(' x ',' y ')'                      { printf("sentence!\n"); }
;

str: 
    TID                                         { printf("sentence!\n"); }
;

x: 
    TINT                                        { printf("sentence!\n"); }
;

y: 
    TINT                                        { printf("sentence!\n"); }
;

size:
    TINT                                        { printf("sentence!\n"); }
;

color:
    TID                                         { printf("sentence!\n"); }
;

%%
/* EPILOGUE */
#include <ctype.h>
#include <stddef.h>

/* Called by yyparse on error. */
void yyerror (char *s) {
  printf (stderr, "%s\n", s);
}

