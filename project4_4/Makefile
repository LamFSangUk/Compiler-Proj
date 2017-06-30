C = gcc
CFLAG = 
OBJECTS = main.o util.o lex.yy.o cminus.tab.o symtab.o analyze.o code.o cgen.o
TARGET = project4_4

all : $(TARGET)

$(TARGET) : $(OBJECTS)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJECTS) -lfl
	# Mac OS X -ll Option
	# # Linux L -lfl Option
	#

main.o : main.c globals.h util.h scan.h lex.yy.c cminus.tab.c
				$(CC) $(CFLAGS) -c main.c

util.o : util.c util.h globals.h
				$(CC) $(CFLAGS) -c util.c

symtab.o : symtab.c symtab.h
				$(CC) $(CFLAGS) -c symtab.c

analyze.o : analyze.c symtab.h globals.h 
				$(CC) $(CFLAGS) -g -c analyze.c

lex.yy.o : lex.yy.c scan.h util.h globals.h
				$(CC) $(CFLAGS) -c lex.yy.c

cminus.tab.o : cminus.tab.c lex.yy.c globals.h
				$(CC) $(CFLAGS) -c cminus.tab.c

lex.yy.c : cminus.l globals.h util.h scan.h
				flex cminus.l

cminus.tab.h cminus.tab.c : cminus.y
		bison -d -v cminus.y

code.o : code.h globals.h code.c
		gcc -c code.c

cgen.o : code.h cgen.h util.h globals.h cgen.c
		gcc -c cgen.c

clean :
	rm -f $(OBJECTS) $(TARGET) lex.yy.c cminus.tab.* cminus.output

