//Steps to compile:

\n1.- flex COMP.l
\n2.- bison -yd COMP.y
\n3.- gcc lex.yy.c y.tab.c -o COMP -lm
