CC = gcc
CFLAG = 
OBJECTS = main.o util.o lex.yy.o
TARGET = 20141522

all : $(TARGET)

$(TARGET) : $(OBJECTS)
			$(CC) $(CFLAGS) -o $(TARGET) $(OBJECTS) -lfl

main.o : main.c globals.h util.h scan.h parse.h analyze.h cgen.h
			$(CC) $(CFLAGS) -c main.c

util.o : util.c util.h globals.h
			$(CC) $(CFLAGS) -c util.c

lex.yy.o : lex.yy.c scan.h
			$(CC) $(CFLAGS) -c lex.yy.c

lex.yy.c : tiny.l
			flex tiny.l

clean :
			rm -f $(OBJECTS) $(TARGET) lex.yy.c
