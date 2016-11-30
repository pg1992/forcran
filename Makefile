TSTFLD = test/

DBG=
all: forcran

run: forcran
	gcc functions/error_messages.c -o run
	./run
	@echo -e "Arquivo .f90:\n"
	@cat ex.f90
	@echo -e "\nArquivo .c gerado:\n"
	./forcran ${DBG} < ex.f90 > out.c && cat out.c

tests:
	gcc $(TSTFLD)test.c -o $(TSTFLD)run
	./$(TSTFLD)run

forcran: lex.yy.c syntactic.tab.c src/print_list.c lib/print_list.h
	@echo Compilando o FORCRAN
	@gcc -o forcran -I./lib src/print_list.c syntactic.tab.c lex.yy.c -lm -lfl 2>/dev/null

syntactic.tab.c: syntactic.y
	@echo Compilando o sintático
	@bison -d syntactic.y --report=state 2>/dev/null

lex.yy.c: lexical.l syntactic.tab.c
	@echo Compilando o léxico
	@flex lexical.l
 
clear:
	rm forcran syntactic.tab.c syntactic.tab.h lex.yy.c out.c syntactic.output

