%{
#include <stdio.h>
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
	BeginProg
	| EndProg
	| PrintStmt
	| WriteStmt
	| Declaration
Declaration:
//	INTEGER_KEYWORD VAR_DEF_SEPARATOR IDENTIFIER {printf("int %s;\n", $3);}
//	| REAL_KEYWORD  VAR_DEF_SEPARATOR IDENTIFIER {printf("double %s;\n", $3);}
PrintStmt: 
	PRINT_COMMAND FormatPrint STRING {printf("  printf(\"%s\");\n", $3);}
FormatPrint:
	TIMES COMMA
WriteStmt:
	WRITE_COMMAND FormatWrite STRING {printf("  printf(\"%s\");\n", $3);}
FormatWrite:
	OPEN_PARENS TIMES COMMA TIMES CLOSE_PARENS
BeginProg:
	PROGRAM_KEYWORD IDENTIFIER {printf("int main(void) {\n\n");}
EndProg:
	END_KEYWORD PROGRAM_KEYWORD IDENTIFIER {printf("\n}\n");}

%%

int yyerror(char *s){
	printf("%s\n", s);
}

int main(void){ 

	printf("#include <stdio.h>\n");
	printf("#include <stdlib.h>\n");
	printf("#include <string.h>\n");
	printf("#include <math.h>\n\n");
	
	yyparse();
}

