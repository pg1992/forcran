#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include "../functions/symbol_table.c"
#include "../functions/error_messages.c"
#define KGRN "\x1B[32m"
#define KRED "\x1B[31m"
#define KYEL "\x1B[36m"
#define KWHT "\x1B[37m"

/*
We recomend you to use this template for your tests

void method_name() {
	total_tests++;
	int r=0;
	r = method_name();
	if (r<1) {
		printf("%s\method_name OK\n", KGRN);
		tests_ok++;
	}
	else {
		printf("%s\nmethod_name FAIL\n", KRED);
		tests_fail++;
	}
}

*/

// tests start here
char file_test[] = "test.f90";

int total_tests=0;
int tests_ok=0;
int tests_fail=0;

void test_add_var ()	{ 
	total_tests++;
	char* name = "nome_test";
	const char * const type = "test";

	add_var(&vars, type, name);

	assert(&vars != NULL);
	printf("\nadd_var OK\n", KGRN);
	tests_ok++;
}

void test_check_program_format() {
	total_tests++;
	int r=0;
	r = check_program_format();
	if (r<1) {
		printf("%s\ncheck_program_format OK\n", KGRN);
		tests_ok++;
	}
	else {
		printf("%s\ncheck_program_format FAIL\n", KRED);
		tests_fail++;
	}
}

void test_check_end_format() {
	total_tests++;
	int r=0;
	r = check_end_format();
	if (r<1) {
		printf("%s\ncheck_end_format OK\n", KGRN);
		tests_ok++;
	}
	else {
		printf("%s\ncheck_end_format FAIL\n", KRED);
		tests_fail++;
	}
}

void test_check_name_of_program(){
	total_tests++;
	int r=0;
	r = check_name_of_program();
	if (r<1) {
		printf("%s\ncheck_name_of_program OK\n", KGRN);
		tests_ok++;
	}
	else {
		printf("%s\ncheck_name_of_program FAIL\n", KRED);
		tests_fail++;
	}
}

void test_check_presence_end(){
	total_tests++;
	int r=0;
	r = check_presence_end();
	if (r<1) {
		printf("%s\ncheck_presence_end OK\n", KGRN);
		tests_ok++;
	}
	else {
		printf("%s\ncheck_presence_end FAIL\n", KRED);
		tests_fail++;
	}
}

void test_check_then(){
	total_tests++;
	int r=0;
	r = check_then();
	if (r<1) {
		printf("%s\ncheck_then OK\n", KGRN);
		tests_ok++;
	}
	else {
		printf("%s\ncheck_then FAIL\n", KRED);
		tests_fail++;
	}
}

void test_check_print_format() {
	total_tests++;
	int r=0;
	r = check_print_format();
	if (r<1) {
		printf("%s\ncheck_print_format OK\n", KGRN);
		tests_ok++;
	}
	else {
		printf("%s\ncheck_print_format FAIL\n", KRED);
		tests_fail++;
	}
}

void test_check_read_format() {
	total_tests++;
	int r=0;
	r = check_read_format();
	if (r<1) {
		printf("%s\ncheck_read_format OK\n", KGRN);
		tests_ok++;
	}
	else {
		printf("%s\ncheck_read_format FAIL\n", KRED);
		tests_fail++;
	}
}

void test_check_write_format() {
	total_tests++;
	int r=0;
	r = check_write_format();
	if (r<1) {
		printf("%s\ncheck_write_format OK\n", KGRN);
		tests_ok++;
	}
	else {
		printf("%s\ncheck_write_format FAIL\n", KRED);
		tests_fail++;
	}
}

// tests end here

// main to run all tests
int main () {

	save_words(file_test);
	test_check_program_format();
	test_check_end_format();
	test_check_name_of_program();
	test_check_presence_end();
	test_check_then();
	test_check_print_format();
	test_check_read_format();
	test_check_write_format();

	test_add_var();
	system("setterm -bold on");
	printf("\n%sTotal tests = %d\n", KYEL, total_tests);
	printf("%sTests pass = %d\n", KGRN, tests_ok);
	printf("%sTests fail = %d\n\n", KRED, tests_fail);
	printf("%sThanks for testing ForCran!\n\n", KWHT);
	system("setterm -bold off");

	return 0;
}
