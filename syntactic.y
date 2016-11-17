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
%token DO_KEYWORD

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
	| CommandList Command COMMENT EOL {
		printf("//%s\n", $3);
	}
	;

Command:
	/* Empty */
	| COMMENT {
		printf("//%s\n", $1);
	}
	| BeginProg
	| EndProg
	| { clear_all(); } PrintText { print_all(); }
	| ReadStmt
	| Declaration
	| Assignment
	| Conditional
	;

Conditional:
	IfStmt ConditionScope END_KEYWORD IF_KEYWORD {
		printf("}\n");
	}
	| IfStmt ConditionScope ElseStmt END_KEYWORD IF_KEYWORD {
		//	printf("}\n");
	}
	| IfStmt ConditionScope ElseIfStmt ElseStmt END_KEYWORD IF_KEYWORD
	  {printf("}\n");}
	| IfStmt ConditionScope ElseIfStmt END_KEYWORD IF_KEYWORD
	  {printf("}\n");}
	;

IfStmt:
	IF_KEYWORD OPEN_PARENS {printf("if(");} ConditionStmt CLOSE_PARENS THEN_KEYWORD {
		printf("){\n");
	}

ElseIfStmt:
	ELSE_KEYWORD IF_KEYWORD OPEN_PARENS ConditionStmt CLOSE_PARENS THEN_KEYWORD 
	ConditionScope
	| ELSE_KEYWORD IF_KEYWORD OPEN_PARENS ConditionStmt CLOSE_PARENS THEN_KEYWORD 
	ConditionScope ElseIfStmtRecur
	;

ElseIfStmtRecur: ElseStmt
	| ELSE_KEYWORD IF_KEYWORD OPEN_PARENS {printf("else if(");} ConditionStmt 
	{printf(" ){\n");} CLOSE_PARENS THEN_KEYWORD 
	ConditionScope {printf("}\n");} ElseIfStmtRecur
	ElseIfFormat ConditionScope
	| ElseIfFormat ConditionScope ElseIfStmtRecur

ElseIfStmtRecur:
	ElseIfFormat ConditionScope {printf("}\n");}
	;

ElseIfFormat:
	ELSE_KEYWORD IF_KEYWORD OPEN_PARENS {printf("else if(");} ConditionStmt 
	CLOSE_PARENS THEN_KEYWORD {printf("){\n");}
	;

ElseStmt:
	ELSE_KEYWORD {printf("else{\n");} ConditionScope {printf("}");}
	;


ConditionStmt:
	TRUE_KEYWORD {
		$$ = strdup("1");
		printf("1");
	}
	| FALSE_KEYWORD {
		$$ = strdup("0");
		printf("0\n");
	}
	| Expression Possible_Conditions Expression {
	}
	| Expression Possible_Conditions Expression AND_KEYWORD {printf(" && ");} ConditionStmt
	| Expression Possible_Conditions Expression OR_KEYWORD {printf(" || ");} ConditionStmt
	;

Possible_Conditions:
	EQUAL_KEYWORD {printf(" == ");}
	| BNE_KEYWORD	{printf(" != ");}
	| BGT_KEYWORD	{printf(" > ");}
	| BLT_KEYWORD	{printf(" < ");}
	| BGE_KEYWORD	{printf(" >= ");}
	| BLE_KEYWORD	{printf(" <= ");}
	;

ConditionScope: 
	ConditionScope EOL MultipleScope
	| MultipleScope
	;

MultipleScope:
	| EOL COMMENT {printf("//%s\n", $2);} MultipleScope
	| EOL MultipleScope
	| EOL Assignment MultipleScope
	| EOL Conditional MultipleScope
	| EOL PrintStmt MultipleScope
	| EOL WriteStmt MultipleScope
	| EOL ReadStmt MultipleScope
	;

Repetition:
	RepetitionFormat ConditionScope END_KEYWORD DO_KEYWORD

RepetitionFormat:
	DO_KEYWORD ExpressionAssign COMMA Expression
	| DO_KEYWORD ExpressionAssign COMMA Expression COMMA Expression

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
			yyerror("Syntax error: erroneous variable declaration.\n");
		}
	}
	;

Expression:
	numbers_type {
		$$=$1;
	}
	| IDENTIFIER {
		$$=$1;
		printf(" %s", $1);
	}
	| OPEN_PARENS {printf("(");} Expression CLOSE_PARENS {printf(")");}
	| Expression PLUS {printf(" + ");} Expression
	| Expression MINUS {printf(" - ");} Expression
	| Expression TIMES {printf(" * ");} Expression
	| Expression DIVIDE {printf(" / ");} Expression
	| MINUS {printf(" - ");} Expression %prec NEG
	| Expression POWER Expression {
		strcpy(power_e[power_used].b, get_base($1));
		strcpy(power_e[power_used].p, get_potency($1));
		printf("pow(%s,%s);\n", power_e[power_used].b, power_e[power_used].p);
		power_used++;
	}
	;

Assignment:
	| ExpressionAssign {
			char tmp[512];
			strcpy(tmp, $1);
			tmp[strlen(tmp)-1] = '\0';
	}
	;

ExpressionAssign:
	IDENTIFIER EQUAL {printf("%s", $1);} Expression {printf(";\n");}
	;

PrintText:
	PrintStmt
	| WriteStmt
	;

PrintStmt:
	PRINT_COMMAND FormatPrint PrintPossibilities
	| PrintStmt COMMA PrintPossibilities
	;

FormatPrint:
	TIMES COMMA
	;

WriteStmt:
	WRITE_COMMAND FormatWrite PrintPossibilities 
	| WriteStmt COMMA PrintPossibilities
	;

FormatWrite:
	FMT_ANY { default_format(); }
	| FMT_BEG { custom_format(); } Format FMT_END
	;

Format:
	FMT_TXT { append_fmt($1); }
	| INT_NUM { push_multiplier(atoi($1)); } OPEN_PARENS Format CLOSE_PARENS { pop_multiplier(); }
	| Format COMMA Format
	;

PrintPossibilities:
	STRING {
		char temp[128];
		sprintf(temp, "\"%s\"", $1);
		append_content(temp);
		if (is_fmt_any())
			append_fmt("a");
	}
	| REAL_NUM {
		append_content($1);
		if (is_fmt_any())
			append_fmt("f");
	}
	| INT_NUM {
		append_content($1);
		if (is_fmt_any())
			append_fmt("i");
	}
	| IDENTIFIER {
		char type[4];
		char var_name[128];

		strcpy(var_name, $1);

		if (get_var_type(&vars, var_name, type) < 0) {
			fprintf(stderr, "Syntax error: couldn't find variable %s.\n", var_name);
			exit(EXIT_FAILURE);
		}
		else {
			if (!strcmp(type, "d")) strcpy(type, "i");
			else if (!strcmp(type, "lf")) strcpy(type, "f");
			else yyerror("Syntax error: unrecognized variable type.\n");

			if (is_fmt_any())
				append_fmt(type);
			append_content(var_name);
		}
	}
	;

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

		if (get_var_type(&vars, var_name, type) < 0) {
			fprintf(stderr, "Syntax error: couldn't find variable %s.\n", var_name);
			exit(EXIT_FAILURE);
		}
		else
			printf("scanf(\"%%%s\", &%s);\n", type, var_name);
	}
	;

numbers_type:
	INT_NUM {printf("%s", $1);}
	| REAL_NUM {printf("%s", $1);}
	;

NumbersAssign:
	IDENTIFIER EQUAL numbers_type
	;

ReadStmt:
	READ_COMMAND FormatRead VarList
	;

FormatRead:
	OPEN_PARENS TIMES COMMA TIMES CLOSE_PARENS
	;

VarList:
	IDENTIFIER {}
	| VarList COMMA IDENTIFIER
	;

BeginProg:
	PROGRAM_KEYWORD IDENTIFIER EOL IMPLICIT NONE {printf("int main(void) {\n");}
	;

EndProg:
	END_KEYWORD PROGRAM_KEYWORD IDENTIFIER {printf("\nreturn 0;\n}\n");}
	;

%%

int yyerror(char *s){
	printf("%s\n", s);
	exit(EXIT_FAILURE);
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

