/* PROLOGUE */  
%{
    #include <stdio.h>
    extern int yyparse();
    extern void yyerror(char *s);
    extern int yylex (void);
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
   LPAR screens TCOMMA print TCOMMA time RPAR { 
        printf("sentence!\n");
    }
|   LPAR screens TCOMMA print RPAR { 
        printf("sentence!\n"); }
|   LPAR screens TCOMMA sentence TCOMMA time RPAR       { printf("sentence!\n"); }
|   LPAR screens TCOMMA sentence RPAR                { printf("sentence!\n"); }
;

screens: 
    LPAR screens RPAR                             { printf("screens!\n"); }
|   screens TCOMMA TINT                            { printf("sentence!\n"); }
|   TINT                                        { printf("sentence!\n"); }
;

time: 
    TINT                                        { printf("sentence!\n"); }
;

print: 
    LPAR print RPAR                               { printf("sentence!\n"); }
|   LPAR print RPAR LPAR draw RPAR                  { printf("sentence!\n"); }
|   LPAR print RPAR LPAR write RPAR                 { printf("sentence!\n"); }
|   draw                                        { printf("sentence!\n"); }
|   write                                       { printf("sentence!\n"); }
;

write:
    'write' LPAR TQTE str TQTE TCOMMA size TCOMMA color RPAR { printf("sentence!\n"); }
|   'write' LPAR TQTE str TQTE TCOMMA size RPAR       { printf("sentence!\n"); }
|   'write' LPAR TQTE str TQTE TCOMMA color RPAR      { printf("sentence!\n"); }
|   'write' LPAR TQTE str TQTE RPAR               { printf("sentence!\n"); }
;

draw:
    'draw' LPAR x TCOMMA y TCOMMA color RPAR            { printf("sentence!\n"); }
|   'draw' LPAR x TCOMMA y RPAR                      { printf("sentence!\n"); }
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
  fprintf (stderr, "%s\n", s);
}

int main () {
    yyparse();
}