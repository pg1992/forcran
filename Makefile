DBG=
all: run

run: forcran
	@echo -e "Arquivo .f90:\n"
	@cat ex.f90
	@echo -e "\nArquivo .c gerado:\n"
	./forcran ${DBG} < ex.f90

forcran: lex.yy.c syntactic.tab.c
	gcc -o forcran syntactic.tab.c lex.yy.c -lm -lfl

syntactic.tab.c: syntactic.y
	bison -d syntactic.y

lex.yy.c: lexical.l
	flex lexical.l
 
clear:
	rm forcran syntactic.tab.c syntactic.tab.h lex.yy.c

