bison -v -d --file-prefix=y miniL.y

flex miniL.lex

g++ -o parser y.tab.c lex.yy.c -lfl

./parser
