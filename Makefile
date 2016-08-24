forcran: lexical.l syntactic.y
	bison -d syntactic.y
	flex lexical.l
	gcc -o code syntactic.tab.c lex.yy.c -lm
 
clear:
	rm a.out code syntactic.tab.c lex.yy.c