   /* cs152-miniL */

%{
   /* write your C code here for defination of variables and including headers */
#include "miniL-parser.hpp"

%}

   /* some common rules, for example DIGIT */
DIGIT    [0-9]
   
%%
   /* specific lexer rules in regex */

<<<<<<< HEAD

";"	{col += yyleng; return SEMICOLON;} 
":"	{col += yyleng; return COLON;}
","	{col += yyleng; return COMMA;} 
"("	{col += yyleng; return L_PAREN;} 
")"	{col += yyleng; return R_PAREN;} 
"["	{col += yyleng; return L_SQUARE_BRACKET;} 
"]"	{col += yyleng; return R_SQUARE_BRACKET;} 
":="	{col += yyleng; return ASSIGN;} 

({DIGIT}|{UNDER}){IDENTIFIER} {
                                 printf("\nERROR at line %d, column %d: identifier \"%s\" must begin with a letter\n", line, col, yytext);
                                 exit(1);
                              }

{IDENTIFIER}{UNDER} {
                        printf("\nERROR at line %d, column %d: identifier \"%s\" cannot end with an underscore\n", line, col, yytext);
                        exit(1);
                     }

{DIGIT}+{IDENTIFIER} {
                        printf("\nERROR at line %d, column %d: identifier \"%s\" must begin with a letter\n", line, col, yytext);
                        exit(1);
                     }

{IDENTIFIER} {col += yyleng; yylval.id_val=malloc(yyleng+1); strcpy(yylval.id_val, yytext); return IDENTIFIER;} 
{DIGIT}+     {col += yyleng; yylval.num_val = (int)atoi((char*)yytext); return NUMBER;} 


" "   col++;
\t    col += 4;
\n    {line++; col = 1; }
[^ ^\n^\t]     {
               printf("\nERROR at line %d, column %d: unrecognized symbol \"%s\"\n", line, col, yytext);
               exit(1);
            }
=======
{DIGIT}+       {printf("NUMBER %s\n", yytext); yylval.int_val = atoi(yytext); return DIGIT; }
>>>>>>> parent of afd202b... Adding Phase 2 code

%%
	/* C functions used in lexer */
   /* remove your original main function */