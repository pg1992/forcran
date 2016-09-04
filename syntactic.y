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

struct var_node *get_var(struct varlist *vl, const char * const this_type, 
	         char *this_name, char *search_param){
	struct var_node *cur = vl -> head;

	while(strcmp(cur -> name, search_param) != 0 && cur != NULL){
		cur = cur -> next;
	}
	strcpy(cur->type, this_type);
	strcpy(cur->name, this_name);

	return cur;
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
%token READ_COMMAND WRITE_COMMAND PRINT_COMMAND
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
	| PrintStmt
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
	| INTEGER_KEYWORD IDENTIFIER {
		char tmp[128];
		sprintf(tmp, "%s", $2);
		printf("int %s;\n", tmp);
		add_var(&vars, "int", tmp);
	}
	| REAL_KEYWORD IDENTIFIER {
		char tmp[128];
			sprintf(tmp, "%s", $2);
		printf("double %s;\n", tmp);
		add_var(&vars, "real", tmp);
	}
WriteStmt:
	WRITE_COMMAND FormatWrite STRING {printf("printf(\"%s\");\n", $3);}
ReadStmt:
	READ_COMMAND FormatRead VarList
VarList:
	IDENTIFIER {}
	| VarList COMMA IDENTIFIER
FormatWrite:
	OPEN_PARENS TIMES COMMA TIMES CLOSE_PARENS
FormatRead:
	OPEN_PARENS TIMES COMMA TIMES CLOSE_PARENS
PrintStmt:
	PRINT_COMMAND FormatPrint STRING {printf("printf(\"%s\");\n", $3);}
FormatPrint:
	TIMES COMMA
BeginProg:
	PROGRAM_KEYWORD IDENTIFIER {printf("int main(void) {\n");}
EndProg:
	END_KEYWORD PROGRAM_KEYWORD IDENTIFIER {printf("}\n");}

%%

int yyerror(char *s){
	printf("%s\n", s);
}

int main(void){
	struct var_node *cur = vars.head;

	printf("#include <stdio.h>\n");
	printf("#include <stdlib.h>\n");
	printf("#include <string.h>\n");
	printf("#include <math.h>\n\n");

	yyparse();

	printf("Número de variáveis: %i\n", vars.size);

	while(cur != NULL){
		printf("\nNome: %s\n", cur->name);
		printf("\nTipo: %s\n", cur->type);
		cur = cur->next;
	}
}

