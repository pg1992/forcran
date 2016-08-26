forcran: lexical.l syntactic.y
	bison -d syntactic.y
	flex lexical.l
	gcc -o forcran syntactic.tab.c lex.yy.c -lm
 
clear:
	rm a.out forcran syntactic.tab.c lex.yy.c

