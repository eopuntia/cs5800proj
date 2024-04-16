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
    char delim; 
    int token;
}

%start sentence

/* TERMINALS */
%token <string> TID
%token <token> TINT
%token <delim> TCOMMA TQTE LPAR RPAR
%token <string> WRITE DRAW

// /* NON TERMINALS */
%type <string> sentence print write draw str color screens
%type <token> time x y size
%left TCOMMA
%left TQTE
%left LPAR RPAR WRITE DRAW

%%
/* GRAMMAR RULES */

sentence:                
   LPAR screens TCOMMA print TCOMMA time RPAR {         // with time specified (in seconds)
        fprintf(file, "offset = %s\n", $2);
        fprintf(file, "wait(%d)\n", $6);
        fprintf(file, "matrix.fillscreen(0);\n");
    }
|   LPAR screens TCOMMA print RPAR {                    // without time specified
        fprintf(file, "offset = %s\n", $2);             // TODO: allow for indefinite looping
    }
|   LPAR screens TCOMMA sentence TCOMMA time RPAR {     // with time specified, nested
        fprintf(file, "offset = %s\n", $2);             // TODO: make sure nesting works
        fprintf(file, "delay(%d)\n", $6);
        fprintf(file, "matrix.fillscreen(0);\n");
    }
|   LPAR screens TCOMMA sentence RPAR {                 // without time specified, nested
        fprintf(file, "offset = %s\n", $2);             // TODO: make sure nesting works
    }                                                   // TODO: allow for indefinite looping
;

screens:                    // TODO: allow for multiple screens 
    LPAR screens RPAR { 
        fprintf(file, "(%s)\n", $2);
    }
|   screens TCOMMA TINT { 
        char *tmp;
        sprintf(tmp, "%s, %d", $1, ($3-1)*64);
        $$ = tmp
    }
|   TINT  { 
        char *tmp;
        sprintf(tmp, "%d", ($1-1)*64);
        $$ = tmp;
    }
;

time: 
    TINT { 
        $$ = $1 * 1000;     // convert seconds to milliseconds
    }
;

print: 
    LPAR print RPAR { ; }
|   LPAR print RPAR LPAR draw RPAR { ; }
|   LPAR print RPAR LPAR write RPAR { ; }
|   draw { ; }
|   write { ; }
;

write:
    WRITE LPAR TQTE str TQTE TCOMMA size TCOMMA color RPAR { 
        fprintf(file, "setTextColor(%s);\n", $9);
        fprintf(file, "setTextSize(%d);\n", $7);  
        fprintf(file, "matrix.println(%s);\n", $4); 
    }
|   WRITE LPAR TQTE str TQTE TCOMMA size RPAR {         // no color 
        fprintf(file, "setTextSize(%d);\n", $7);  
        fprintf(file, "matrix.println(%s);\n", $4); 
    }
|   WRITE LPAR TQTE str TQTE TCOMMA color RPAR {        // no size 
        fprintf(file, "setTextColor(%s);\n", $7);  
        fprintf(file, "matrix.println(%s);\n", $4); 
    }
|   WRITE LPAR TQTE str TQTE RPAR {                     // no color or size
        fprintf(file, "matrix.println(%s);\n", $4); 
        //printf("1: %s\n", $1);
        //printf("2: %s\n", $2);
        //printf("3: %s\n", $3);
        printf("4: %s\n", $4);
        printf("5: %c\n", $5);
        printf("6: %c\n", $6);
    }
;

draw:
    DRAW LPAR x TCOMMA y TCOMMA color RPAR { 
        fprintf(file, "matrix.drawPixel(%d, %d, %s);\n", $3, $5, $7);
        printf("%s\n", $7);
    }
|   DRAW LPAR x TCOMMA y RPAR {                         // no color
        fprintf(file, "matrix.drawPixel(%d, %d, %s);\n", $3, $5, "white");
    }
;

str: 
    TID { $$ = $1; printf("%s\n", $1);}
;

x: 
    TINT { $$ = $1; }
;

y: 
    TINT { $$ = $1; }                                  
;

size:
    TINT { $$ = $1; }                                  
;

color:
    TID { $$ = $1; printf("%s\n", $1);}
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
    fprintf(file, "void prog(void) {\n\tmatrix.fillScreen(0);\n");
    yyparse();
    fprintf(file, "}");
    fclose(file);
}