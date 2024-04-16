%option noyywrap
%{
    #include "parser.tab.h"
%}

%%
[ \t\n]                 ;
"write"                 { return WRITE; }
"draw"                  { return DRAW; }
[a-zA-Z_][a-zA-Z0-9_]+    { yylval.string = yytext; return TID; }                 // TODO: allow for whitespace and non alphanumeric characters in strings
[0-9]+                  { yylval.token = atoi(yytext); return TINT; }
\"[^"]*\"   		{ 
	yylval.string = strdup(yytext+1);
	yylval.string[strlen(yylval.string)-1] = '\0';
	return STR; 
}
","                     { return TCOMMA; }
"("                     { return LPAR; }
")"                     { return RPAR; }
.                       { printf("Unknown token!n"); yyterminate(); }

%%

