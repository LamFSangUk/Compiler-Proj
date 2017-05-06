20141522:
	bison -d -v cminus.y
	flex cminus.l
	gcc main.c util.c lex.yy.c cminus.tab.c -o 20141522 -lfl
clean:
	rm 20141522 lex.yy.c cminus.output cminus.tab.c cminus.tab.h

