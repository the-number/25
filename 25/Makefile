
CC = gcc
YACC = bison
LDADD = -lm

bison-rpcalc: bison-rpcalc.tab.o
	$(CC) $(LDADD) -o $@ $<

bison-rpcalc.tab.o: bison-rpcalc.tab.c
	$(CC) -c $<

bison-rpcalc.tab.c: bison-rpcalc.y
	$(YACC) $<
