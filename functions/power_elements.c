/*
File to get and use math functions
First get elements of power expression
*/



#include <stdio.h>
#include <math.h>
#include <string.h>
#include <stdlib.h>
#define LINE_TOTAL 100

FILE *program_file;

typedef struct p_e {
// b = base and p = potency
	char b[100];
	char p[100];

}power_elements;

// get base velue of power expression
char *get_base (char *expression) {
	
	char *base = (char *) malloc(sizeof(char)*LINE_TOTAL);
	int i=0;
	while (expression[i] != '^') {
		if (expression [i] == '*' && expression[i+1] == '*') { break; }
		base[i] = expression[i];
		i++;
		if (expression[i] == '\n') { break; }
	}
	return base;
	
}

// get the potency value of power expression
char *get_potency (char *expression) {

	char *potency = (char *) malloc(sizeof(char)*LINE_TOTAL);
	int i=1, j=0;
	while (expression[i] != '^') {
		i++;
		if (expression [i] == '*' && expression[i+1] == '*') { i++; break; }
		if (expression[i] == '\n') { break; }
	}
	
	i++;

	while (expression[i] != '\n') {
		potency[j] = expression[i];
		i++;
		j++;
		if (expression[i] == '\n') { break; }
	}

	return potency;

}


