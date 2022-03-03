%{
	#include <stdio.h>
	#include <math.h>
	#include "y.tab.h"
	int yywrap(void){
		return 1;
	}
%}
%%
"+" return ADD;
"-" return SUB;
"*" return MUL;
"/" return DIV;
"%" return MOD;
"\n" return CR;
"(" return LB;
")" return RB;
"^" return MI;
"q" return QUIT;
(([1-9][0-9]*)|0|([0-9]\.+[0-9]+)) {
	double temp;
	sscanf(yytext, "%lf", &temp);
	yylval.double_value = temp;
	return DOUBLE_LITERAL;
	}
[\t];
. {
	fprintf(stderr, "ERROR!\n");
	exit(1);
	}

%%
