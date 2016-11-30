%option noyywrap nodefault yylineno case-insensitive

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "syntactic.tab.h"

void to_lowercase(char *s)
{
	int i = 0;
	for (i = 0; s[i]; i++)
		s[i] |= ('A' <= s[i] && s[i] <= 'Z') ? (1 << 5) : 0;
}
%}

WHITE [\t ]
LETTER [a-zA-Z]
DIGIT [0-9]
NUMBER [0-9]+
SIGN ("+"|"-")?
INTEGER {SIGN}{NUMBER}
REAL1 {SIGN}{NUMBER}"."{NUMBER}((e|E){INTEGER})?
REAL2 {SIGN}"."{NUMBER}((e|E){INTEGER})?
REAL3 {SIGN}{NUMBER}"."((e|E){INTEGER})?
REAL4 {SIGN}{NUMBER}((e|E){INTEGER})
REAL ({REAL1}|{REAL2}|{REAL3}|{REAL4})

%s WRITE_STATE FMT_STR

%%

{WHITE} {}
\n return EOL;
"!"([^\n])* {
	yytext++;
	yylval = yytext;
	return COMMENT;
}
"'" return QUOTE;
"(" return OPEN_PARENS;
")" return CLOSE_PARENS;
"{" return OPEN_BRACKET;
"}" return CLOSE_BRACKET;
"parameter" return PARAMETER;
"::" return VAR_DEF_SEPARATOR;
"," return COMMA;
";" return SEMICOLON;
"^" return POWER;
"**" return POWER;
"*" return TIMES;
"+" return PLUS;
"-" return MINUS;
"/" return DIVIDE;
"=" return EQUAL;
"do" return DO_KEYWORD;
"then" return THEN_KEYWORD;
"if" return IF_KEYWORD;
"else" return ELSE_KEYWORD;
".true." return TRUE_KEYWORD;
".false." return FALSE_KEYWORD;
".eq." return EQUAL_KEYWORD;
".ne." return BNE_KEYWORD;
".lt." return BLT_KEYWORD;
".gt." return BGT_KEYWORD;
".ge." return BGE_KEYWORD;
".le." return BLE_KEYWORD;
".and." return AND_KEYWORD;
".or." return OR_KEYWORD;
"'"([^'])*"'" {
	yytext = yytext + 1;
	yytext[strlen(yytext)-1] = 0;
	//printf("'%s' : STRING\n", yytext);
	yylval = yytext;
	return STRING;
}
"implicit" return IMPLICIT;
"none" return NONE;
"print" return PRINT_COMMAND;

"write" BEGIN(WRITE_STATE); return WRITE_COMMAND;
<WRITE_STATE>{
"(*,*)" BEGIN(INITIAL); return(FMT_ANY);
"(*,'(" BEGIN(FMT_STR); return(FMT_BEG);
<FMT_STR>{
")')" BEGIN(INITIAL); return(FMT_END);
({NUMBER})?(e|es|l|a|x|t|i|f)({NUMBER}("."{NUMBER})?)? {
	yylval = yytext;
	return(FMT_TXT);
}
}
}

"read" return READ_COMMAND;
"real" return REAL_KEYWORD;
"program" return PROGRAM_KEYWORD;
"end" return END_KEYWORD;
"integer" return INTEGER_KEYWORD;
{REAL} {
	yylval = yytext;
	return REAL_NUM;
}
{INTEGER} {
	yylval = yytext;
	return INT_NUM;
}
[a-z][a-zA-Z0-9_]* {
	to_lowercase(yytext);
	yylval = yytext;
	return IDENTIFIER;
}
.

%%

