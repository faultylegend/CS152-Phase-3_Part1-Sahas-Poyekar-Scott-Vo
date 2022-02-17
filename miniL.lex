   /* cs152-miniL phase1 - adding text to create new commit message*/
   
%{   
   /* write your C code here for definitions of variables and including headers */
   #include "y.tab.h"
   #include "miniL-parser.h"
   int line = 1;
   int col = 1;
%}

   /* some common rules */
DIGIT    [0-9]
CHAR [a-z|A-Z]
UNDER [_]
IDENTIFIER {CHAR}({CHAR}|{DIGIT}|{UNDER})*
COMMENT {.}*

%%
   /* specific lexer rules in regex */
"function"	   {col += yyleng; yylval.line_val = line; yylval.col_val = col; return FUNCTION;}
"beginparams"	{col += yyleng; yylval.line_val = line; yylval.col_val = col; return BEGIN_PARAMS;} 
"endparams"	   {col += yyleng; yylval.line_val = line; yylval.col_val = col; return END_PARAMS;}
"beginlocals"	{col += yyleng; yylval.line_val = line; yylval.col_val = col; return BEGIN_LOCALS;}
"endlocals"	   {col += yyleng; yylval.line_val = line; yylval.col_val = col; return END_LOCALS;}
"beginbody"	   {col += yyleng; yylval.line_val = line; yylval.col_val = col; return BEGIN_BODY;}
"endbody"	   {col += yyleng; yylval.line_val = line; yylval.col_val = col; return END_BODY;}
"integer"	   {col += yyleng; yylval.line_val = line; yylval.col_val = col; return INTEGER;}
"array"	      {col += yyleng; yylval.line_val = line; yylval.col_val = col; return ARRAY;}
"of"	         {col += yyleng; yylval.line_val = line; yylval.col_val = col; return OF;}
"if"	         {col += yyleng; yylval.line_val = line; yylval.col_val = col; return IF;}
"then"	      {col += yyleng; yylval.line_val = line; yylval.col_val = col; return THEN;}
"endif"	      {col += yyleng; yylval.line_val = line; yylval.col_val = col; return ENDIF;}
"else"	      {col += yyleng; yylval.line_val = line; yylval.col_val = col; return ELSE;}
"while"        {col += yyleng; yylval.line_val = line; yylval.col_val = col; return WHILE;}
"do"	         {col += yyleng; yylval.line_val = line; yylval.col_val = col; return DO;}
"beginloop"	   {col += yyleng; yylval.line_val = line; yylval.col_val = col; return BEGINLOOP;}
"endloop"	   {col += yyleng; yylval.line_val = line; yylval.col_val = col; return ENDLOOP;}
"continue"	   {col += yyleng; yylval.line_val = line; yylval.col_val = col; return CONTINUE;}
"break"	      {col += yyleng; yylval.line_val = line; yylval.col_val = col; return BREAK;}
"read"	      {col += yyleng; yylval.line_val = line; yylval.col_val = col; return READ;}
"write"	      {col += yyleng; yylval.line_val = line; yylval.col_val = col; return WRITE;} 
"not"	         {col += yyleng; yylval.line_val = line; yylval.col_val = col; return NOT;}
"true"	      {col += yyleng; yylval.line_val = line; yylval.col_val = col; return TRUE;}
"false"	      {col += yyleng; yylval.line_val = line; yylval.col_val = col; return FALSE;} 
"return"	      {col += yyleng; yylval.line_val = line; yylval.col_val = col; return RETURN;} 


"-"	{col += yyleng; return SUB;} 
"+"	{col += yyleng; return ADD;} 
"*"	{col += yyleng; return MULT;}
"/"	{col += yyleng; return DIV;}
"%"	{col += yyleng; return MOD;}
"##".*  ;


"=="	{col += yyleng; return EQ;}
"<>"	{col += yyleng; return NEQ;}
"<"	{col += yyleng; return LT;}
">"	{col += yyleng; return GT;} 
"<="	{col += yyleng; return LTE;} 
">="	{col += yyleng; return GTE;} 


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
{DIGIT}+     {col += yyleng; yylval.num_val = atoi(yytext); return NUMBER;} 


" "   col++;
\t    col += 4;
\n    {line++; col = 1; }
[^ ^\n^\t]     {
               printf("\nERROR at line %d, column %d: unrecognized symbol \"%s\"\n", line, col, yytext);
               exit(1);
            }

%%
	/* C functions used in lexer */
/*
int main(int argc, char ** argv)
{

   yylex();
} */
