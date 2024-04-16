%{
#include "parser.tab.c"
int yylex();
int count = 0;
%}

%%

[ \t\n]                 ;
[a-zA-Z_][a-zA-Z0-9_]*  { count++; return TID; }
[0-9]+                  { count++; return TINT; }
"\""                    { count++; return TQTE; }
","                     { count++; return TCOMMA; }
"("                     { count++; return LPAR; }
")"                     { count++; return RPAR; }
.                       { printf("Unknown token!n"); yyterminate(); }

%%

int main () {
    yylex();
}