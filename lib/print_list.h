#ifndef _PRINT_LIST_H
#define _PRINT_LIST_H

struct format {
	char type[2];
	int whole;
	int frac;
	int mul;
};

char fmt_str_stack[16][1024];
int mul_stack[16];
int stack_ptr;

char contents[64][1024];
int content_num;

int fmt_any;

extern void clear_all();
extern void append_fmt(char*);
extern void convert_fmt_f2c(char*, struct format);
extern void strcat_n(char*, char*, int);
extern void print_fmt_struct(struct format);
extern int is_num(char);
extern int is_alpha(char);
extern void push_multiplier(int);
extern void pop_multiplier();
extern void print_all();
extern void print_formats();
extern void print_content();
extern void update_fmt_str();
extern void append_content(char *str);
extern void default_format();
extern void custom_format();
extern int is_fmt_any();

#endif
