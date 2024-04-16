
%{
    #include "parser.tab.c"
    extern int yylex();
%}

%%
[ \t\n]                 ;
"write"                 { return WRITE; }
"draw"                  { return DRAW; }
[a-zA-Z_][a-zA-Z0-9_]+  { yylval = yytext; return TID;}
[0-9]+                  { yylval = atoi(yytext); return TINT; }
"\""                    { return TQTE; }
","                     { return TCOMMA; }
"("                     { return LPAR; }
")"                     { return RPAR; }
.                       { printf("Unknown token!n"); yyterminate(); }

%%

