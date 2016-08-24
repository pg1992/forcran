%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "syntactic.tab.h"
%}

WHITE [\t\n ]
LETTER [a-z]
DIGIT [0-9]
NUMBER [0-9]+
SIGN ("+"|"-")?
INTEGER {SIGN}{NUMBER}
REAL {SIGN}{NUMBER}+"."{NUMBER}(e{SIGN}?{NUMBER})?

%%

{WHITE} {}

"!"([^\n])*\n {
	yytext[strlen(yytext)-1] = 0;
	printf("'%s' : COMMENT\n", yytext);
	return COMMENT;
}

"(" {
	printf("'%s' : OPEN_PARENS\n", yytext);
	return OPEN_PARENS;
}

")" {
	printf("'%s' : CLOSE_PARENS\n", yytext);
	return CLOSE_PARENS;
}

"{" {
	printf("'%s' : OPEN_BRACKET\n", yytext);
	return OPEN_BRACKET;
}

"}" {
	printf("'%s' : CLOSE_BRACKET\n", yytext);
	return CLOSE_BRACKET;
}

"::" {
	printf("'%s' : VAR_DEF_SEPARATOR\n", yytext);
	return VAR_DEF_SEPARATOR;
}

"," {
	printf("'%s' : COMMA\n", yytext);
	return COMMA;
}

"**" {
	printf("'%s' : POWER\n", yytext);
	return POWER;
}

"*" {
	printf("'%s' : TIMES\n", yytext);
	return TIMES;
}

"+" {
	printf("'%s' : PLUS\n", yytext);
	return PLUS;
}

"-" {
	printf("'%s' : MINUS\n", yytext);
}

"/" {
	printf("'%s' : SLASH\n", yytext);
}

"^" {
	printf("'%s' : POWER\n", yytext);
}

"=" {
	printf("'%s' : EQUAL\n", yytext);
}

"'"([^'\n])*"'" {
	yytext = yytext + 1;
	yytext[strlen(yytext)-1] = 0;
	printf("'%s' : STRING\n", yytext);
}

"implicit" {
	printf("'%s' : IMPLICIT\n", yytext);
}

"none" {
	printf("'%s' : NONE\n", yytext);
}

"parameter" {
	printf("'%s' : PARAMETER\n", yytext);
}

"write" {
	printf("'%s' : WRITE_COMMAND\n", yytext);
}

"read" {
	printf("'%s' : READ_COMMAND\n", yytext);
}

"real" {
	printf("'%s' : REAL_KEYWORD\n", yytext);
}

"program" {
	printf("'%s' : PROGRAM_KEYWORD\n", yytext);
}

"end" {
	printf("%s : END_KEYWORD\n", yytext);
}
"integer" {
	printf("'%s' : INTEGER_KEYWORD\n", yytext);
}

{REAL} {
	printf("'%.5g' : REAL_NUM\n", atof(yytext));
}

{INTEGER} {
	printf("'%i' : INT_NUM\n", atoi(yytext));
}

[a-z][a-z0-9_]* {
	printf("'%s' : IDENTIFIER\n", yytext);
}

%%

int main(void)
{
	yylex();
	return 0;
}
