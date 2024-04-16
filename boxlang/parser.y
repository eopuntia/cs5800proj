/* PROLOGUE */  
%{
    #include <stdio.h>
    extern int yyparse();
    extern void yyerror(char *s);
    extern int yylex (void);
    FILE *file;
%}


%union {
    char *string;
    int token;
}

%start sentence

/* TERMINALS */
%token <string> TID
%token <token> TINT
%token <string> TCOMMA TQTE LPAR RPAR WRITE DRAW

// /* NON TERMINALS */
%type <string> sentence print write draw str color 
%type <string> screens time x y size
%left TCOMMA
%left TQTE
%left LPAR RPAR WRITE DRAW

%%
/* GRAMMAR RULES */

sentence:                
   LPAR screens TCOMMA print TCOMMA time RPAR { 
        fprintf(file, "print with time!\n");
    }
|   LPAR screens TCOMMA print RPAR { 
        printf("print without time!\n"); }
|   LPAR screens TCOMMA sentence TCOMMA time RPAR       { printf("nested sentence with time!\n"); }
|   LPAR screens TCOMMA sentence RPAR                { printf("nested sentence without time!\n"); }
;

screens: 
    LPAR screens RPAR                             { printf("multiple screens\n"); }
|   screens TCOMMA TINT                            { printf("screens: %d\n", TINT); }
|   TINT                                        { printf("screen: %d\n", $1); }
;

time: 
    TINT                                        { printf("time: %d\n", TINT); }
;

print: 
    LPAR print RPAR                               { printf("nested print\n"); }
|   LPAR print RPAR LPAR draw RPAR                  { printf("print then draw\n"); }
|   LPAR print RPAR LPAR write RPAR                 { printf("print then write\n"); }
|   draw                                        { printf("draw\n"); }
|   write                                       { printf("write\n"); }
;

write:
    WRITE LPAR TQTE str TQTE TCOMMA size TCOMMA color RPAR { 
        printf("write with color\n"); 
    }
|   WRITE LPAR TQTE str TQTE TCOMMA size RPAR { 
        printf("write without color\n"); 
    }
|   WRITE LPAR TQTE str TQTE TCOMMA color RPAR { 
        printf("write with color but no size\n"); 
    }
|   WRITE LPAR TQTE str TQTE RPAR { 
        printf("default write\n") 
    }
;

draw:
    DRAW LPAR x TCOMMA y TCOMMA color RPAR { 
        printf("draw a dot in color\n"); 
    }
|   DRAW LPAR x TCOMMA y RPAR { 
        fprintf(file, "matrix.drawPixel(%d, %d, %s);\n", $3, $5, "white"); 
    }
;

str: 
    TID { 
        printf("string: %s\n", $1); 
    }
;

x: 
    TINT { 
        $$ = $1; 
    }
;

y: 
    TINT                                        { $$ = $1; }
;

size:
    TINT                                        { printf("size: %d\n", TINT); }
;

color:
    TID                                         { printf("color: %d\n", TID); }
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
    file = fopen("out.c", "w");
    fprintf(file, "void");
    yyparse();
    fclose(file);
}