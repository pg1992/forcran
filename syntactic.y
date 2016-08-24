%{
	#include <stdio.h>
%}

%token NUMBER
%token PLUS MINUS TIMES DIVIDE POWER
%token OPEN_PARENS CLOSE_PARENS
%token COMMENT
%token OPEN_BRACKET CLOSE_BRACKET
%token VAR_DEF_SEPARATOR
%token COMMA


%%
	Input:
		/* Empty */
		
%%

int main(void){
	yyparse();
}

