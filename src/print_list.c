#include "print_list.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void clear_all() {
	int i;

	for (i = 0; i < 16; i++)
		fmt_str_stack[i][0] = 0;
	stack_ptr = 0;
	content_num = 0;
	fmt_any = -1;
}

void append_fmt(char *fmt) {
	char type[5];
	int whole;
	int frac;
	int mul;

	int i;
	char tmp[5];
	char temp_format[128];

	struct format sfmt;

	i = 0;
	while (is_num(*fmt))
		tmp[i++] = *fmt++;
	tmp[i] = 0;
	mul = i > 0 ? atoi(tmp) : 1;

	i = 0;
	while(is_alpha(*fmt))
		tmp[i++] = *fmt++;
	tmp[i] = 0;
	strcpy(type, tmp);

	if (*fmt) {
		i = 0;
		while(is_num(*fmt))
			tmp[i++] = *fmt++;
		tmp[i] = 0;
		whole = atoi(tmp);
	}
	else
		whole = -1;

	if (*fmt) {
		fmt++;
		i = 0;
		while(is_num(*fmt))
			tmp[i++] = *fmt++;
		tmp[i] = 0;
		frac = atoi(tmp);
	}
	else
		frac = -1;

	strcpy(sfmt.type, type);
	sfmt.whole = whole;
	sfmt.frac = frac;
	sfmt.mul = mul;

	convert_fmt_f2c(temp_format, sfmt);
	strcat_n(fmt_str_stack[stack_ptr], temp_format, sfmt.mul);
}

void convert_fmt_f2c(char *str, struct format sfmt)
{
	char type[2];

	switch(sfmt.type[0] | (1 << 5)) {
	case 'a':
		strcpy(type,"s");
		break;
	case 'i':
		strcpy(type,"d");
		break;
	case 'f':
		strcpy(type,"lf");
		break;
	case 'e':
		strcpy(type,"g");
		break;
	default:
		fprintf(stderr, "Syntax error: format '%s' not recognized.\n", sfmt.type);
		exit(EXIT_FAILURE);
		break;
	}

	if (sfmt.whole < 0) sprintf(str, "%%%s", type);
	else if(sfmt.frac < 0) sprintf(str, "%%%d%s", sfmt.whole, type);
	else sprintf(str, "%%%d.%d%s", sfmt.whole, sfmt.frac, type);
}

void strcat_n(char *dest, char *src, int n)
{
	while(n--)
		strcat(dest, src);
}

void print_fmt_struct(struct format fmt)
{
	printf("\t%d %s %d %d\n", fmt.mul, fmt.type, fmt.whole, fmt.frac);
}

int is_num(char c)
{
	if ('0' <= c && c <= '9')
		return 1;
	return 0;
}

int is_alpha(char c)
{
	c &= ~(1 << 5);
	if ('A' <= c && c <= 'Z')
		return 1;
	return 0;
}

void push_multiplier(int m)
{
	mul_stack[stack_ptr++] = m;
}

void pop_multiplier()
{
	int mul =  mul_stack[stack_ptr-1];
	char *str = fmt_str_stack[stack_ptr];

	strcat_n(fmt_str_stack[stack_ptr-1], str, mul);
	stack_ptr--;
}

void print_all()
{
	printf("printf(\"");
	print_formats();
	printf("\\n\", ");
	print_content();
	printf(");\n");
}

void print_formats()
{
	printf("%s", fmt_str_stack[0]);
}

void append_content(char *str)
{
	strcpy(contents[content_num++], str);
}

void print_content()
{
	int i;

	for (i = 0; i < content_num - 1; i++)
		printf("%s, ", contents[i]);
	printf("%s", contents[content_num-1]);
}

void default_format()
{
	fmt_any = 1;
}

void custom_format()
{
	fmt_any = 0;
}

int is_fmt_any ()
{
	return fmt_any;
}
