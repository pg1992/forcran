%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct var_node {
	char type[10];
	char name[128];
	struct var_node *next;
};

struct varlist {
	int size;
	struct var_node *head;
} vars = {0, NULL};

void add_var (struct varlist * vl, const char * const this_type, char * this_name)
{
	struct var_node * cur = vl->head;
	while (cur != NULL)
		cur = cur->next;
	cur = (struct var_node *)malloc(sizeof(struct var_node));
	strcpy(cur->type, this_type);
	strcpy(cur->name, this_name);
	cur->next = NULL;
	vl->size++;
}
%}

%token EOL
%token NUMBER
%token PLUS MINUS TIMES DIVIDE POWER
%token EQUAL
%token OPEN_PARENS CLOSE_PARENS
%token OPEN_BRACKET CLOSE_BRACKET
%token COMMENT
%token VAR_DEF_SEPARATOR
%token COMMA
%token SEMICOLON
%token IMPLICIT NONE PARAMETER
%token READ_COMMAND WRITE_COMMAND
%token PROGRAM_KEYWORD END_KEYWORD
%token INTEGER_KEYWORD REAL_KEYWORD
%token INT_NUM REAL_NUM
%token IDENTIFIER STRING

%%

CommandList:
	/* Empty */
	| CommandList Command SEMICOLON
	| CommandList Command EOL
Command:
	/* Empty */
	| BeginProg
	| EndProg
	| WriteStmt
	| ReadStmt
	| Declaration
Declaration:
	INTEGER_KEYWORD VAR_DEF_SEPARATOR IDENTIFIER {
		char tmp[128];
		sprintf(tmp, "%s", $3);
		printf("int %s;\n", tmp);
		add_var(&vars, "int", tmp);
	}
	| REAL_KEYWORD VAR_DEF_SEPARATOR IDENTIFIER {
		char tmp[128];
		sprintf(tmp, "%s", $3);
		printf("double %s;\n", tmp);
		add_var(&vars, "real", tmp);
	}
WriteStmt:
	WRITE_COMMAND Format STRING {printf("printf(\"%s\");\n", $3);}
ReadStmt:
	READ_COMMAND Format VarList
VarList:
	IDENTIFIER {}
	| VarList COMMA IDENTIFIER
Format:
	OPEN_PARENS TIMES COMMA TIMES CLOSE_PARENS
BeginProg:
	PROGRAM_KEYWORD IDENTIFIER {printf("int main(void) {\n");}
EndProg:
	END_KEYWORD PROGRAM_KEYWORD IDENTIFIER {printf("}\n");}

%%

int yyerror(char *s){
	printf("%s\n", s);
}

int main(void){
	struct var_node * cur = vars.head;

	printf("#include <stdio.h>\n");
	printf("#include <stdlib.h>\n");
	printf("#include <string.h>\n");
	printf("#include <math.h>\n\n");

	yyparse();

	printf("Número de variáveis: %i\n", vars.size);

	while(cur != NULL)
	{
		printf("\nNome: %s\n", cur->name);
		printf("\nTipo: %s\n", cur->type);
		cur = cur->next;
	}
}

