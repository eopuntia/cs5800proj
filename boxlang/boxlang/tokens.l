%{
    #include "parser.tab.c"
    extern int yylex();
    int count = 0;
%}

%%
[ \t\n]                 ;
[a-zA-Z_][a-zA-Z0-9_]*  { printf("character"); return TID;}
[0-9]+                  { printf("digig\n"); return TINT; }
"\""                    { count++; return TQTE; }
","                     { count++; return TCOMMA; }
"("                     { count++; return LPAR; }
")"                     { count++; return RPAR; }
.                       { printf("Unknown token!n"); yyterminate(); }

%%

