%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#define YYDEBUG 1
int yylex();
int yyerror(const char *str);
%}
%union {
    int int_value;
    double double_value;
}
%token <double_value> DOUBLE_LITERAL
%token ADD SUB MUL DIV MOD CR LB RB MI QUIT
%type <double_value> expression term hah primary_expression
%%
line_list
    : line
    | line_list line;
line
    : expression CR
    {
        printf("\e[32m[calc-result]>>\e[0m \e[36m%lf\e[0m\n", $1);
    };
expression
    : term
    | expression ADD term
    {
        $$ = $1 + $3;
    }
    | expression SUB term
    {
        $$ = $1 - $3;
    };

term
    : hah
    | term MUL hah
    {
        $$ = $1 * $3;
    }
    | term DIV hah
    {
        $$ = $1 / $3;
    }
	| term MOD hah
	{
		$$ = (int)$1 % (int)$3;
	};

hah
	: primary_expression
	| hah MI primary_expression
	{
		$$ = pow($1, $3);
	}
	| SUB primary_expression
	{
		$$ = -$2;
	};

primary_expression
    : DOUBLE_LITERAL
	| LB expression RB
	{
		$$ = $2;
	}
	| QUIT
	{
		printf("Thanks for using!\n");
		exit(0);
	}
	;
%%
int yyerror(char const *str) {
    extern char *yytext;
    fprintf(stderr, "\e[31m Syntax ERROR: %s\e[0m\n", yytext);
    return 0;
}

int main() {
    extern int yyparse(void);
    extern FILE * yyin;
    yyin = stdin;
    if(yyparse()) {
        fprintf(stderr, "\e[31m ERROR！\e[0m\n");
        //exit(1);
    }
}
