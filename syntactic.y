%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "functions/symbol_table.c"
#include "functions/power_elements.c"
#include "print_list.h"
#define ELEMENT_SIZE 100
#define POWERS_USED 10

enum {REAL, INT} type_declaration;
int recur_count = 0;
power_elements power_e[POWERS_USED];
int power_used=0;

%}

%token EOL
%token NUMBER
%token POWER
%token PLUS MINUS TIMES DIVIDE
%token EQUAL
%token OPEN_PARENS CLOSE_PARENS
%token OPEN_BRACKET CLOSE_BRACKET
%token COMMENT
%token VAR_DEF_SEPARATOR
%token COMMA
%token SEMICOLON
%token IMPLICIT NONE PARAMETER
%token READ_COMMAND WRITE_COMMAND PRINT_COMMAND
%token PROGRAM_KEYWORD END_KEYWORD
%token INTEGER_KEYWORD REAL_KEYWORD
%token INT_NUM REAL_NUM
%token IDENTIFIER STRING
%token IF_KEYWORD ELSE_KEYWORD
%token EQUAL_KEYWORD
%token END_IF_KEYWORD
%token THEN_KEYWORD
%token BGE_KEYWORD BGT_KEYWORD BLE_KEYWORD BLT_KEYWORD BNE_KEYWORD BEQ_KEYWORD
%token AND_KEYWORD OR_KEYWORD

%token TRUE_KEYWORD
%token FALSE_KEYWORD
%token QUOTE

%token FMT_DGT FMT_TXT FMT_PT FMT_COMMA FMT_ANY FMT_BEG FMT_END

%left PLUS MINUS
%left TIMES DIVIDE
%left NEG
%right POWER

%%

CommandList:
	/* Empty */
	| CommandList Command SEMICOLON
	| CommandList Command EOL

Command:
	/* Empty */
	| COMMENT {
		printf("//%s\n", $1);
	}
	| BeginProg
	| EndProg
	| PrintText
	| ReadStmt
	| Declaration
	| Assignment
	| Conditional

Conditional:
	IF_KEYWORD OPEN_PARENS ConditionStmt CLOSE_PARENS THEN_KEYWORD ConditionScope
	END_KEYWORD IF_KEYWORD {
		printf("if (%s) {\n", $3);
		//printf("%s\n", $6);
		printf("}\n");
	}
	| IF_KEYWORD OPEN_PARENS ConditionStmt CLOSE_PARENS THEN_KEYWORD
	  ConditionScope ElseStmt END_KEYWORD IF_KEYWORD {
		printf("if (%s) {\n", $3);
		printf("else{\n");
		printf("}\n");
		printf("}\n");
	}
	| IF_KEYWORD OPEN_PARENS ConditionStmt CLOSE_PARENS THEN_KEYWORD
	  ConditionScope ElseIfStmt ElseStmt END_KEYWORD IF_KEYWORD
	| IF_KEYWORD OPEN_PARENS ConditionStmt CLOSE_PARENS THEN_KEYWORD
	  ConditionScope ElseIfStmt END_KEYWORD IF_KEYWORD

ElseIfStmt:
	ELSE_KEYWORD IF_KEYWORD OPEN_PARENS ConditionStmt CLOSE_PARENS THEN_KEYWORD 
	ConditionScope
	| ELSE_KEYWORD IF_KEYWORD OPEN_PARENS ConditionStmt CLOSE_PARENS THEN_KEYWORD 
	ConditionScope ElseIfStmtRecur

ElseIfStmtRecur: ElseStmt
	| ELSE_KEYWORD IF_KEYWORD OPEN_PARENS ConditionStmt CLOSE_PARENS THEN_KEYWORD 
	ConditionScope ElseIfStmtRecur

ElseStmt:
	ELSE_KEYWORD ConditionScope


ConditionStmt:
	TRUE_KEYWORD {
		$$ = strdup("1");
	}
	| FALSE_KEYWORD {
		$$ = strdup("0");
	}
	| Expression Possible_Conditions Expression {
		char tmp[512];
		char aux[100];
		strtok($1, ".eq.");
		strcpy(aux, $3);
		strtok(aux, ")");
		sprintf(tmp, "%s == %s", $1, aux);
		//$$ = strdup(tmp);
		strcpy($$, tmp);
	}
	| Expression Possible_Conditions Expression AND_KEYWORD ConditionStmt
	| Expression Possible_Conditions Expression OR_KEYWORD ConditionStmt

Possible_Conditions:
	EQUAL_KEYWORD
	| BNE_KEYWORD
	| BGT_KEYWORD
	| BEQ_KEYWORD
	| BLT_KEYWORD
	| BGE_KEYWORD
	| BLE_KEYWORD

ConditionScope: 
	ConditionScope EOL MultipleScope
	| MultipleScope

MultipleScope: EOL
	| EOL MultipleScope
	| EOL Assignment MultipleScope
	| EOL Conditional MultipleScope
	| EOL PrintStmt MultipleScope
	| EOL WriteStmt MultipleScope
	| EOL ReadStmt MultipleScope

Declaration:
	INTEGER_KEYWORD VAR_DEF_SEPARATOR IDENTIFIER {
		char tmp[128];
		sprintf(tmp, "%s", $3);
		printf("int %s;\n", tmp);
		add_var(&vars, "d", tmp);
		type_declaration = INT;
	}
	| REAL_KEYWORD VAR_DEF_SEPARATOR IDENTIFIER {
		char tmp[128];
		sprintf(tmp, "%s", $3);
		printf("double %s;\n", tmp);
		add_var(&vars, "lf", tmp);
		type_declaration = REAL;
	}
	| INTEGER_KEYWORD IDENTIFIER {
		char tmp[128];
		sprintf(tmp, "%s", $2);
		printf("int %s;\n", tmp);
		add_var(&vars, "d", tmp);
		type_declaration = INT;
	}
	| REAL_KEYWORD IDENTIFIER {
		char tmp[128];
		sprintf(tmp, "%s", $2);
		printf("double %s;\n", tmp);
		add_var(&vars, "lf", tmp);
		type_declaration = REAL;
	}
	| Declaration COMMA IDENTIFIER {
		char tmp[128];
		switch(type_declaration){
		case INT:
			sprintf(tmp, "%s", $3);
			printf("int %s;\n", tmp);
			add_var(&vars, "d", tmp);
			break;
		case REAL:
			sprintf(tmp, "%s", $3);
			printf("double %s;\n", tmp);
			add_var(&vars, "lf", tmp);
			type_declaration = REAL;
			break;
		default:
			// TODO Escreva uma mensagem de erro decente
			yyerror();
		}
	}

Expression:
	numbers_type {
		$$=$1;
	}
	| IDENTIFIER {
		$$=$1;
	}
	| OPEN_PARENS Expression CLOSE_PARENS{
		char tmp[512];
		//sprintf(tmp, "(%s)", $2);
		//$$ = strdup(tmp);
	}
	| Expression PLUS Expression {
		char tmp[512];
		//sprintf(tmp, "%s %s", $1, $3);
		//$$ = strdup(tmp);
	}
	| Expression MINUS Expression {
		char tmp[512];
		//sprintf(tmp, "%s - %s", $1, $3);
		//$$ = strdup(tmp);
	}
	| Expression TIMES Expression {
		char tmp[512];
		//sprintf(tmp, "%s * %s", $1, $3);
		//$$ = strdup(tmp);
	}
	| Expression DIVIDE Expression {
		char tmp[512];
		//sprintf(tmp, "%s / %s", $1, $3);
		//$$ = strdup(tmp);
	}
	| MINUS Expression %prec NEG {
		char tmp[512];
		//sprintf(tmp, "- %s", $2);
		//$$ = strdup(tmp);
	}
	| Expression POWER Expression {
		strcpy(power_e[power_used].b, get_base($1));
		strcpy(power_e[power_used].p, get_potency($1));
		printf("pow(%s,%s);\n", power_e[power_used].b, power_e[power_used].p);
		power_used++;
	}

Assignment:
	| ExpressionAssign {
			char tmp[512];
			strcpy(tmp, $1);
			tmp[strlen(tmp)-1] = '\0';
			printf("%s;\n", tmp);
	}

ExpressionAssign:
	IDENTIFIER EQUAL Expression

PrintText:
	PrintStmt {
		
	}
	| WriteStmt {
		
	}

PrintStmt:
	PRINT_COMMAND FormatPrint PrintPossibilities {
		//printf("\n\n\tformat: %s\n\n", $2);
	}
	| PrintStmt COMMA PrintPossibilities

FormatPrint:
	TIMES COMMA


WriteStmt:
	WRITE_COMMAND FormatWrite PrintPossibilities {
	}
	| WriteStmt COMMA PrintPossibilities
/*
FormatWrite:
	OPEN_PARENS TIMES COMMA TIMES CLOSE_PARENS {
		printf("\n\n\tformat: '''%s'''\n\n", $4);
		//strcpy(format_str, "");
	}
	| OPEN_PARENS TIMES COMMA STRING CLOSE_PARENS {
		printf("\n\n\tformat: '''%s'''\n\n", $4);
		//strcpy(format_str, $4);
	}
*/
FormatWrite:
	FMT_ANY
	| FMT_BEG Format FMT_END

Format:
	FMT_TXT
	| INT_NUM OPEN_PARENS Format CLOSE_PARENS {
		printf("\n\n\tINT_NUM: %s\n\n", $1);
	}
	| Format COMMA Format

PrintPossibilities:
	STRING {
		printf("printf(\"%s\\n\");\n", $1);
	}
	| REAL_NUM {
		printf("printf(\"%%lf\\n\", %s);\n", $1);
	}
	| INT_NUM {
		printf("printf(\"%%d\\n\", %s);\n", $1);
	}
	| IDENTIFIER {
		char type[4];
		char var_name[128];

		strcpy(var_name, $1);

		if (get_var_type(&vars, var_name, type) < 0)
			fprintf(stderr, "Syntax error: couldn't find variable %s.\n", var_name);
		else
			printf("printf(\"%%%s\\n\", %s);\n", type, var_name);
	}

ReadStmt:
	READ_COMMAND FormatRead IDENTIFIER {
		char type[4];
		char var_name[128];

		strcpy(var_name, $3);

		if (get_var_type(&vars, var_name, type) < 0)
			fprintf(stderr, "Syntax error: couldn't find variable %s.\n", var_name);
		else
			printf("scanf(\"%%%s\", &%s);\n", type, var_name);
	}
	| ReadStmt COMMA IDENTIFIER {
		char type[4];
		char var_name[128];
		
		strcpy(var_name, $3);

		if (get_var_type(&vars, var_name, type) < 0)
			fprintf(stderr, "Syntax error: couldn't find variable %s.\n", var_name);
		else
			printf("scanf(\"%%%s\", &%s);\n", type, var_name);
	}

numbers_type:
	INT_NUM
	| REAL_NUM

NumbersAssign:
	IDENTIFIER EQUAL numbers_type

ReadStmt:
	READ_COMMAND FormatRead VarList

FormatRead:
	OPEN_PARENS TIMES COMMA TIMES CLOSE_PARENS

VarList:
	IDENTIFIER {}
	| VarList COMMA IDENTIFIER

BeginProg:
	PROGRAM_KEYWORD IDENTIFIER EOL IMPLICIT NONE {printf("int main(void) {\n");}

EndProg:
	END_KEYWORD PROGRAM_KEYWORD IDENTIFIER {printf("\nreturn 0;\n}\n");}

%%

int yyerror(char *s){
	printf("%s\n", s);
}

int main(int argc, char *argv[]){

	int debug = 0;

	printf("#include <stdio.h>\n");
	printf("#include <stdlib.h>\n");
	printf("#include <string.h>\n");
	printf("#include <math.h>\n\n");

	yyparse();

		if (argc > 1)
		if (strcmp(argv[1], "-d") == 0)
			debug = 1;

	if (debug)
	{
		printf("------------------------------ Debugging ------------------------------\n");
		printf("\n\nDebugging: variables\n");
		struct var_node *cur;
		printf("\n\nAll vars:\n");
		for (cur = vars.head ; cur != NULL ; cur = cur->next)
			printf("\tType: %s\n\tName: %s\n\n", cur->type, cur->name);
	}
}

