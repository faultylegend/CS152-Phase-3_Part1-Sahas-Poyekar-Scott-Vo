

bison -v -d --file-prefix=y miniL.y

flex miniL.lex

gcc -o parser y.tab.c lex.yy.c -lfl

./parser
