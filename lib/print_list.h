#ifndef _PRINT_LIST_H
#define _PRINT_LIST_H

char format_str[128];



struct format {
	char type;
	int whole;
	int frac;
};

struct format fmt_list[64];
int fmt_list_size;

void parse_format(char *);

#endif
