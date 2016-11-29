TSTFLD = test/

DBG=
all: run

run: forcran
	gcc functions/use_error_messages.c -o run
	./run
	@echo -e "Arquivo .f90:\n"
	@cat ex.f90
	@echo -e "\nArquivo .c gerado:\n"
	./forcran ${DBG} < ex.f90 > out.c && cat out.c

tests:
	gcc $(TSTFLD)test.c -o $(TSTFLD)run
	./$(TSTFLD)run

forcran: lex.yy.c syntactic.tab.c src/print_list.c lib/print_list.h
	gcc -o forcran -I./lib src/print_list.c syntactic.tab.c lex.yy.c -lm -lfl

syntactic.tab.c: syntactic.y
	bison -d syntactic.y --report=state

lex.yy.c: lexical.l syntactic.tab.c
	flex lexical.l
 
clear:
	rm forcran syntactic.tab.c syntactic.tab.h lex.yy.c out.c syntactic.output

