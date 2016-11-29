#include <stdio.h>
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include "error_messages.c"

char file_name[] = "ex.f90";

int main() {
	
	save_words(file_name);
	call_check_validations();
	//printf("numero de palavras = %d\n", number_words);
	return 0;

}