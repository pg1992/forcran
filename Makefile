all: lex.yy.c
	gcc $< -lfl 

lex.yy.c: lexical.l
	flex $<
