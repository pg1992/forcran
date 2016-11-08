#include "print_list.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void
parse_format(char *fmt_str)
{
	int i = 0;
	int n = strlen(fmt_str);
	char c;

	if (fmt_str[0] != '(' || fmt_str[n-1] != ')') {
		fprintf(stderr, "syntax error\n");
		exit(EXIT_FAILURE);
	}

	while (c = fmt_str[i++])
	{
		if ('0' <= c && c <= '9') {
		}
	}
}
