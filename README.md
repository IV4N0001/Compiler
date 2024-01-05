//Steps to compile:

flex COMP.l     ||
bison -yd COMP.y    ||
gcc lex.yy.c y.tab.c -o COMP -lm
