%{
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>

extern int yylineno;
extern char* yytext;
char line[256];
char* current_line;

int yyerror(const char *message);
int yylex();
int yy_scan_string(const char *str);

int yyerror(const char *message) {
    fprintf(stderr, "\n     <<\"%s\"; line: %d; content: %s", message, yylineno, current_line);
    return 0;
}

%}

%union {
    double num;
    char* str;
}

%token IDENTIFIER
%token PRNT
%token <str> STRING_CONSTANT
%token <num> NUMBER
%token NUM_TYPE STR_TYPE
%token SQRT
%token STR_POW
%token STR_SHIFT_LEFT
%token OTHER

%type <num> expression term factor
%type <str> prnt_argument

%error-verbose

%start program

%%

program:
    program instructions
    | error '\n'    
    | /* empty */
    ;

instructions:
    declaration
    | prnt_statement
    ;

declaration:
    NUM_TYPE IDENTIFIER '=' expression ';'
    | STR_TYPE IDENTIFIER '=' STRING_CONSTANT ';' //HORAS PERDIDAS EN ESTA VAINA: 12 O MAS . . . Y CONTANDO
    ;
    
expression:
    expression '+' term        { $$ = $1 + $3; }
    | expression '-' term      { $$ = $1 - $3; }
    | term
    ;

term:
    term '*' factor           { $$ = $1 * $3; }
    | term '/' factor         { $$ = $1 / $3; }
    | term '%' factor         { $$ = fmod($1, $3); }
    | term STR_SHIFT_LEFT factor { $$ = (int)$1 << (int)$3; }
    | factor
    ;

factor:
    NUMBER                   { $$ = $1; }
    | '-' factor %prec UMINUS { $$ = -$2; }
    | '(' expression ')'     { $$ = $2; }
    | '|' expression '|'     { $$ = (int)fabs($2); }
    | SQRT '(' expression ')' { $$ = sqrt($3); }
    | NUMBER STR_POW factor   { $$ = pow($1, $3); }
    ;

prnt_statement:
    PRNT '(' prnt_argument ')' ';'  { printf("%s", $3); }
    ;

prnt_argument:
    STRING_CONSTANT   //{ $$ = strdup($1); free($1); }
    | STRING_CONSTANT ',' IDENTIFIER //{ $$ = strdup($1); free($1); }  // También aquí asignamos solo la cadena
    ;


%%

int main(int argc, char* argv[]) {
    FILE* file = fopen(argv[1], "r");

    while (fgets(line, sizeof(line), file)) {
        current_line = strdup(line);
        yy_scan_string(line);
        yyparse();
        free(current_line);
    }

    fclose(file);

    return 0;
}
