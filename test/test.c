#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include "../functions/symbol_table.c"

// tests start here

void test_add_var ()	{ 

	char* name = "nome_test";
	const char * const type = "test";

	add_var(&vars, type, name);

	assert(&vars != NULL);
	printf("\nEnd of test_add_var\nadd_var OK\n");
}

// tests end here

// main to run all tests
int main () {

	test_add_var();


	return 0;
}
