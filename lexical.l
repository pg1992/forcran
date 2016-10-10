%option noyywrap nodefault yylineno case-insensitive

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "syntactic.tab.h"
%}

WHITE [\t ]
LETTER [a-zA-Z]
DIGIT [0-9]
NUMBER [0-9]+
SIGN ("+"|"-")?
INTEGER {SIGN}{NUMBER}
REAL {SIGN}{NUMBER}+"."{NUMBER}(e{SIGN}?{NUMBER})?

%%

{WHITE} {}

\n {
	return EOL;
}

"!"([^\n])* {
	yytext++;
	yylval = yytext;
	//printf("'%s' : COMMENT\n", yytext);
	return COMMENT;
}

"'" {
	return QUOTE;
}

"(" {
	//printf("'%s' : OPEN_PARENS\n", yytext);
	return OPEN_PARENS;
}

")" {
	//printf("'%s' : CLOSE_PARENS\n", yytext);
	return CLOSE_PARENS;
}

"{" {
	//printf("'%s' : OPEN_BRACKET\n", yytext);
	return OPEN_BRACKET;
}

"}" {
	//printf("'%s' : CLOSE_BRACKET\n", yytext);
	return CLOSE_BRACKET;
}

"::" {
	//printf("'%s' : VAR_DEF_SEPARATOR\n", yytext);
	return VAR_DEF_SEPARATOR;
}

"," {
	//printf("'%s' : COMMA\n", yytext);
	return COMMA;
}

";" {
	return SEMICOLON;
}

"^" {
	//printf("'%s' : POWER\n", yytext);
	return POWER;
}

"**" {
	//printf("'%s' : POWER\n", yytext);
	return POWER;
}

"*" {
	//printf("'%s' : TIMES\n", yytext);
	return TIMES;
}

"+" {
	//printf("'%s' : PLUS\n", yytext);
	return PLUS;
}

"-" {
	//printf("'%s' : MINUS\n", yytext);
	return MINUS;
}

"/" {
	//printf("'%s' : DIVIDE\n", yytext);
	return DIVIDE;
}

"=" {
	//printf("'%s' : EQUAL\n", yytext);
	return EQUAL;
}

"then" {
	return THEN_KEYWORD;
}

"if" {
	return IF_KEYWORD;
}

"else" {
	return ELSE_KEYWORD;
}

".true." {
	return TRUE_KEYWORD;
}

".false." {
	return FALSE_KEYWORD;
}

".eq." {
	return EQUAL_KEYWORD;
}

"'"([^'])*"'" {
	yytext = yytext + 1;
	yytext[strlen(yytext)-1] = 0;
	//printf("'%s' : STRING\n", yytext);
	yylval = yytext;
	return STRING;
}

"implicit" {
	//printf("'%s' : IMPLICIT\n", yytext);
	return IMPLICIT;
}

"none" {
	//printf("'%s' : NONE\n", yytext);
	return NONE;
}

"parameter" {
	//printf("'%s' : PARAMETER\n", yytext);
	return PARAMETER;
}

"print" {
	return PRINT_COMMAND;
}

"write" {
	//printf("'%s' : WRITE_COMMAND\n", yytext);
	return WRITE_COMMAND;
}

"read" {
	//printf("'%s' : READ_COMMAND\n", yytext);
	return READ_COMMAND;
}

"real" {
	//printf("'%s' : REAL_KEYWORD\n", yytext);
	return REAL_KEYWORD;
}

"program" {
	//printf("'%s' : PROGRAM_KEYWORD\n", yytext);
	return PROGRAM_KEYWORD;
}

"end" {
	//printf("%s : END_KEYWORD\n", yytext);
	return END_KEYWORD;
}

"integer" {
	//printf("'%s' : INTEGER_KEYWORD\n", yytext);
	return INTEGER_KEYWORD;
}

{REAL} {
	//printf("'%.5g' : REAL_NUM\n", atof(yytext));
	yylval = yytext;
	return REAL_NUM;
}

{INTEGER} {
	//printf("'%i' : INT_NUM\n", atoi(yytext));
	yylval = yytext;
	return INT_NUM;
}

[a-z][a-zA-Z0-9_]* {
	//printf("'%s' : IDENTIFIER\n", yytext);
	yylval = yytext;
	return IDENTIFIER;
}

. {
	//printf("%s : CARACTER BIZONHO\n", yytext);
}

%%

