#include <stdio.h>
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

FILE *fortran_program;
FILE *help_file;
FILE *read_help_file;

struct list_ {
	char word[20];
	int line;
};

struct list_ list[1200];

char file[] = "ex.f90"; 
int number_words=0;

void check_program_format() {
	int i=0;	
	for(i=0; (number_words-1); i++) {
		if (strcmp(list[i].word, "prgram") == 0 || strcmp(list[i].word, "progran") == 0 || strcmp(list[i].word, "progra") == 0) {
			printf("Error in line %d\n", list[i].line);
			printf("Error: program format is not correct\n\n");
		}
		else if (strcmp(list[i].word, "progam") == 0 || strcmp(list[i].word, "progrm") == 0 || strcmp(list[i].word, "pogram") == 0) {
			printf("Error in line %d\n", list[i].line);
			printf("Error: program format is not correct\n\n");
		}
		else if (strcmp(list[i].word, "prog") == 0 || strcmp(list[i].word, "prograam") == 0 || strcmp(list[i].word, "pgram") == 0) {
			printf("Error in line %d\n", list[i].line);
			printf("Error: program format is not correct\n\n");
		}
		else {}
		if (i > number_words) { break; }
	}
}

void check_end_format() {	
	int i=0;
	for(i=0; (number_words-1); i++) {
		if (strcmp(list[i].word, "en") == 0 || strcmp(list[i].word, "edn") == 0
		 || strcmp(list[i].word, "ed") == 0 || strcmp(list[i].word, "nd") == 0 ) {
			printf("Error in line %d\n", list[i].line);
			printf("Error: 'end' format is not correct\n\n");
			break;			
		}
		if (i > number_words) { break; }
	}	
}

void check_name_of_program() {
	int i=0, count_program=0;
	char name_of_program[15];
	for(i=0; (number_words-1); i++) {
		if (count_program == 0) {
			if (strcmp(list[i].word, "program") == 0 && count_program == 0 ) {
				strcpy(name_of_program, list[i+1].word);
				count_program=1;
				//printf("nome do programa = %s\n", list[i+1].word);
			}
		}
		else if (count_program == 1) {
			if (strcmp(list[i].word, "program") == 0 && count_program == 1) {
				count_program=2;
				//printf("2 program in line %d\nname of program = %s\n", list[i].line, list[i+1].word); 
			}
			if (count_program == 2) {
				if (strcmp(list[i+1].word, name_of_program) != 0) {
					printf("Error in line %d\n", list[i].line);
					printf("Error: name of program is difference in 'end program %s'\n\n", list[i+1].word);
					count_program = 0;
					break;
				}
			}
		}
		if (i > number_words) { break; }
	}
}

void check_presence_end() {
	int i=0;
	int count_program=0;
	for(i=0; (number_words-1); i++) {
		if (strcmp(list[i].word, "program") == 0) {
			count_program++;
			if (count_program == 2) {
				if (strcmp(list[i-1].word, "end") != 0) {
					printf("Error in line %d\n", list[i].line);
					printf("Error: missing 'end' before program\n\n");
				}
			}
		}
		if (i > number_words) { break; }
	}
}

void check_then() {
	int i=0; int line=0;
	int found_then=0, found_if=0;
	for(i=0; (number_words-1); i++) {
		if (strcmp(list[i].word, "if") == 0) {
			found_if=1;
			line = list[i].line;
		}
		if (found_if==1) {
			while (list[i].line == line) {
				if (strcmp(list[i].word, "then") == 0) {
					found_then=1;
					//printf("chegou na linhe\n");
					break;
				}		
				i++;
			}
			if (found_then == 0) {
				printf("Error in line %d\n", list[i].line-1);
				printf("Error: missing 'then' after if\n\n");
				break;
			}
		}
		if (i > number_words) { break; }
	}
}

void check_print_format() {
	int i=0;
	for(i=0; (number_words-1); i++) {
		if (strcmp(list[i].word, "prit") == 0 || strcmp(list[i].word, "prin") == 0 
				|| strcmp(list[i].word, "prt") == 0 || strcmp(list[i].word, "pint") == 0) {
			printf("Error in line %d\n", list[i].line);
			printf("Error: %s format should be 'print'\n\n", list[i].word);
		}
		else if (strcmp(list[i].word, "prnt") == 0 || strcmp(list[i].word, "pirnt") == 0 
				|| strcmp(list[i].word, "pritn") == 0 || strcmp(list[i].word, "prnit") == 0) {
			printf("Error in line %d\n", list[i].line);
			printf("Error: '%s' format should be 'print'\n\n", list[i].word);
		}
		if (i > number_words) { break; }
	}
}

void check_read_format() {
	int i=0;
	for(i=0; (number_words-1); i++) {
		if (strcmp(list[i].word, "rea") == 0 || strcmp(list[i].word, "red") == 0 
				|| strcmp(list[i].word, "raed") == 0 || strcmp(list[i].word, "rad") == 0) {
			printf("Error in line %d\n", list[i].line);
			printf("Error: %s format should be 'read'\n\n", list[i].word);
		}
		else if (strcmp(list[i].word, "erad") == 0 || strcmp(list[i].word, "rae") == 0 
				|| strcmp(list[i].word, "readd") == 0 || strcmp(list[i].word, "ead") == 0) {
			printf("Error in line %d\n", list[i].line);
			printf("Error: '%s' format should be 'read'\n\n", list[i].word);
		}
		if (i > number_words) { break; }
	}
}

void check_write_format() {
	int i=0;
	for(i=0; (number_words-1); i++) {
		if (strcmp(list[i].word, "wite") == 0 || strcmp(list[i].word, "writ") == 0 
				|| strcmp(list[i].word, "wrie") == 0 || strcmp(list[i].word, "rite") == 0) {
			printf("Error in line %d\n", list[i].line);
			printf("Error: %s format should be 'write'\n\n", list[i].word);
		}
		else if (strcmp(list[i].word, "wirte") == 0 || strcmp(list[i].word, "wriet") == 0 
				|| strcmp(list[i].word, "rwite") == 0 || strcmp(list[i].word, "wrtie") == 0) {
			printf("Error in line %d\n", list[i].line);
			printf("Error: '%s' format should be 'write'\n\n", list[i].word);
		}
		if (i > number_words) { break; }
	}
}

void save_words() {
	fortran_program = fopen(file, "r");
	if (fortran_program == NULL) {
		printf("Error: This fortran program '%s' is empty\n", file);
	}
	else {
		char line[128];
		char help_word[20];
		int i=0, n_line=0;

		while (fgets(line, sizeof(line), fortran_program)) {
			
			help_file = fopen("help.txt", "w+");
			fprintf(help_file, "%s", line);
			n_line++;
			fclose(help_file);
			read_help_file = fopen("help.txt", "r");

			if (read_help_file == NULL) {
				printf("Help_file is empty\n");
			}

			else {
				while((fscanf(read_help_file, "%s", &help_word))!=EOF) {
					strcpy(list[i].word, help_word);
					list[i].line = n_line;
					//printf("palavra[%d] = %s    ---linha[%d] = %d\n", i, list[i].word, i, list[i].line);
					i++;
				}
			}
		}
		number_words = i;
	}
}


void call_check_validations() {

	save_words();
	printf("\n");
	check_program_format();
	check_name_of_program();
	check_print_format();
	check_write_format();
	check_read_format();
	check_end_format();
	check_then();
	check_presence_end();
	printf("\n");
}

int main() {
	
	call_check_validations();
	//printf("numero de palavras = %d\n", number_words);
	return 0;

}
