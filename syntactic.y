%{
	#include <stdio.h>
%}

%token NUMBER
%token PLUS MINUS TIMES DIVIDE POWER
%token EQUAL
%token OPEN_PARENS CLOSE_PARENS
%token OPEN_BRACKET CLOSE_BRACKET
%token COMMENT
%token VAR_DEF_SEPARATOR
%token COMMA
%token IMPLICIT NONE PARAMETER
%token READ_COMMAND WRITE_COMMAND
%token PROGRAM_KEYWORD END_KEYWORD
%token INTEGER_KEYWORD REAL_KEYWORD
%token INT_NUM REAL_NUM
%token IDENTIFIER STRING


%%
	Input:
		/* Empty */
		
%%

int yyerror(char *s){
	printf("%s\n", s);
}

int main(void){
	yyparse();
}

