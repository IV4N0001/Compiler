%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"

int yylineno = 1;
char* yytext_copy;

int yylex();
int yyerror(const char *message);
%}

%option noyywrap

%%

"\n"                        { yylineno++; }
[ \t""]+                    ;
"sqrt"                      { return SQRT; }
"prnt"                      { yylval.str = strdup(yytext); return PRNT; }
"NUM_TYPE"                  { return NUM_TYPE; }
"STR_TYPE"                  { return STR_TYPE; }
[A-Za-z][A-Za-z0-9_]*       { return IDENTIFIER; }
[0-9]+\.[0-9]*              { yylval.num_double = atof(yytext); return NUMBER; }
[0-9]+                      { yylval.num_double = atof(yytext); return NUMBER; }
[-+*/\|\%\(\)\n]            { return *yytext; }
[<]{2}                      { return STR_SHIFT_LEFT; }
"**"                        { return STR_POW; }
;                           { return ';'; }
=                           { return '='; }
\"(\\.|[^\"])*\"            {
                                int i, j;
                                yylval.str = malloc(yyleng); // Asignamos suficiente memoria para la cadena
                                for (i = 1, j = 0; i < yyleng - 1; ++i) {
                                    if (yytext[i] == '\\' && i + 1 < yyleng - 1) {
                                        switch (yytext[i + 1]) {
                                            case 'n':
                                                yylval.str[j++] = '\n';
                                                break;
                                            // Puedes agregar más casos para otros caracteres de escape según sea necesario
                                            default:
                                                yylval.str[j++] = yytext[i + 1];
                                                break;
                                        }
                                        ++i; // Saltamos el siguiente carácter, ya que lo hemos procesado
                                    } else {
                                        yylval.str[j++] = yytext[i];
                                    }
                                }
                                yylval.str[j] = '\0'; // Terminamos la cadena con el carácter nulo
                                return STRING_CONSTANT;
                            }
.                           { yylineno++; yytext_copy = strdup(yytext); yyerror("Unexpected token"); }

%%

void showError() {
    printf("\n    <<LEXICAL_ERROR: \"%s\" AT LINE: %d>>", yytext_copy, yylineno);
    //free(yytext_copy);
}