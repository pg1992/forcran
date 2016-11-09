TSTFLD = test/

DBG=
all: run

run: forcran
	@echo -e "Arquivo .f90:\n"
	@cat ex.f90
	@echo -e "\nArquivo .c gerado:\n"
	./forcran ${DBG} < ex.f90 > out.c
	@cat out.c

tests:
	gcc $(TSTFLD)test.c -o $(TSTFLD)run
	./$(TSTFLD)run

forcran: lex.yy.c syntactic.tab.c
	gcc -o forcran -I./lib syntactic.tab.c lex.yy.c -lm -lfl

syntactic.tab.c: syntactic.y
	bison -d syntactic.y --report=state

lex.yy.c: lexical.l
	flex lexical.l
 
clear:
	rm forcran syntactic.tab.c syntactic.tab.h lex.yy.c out.c syntactic.output

