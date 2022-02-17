    /* cs152-miniL phase2 */
%{
#include "miniL-parser.h"
#include <stdio.h>
#include <stdlib.h>  
void yyerror(const char *msg);

extern int yylex();
extern int line;
extern int col;

%}



%union{
  /* put your types here */
  int num_val;
  char* id_val;
  int line_val;
  int col_val;
}

%define parse.error verbose
%locations

/* %start program */
%start program

%token FUNCTION IDENTIFIER SEMICOLON BEGIN_PARAMS END_PARAMS BEGIN_LOCALS END_LOCALS BEGIN_BODY END_BODY COLON INTEGER ARRAY L_SQUARE_BRACKET R_SQUARE_BRACKET OF ASSIGN IF THEN ENDIF ELSE WHILE BEGINLOOP ENDLOOP DO READ WRITE CONTINUE BREAK RETURN NOT EQ NEQ LT GT LTE GTE ADD L_PAREN R_PAREN COMMA SUB MULT DIV MOD TRUE FALSE IDENT NUMBER

%type<num_val> NUMBER
%type<id_val> IDENT


%% 

  /* write your rules here */
  program: Functions {printf("program -> functions\n");}
 
  Functions : {printf("Functions -> epsilon\n");}
        | Function Functions {printf("Functions -> Function Functions\n");}

  Function: FUNCTION IDENTIFIER SEMICOLON BEGIN_PARAMS Declarations END_PARAMS BEGIN_LOCALS Declarations END_LOCALS BEGIN_BODY Statements END_BODY {printf("Function -> FUNCTION IDENTIFIER SEMICOLON BEGIN_PARAMS Declarations END_PARAMS BEGIN_LOCALS Declarations END_LOCALS BEGIN_BODY Statements END_BODY\n");}

  Declarations:  {printf("Declarations -> epsilon\n");}
        | Declaration SEMICOLON Declarations {printf("Declarations -> Declaration SEMICOLON Declarations\n");}

  Statements: {printf("Statements -> Epsilon\n");}
              | Statement SEMICOLON Statements {printf("Statements -> Statement SEMICOLON Statements\n");}
            
  Declaration: Identifiers COLON INTEGER {printf("Declaration -> Identifiers COLON INTEGER\n");}
              | Identifiers COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER{printf("Declaration -> IDENTIFIER COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER\n");}  
  
  Identifiers: Identifier {printf("Identifiers -> Identifier\n");}

  Identifier: IDENTIFIER {printf("Identifier -> IDENT %s\n", yylval.id_val);}
  
  Statement: variable ASSIGN Expression {printf("Statement -> variable ASSIGN Expression\n");}
             | IF Bool_Exp THEN Statements ENDIF {printf("Statement -> IF Bool_Exp THEN Statements ENDIF\n");}
             | IF Bool_Exp THEN Statements ELSE Statements ENDIF {printf("Statement -> IF Bool_Exp THEN Statements ELSE Statements ENDIF\n");}
             | WHILE Bool_Exp BEGINLOOP Statements ENDLOOP {printf("Statement -> WHILE Bool_Exp BEGINLOOP Statements ENDLOOP\n");}
             | DO BEGINLOOP Statements ENDLOOP WHILE Bool_Exp {printf("Statement -> DO BEGINLOOP Statements ENDLOOP WHILE Bool_Exp\n");}
             | READ variable {printf("Statement -> READ variable\n");}
             | WRITE variable {printf("Statement -> WRITE variable\n");}
             | CONTINUE {printf("Statement -> CONTINUE\n");}
             | BREAK {printf("Statement -> BREAK\n");}
             | RETURN Expression {printf("Statement -> RETURN Expression\n");}
  
  Bool_Exp: {printf("boolexp flag\n");} Nots Expression Comp Expression {printf("Bool_Exp -> Nots Expression Comp Expression\n");}

  Nots:  {printf("Nots -> epsilon\n");}
        | NOT Nots {printf("Nots -> NOT Nots\n");}

  Comp: EQ {printf("Comp -> EQ\n");}
        | NEQ {printf("Comp -> NEQ\n");}
        | LT {printf("Comp -> LT\n");}
        | GT {printf("Comp -> GT\n");}
        | LTE {printf("Comp -> LTE\n");}
        | GTE {printf("Comp -> GTE\n");}
  
  Expression: Mult_Expr {printf("Expression -> Mult_Expr\n");}
              | Mult_Expr ADD Mult_Expr {printf("Expression -> Mult_Expr ADD Mult_Expr\n");}
              | Mult_Expr SUB Mult_Expr {printf("Expression -> Mult_Expr SUB Mult_Expr\n");}
  
  Mult_Expr: Term {printf("Mult_Expr -> Term\n");}
             | Term MULT Term {printf("Mult_Expr -> Term MULT Term\n");}
             | Term DIV Term {printf("Mult_Expr -> Term DIV Term\n");}
             | Term MOD Term {printf("Mult_Expr -> Term MOD Term\n");}

  Term: variable {printf("Term -> variable\n");}
        | NUMBER {printf("Term -> NUMBER\n");}
        | L_PAREN Expression R_PAREN {printf("Term -> L_PAREN Expression R_PAREN\n");}
        | IDENTIFIER L_PAREN Expressions R_PAREN {printf("Term -> IDENTIFIER L_PAREN Expressions R_PAREN\n");}

  Expressions: Expression {printf("Expressions -> Expression\n");}
              | Expression COMMA Expressions {printf("Expressions -> Expression COMMA Expressions\n");}

  variable: IDENTIFIER {printf("variable -> IDENTIFIER\n");}
            | IDENTIFIER L_SQUARE_BRACKET Expression R_SQUARE_BRACKET {printf("variable -> IDENTIFIER L_SQUARE_BRACKET Expression R_SQUARE_BRACKET\n");}
%% 

int main(int argc, char **argv) {
   yyparse();
   return 0;
}

void yyerror(const char *msg) {
    /* implement your error handling */
    printf("%s at line: %i, col: %i \n", msg, line - 1, col);
    /* printf("%i %i\n", line - 1, col); */
}