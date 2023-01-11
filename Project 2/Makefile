parser: y.tab.o lex.yy.o
	gcc -o parser y.tab.o lex.yy.o 

lex.yy.o: lex.yy.c y.tab.h
  lex.yy.o y.tab.o: y.tab.c


y.tab.c y.tab.h: CS315f22_team41.y
	yacc -d -v CS315f22_team41.y


lex.yy.c: CS315f22_team41.l
	lex CS315f22_team41.l
 
clean:
	rm -f lex.yy.c lex.yy.o y.tab.c y.tab.h y.tab.o y.output