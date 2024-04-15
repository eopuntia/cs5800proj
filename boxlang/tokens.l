%{
#include <string>
#define SAVE_TOKEN yylval.string = new std::string(yytext, yyleng)
#define TOKEN(t) (yylval.token = t)
extern "C" int yywrap() { }
%}

%%

[ \t\n]                 ;
[a-zA-Z_][a-zA-Z0-9_]*  SAVE_TOKEN; return TID;
[0-9]+                  SAVE_TOKEN; return TINT;
"\""                    return TOKEN(TQTE);
","                     return TOKEN(TCOMMA);
"("                     return TOKEN(LPAR);
")"                     return TOKEN(RPAR);
.                       printf("Unknown token!n"); yyterminate();

%%

int main() {
    yylex();
}