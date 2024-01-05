//Steps to compile:

1.- flex COMP.l |
2.- bison -yd COMP.y |
3.- gcc lex.yy.c y.tab.c -o COMP -lm
