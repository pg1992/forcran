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
REAL {SIGN}{NUMBER}+"."{NUMBER}?

%x WRITE_STATE FMT_STR

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

".ne." {
	return BNE_KEYWORD;
}

".lt." {
	return BLT_KEYWORD;
}

".gt." {
	return BGT_KEYWORD;
}

".ge." {
	return BGE_KEYWORD;
}

".le." {
	return BLE_KEYWORD;
}

".and." {
	return AND_KEYWORD;
}

".or." {
	return OR_KEYWORD;
}

"'"([^'])*"'" {
	yytext = yytext + 1;
	yytext[strlen(yytext)-1] = 0;
	//printf("'%s' : STRING\n", yytext);
	yylval = yytext;
	return STRING;
}

"implicit" return IMPLICIT;

"none" return NONE;

"parameter" return PARAMETER;

"print" {
	return PRINT_COMMAND;
}

	/********************************************************************************/
	/******** Write section ********/
"write" {
	BEGIN(WRITE_STATE);
	return WRITE_COMMAND;
}

<WRITE_STATE>{
"(*,*)" BEGIN(INITIAL);
"(*,'" BEGIN(FMT_STR);
<FMT_STR>{
"')" BEGIN(INITIAL);
[0-9]+ printf("\n\n\tDigit found: %s\n\n", yytext); return(FMT_DGT);
[a-z]+ printf("\n\n\tText found: %s\n\n", yytext); return(FMT_TXT);
"." printf("\n\n\tPoint found: %s\n\n", yytext); return(FMT_PT);
"," printf("\n\n\tComma found: %s\n\n", yytext); return(FMT_COMMA);
}
}

	/******* End of Write section *****/
	/********************************************************************************/

"read" {
	return READ_COMMAND;
}

"real" {
	return REAL_KEYWORD;
}

"program" {
	return PROGRAM_KEYWORD;
}

"end" {
	return END_KEYWORD;
}

"integer" {
	return INTEGER_KEYWORD;
}

{REAL} {
	yylval = yytext;
	return REAL_NUM;
}

{INTEGER} {
	yylval = yytext;
	return INT_NUM;
}

[a-z][a-zA-Z0-9_]* {
	yylval = yytext;
	return IDENTIFIER;
}

.

%%

