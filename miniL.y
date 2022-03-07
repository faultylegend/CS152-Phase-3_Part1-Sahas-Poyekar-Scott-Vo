    /* cs152-miniL phase2 */
%{
#include "miniL-parser.h"
#include <stdio.h>
#include <stdlib.h> 
#include <string> 
void yyerror(const char *msg);

extern int yylex();
extern int line;
extern int col;


%}



%union{
  /* put your types here */
  char* op_val;
  int line_val;
  int col_val;
}

%define parse.error verbose
%locations

/* %start program */
%start program

%token FUNCTION IDENTIFIER SEMICOLON BEGIN_PARAMS END_PARAMS BEGIN_LOCALS END_LOCALS BEGIN_BODY END_BODY COLON INTEGER ARRAY L_SQUARE_BRACKET R_SQUARE_BRACKET OF ASSIGN IF THEN ENDIF ELSE WHILE BEGINLOOP ENDLOOP DO READ WRITE CONTINUE BREAK RETURN NOT EQ NEQ LT GT LTE GTE ADD L_PAREN R_PAREN COMMA SUB MULT DIV MOD TRUE FALSE IDENT NUMBER

%type<id_val> NUMBER
%type<id_val> IDENT


%% 

  /* write your rules here */
  program: 
      Functions {
            printf("program -> functions\n");
            $$ = $1;
      }
 
  Functions : 
      {printf("Functions -> epsilon\n");}
      | Function Functions {printf("Functions -> Function Functions\n");}

  Function: 
      FUNCTION IDENTIFIER SEMICOLON BEGIN_PARAMS Declarations END_PARAMS BEGIN_LOCALS Declarations END_LOCALS BEGIN_BODY Statements END_BODY {printf("Function -> FUNCTION IDENTIFIER SEMICOLON BEGIN_PARAMS Declarations END_PARAMS BEGIN_LOCALS Declarations END_LOCALS BEGIN_BODY Statements END_BODY\n");}

  Declarations:  
      {
            printf("Declarations -> epsilon\n");
            char str[100];
            sprintf(str, "");
            $$ = str;
      }
      | Declaration SEMICOLON Declarations {
            printf("Declarations -> Declaration SEMICOLON Declarations\n");
            char str[100];
            sprintf(str, "%s\n%s\n", $1, $3);
      }

  Statements: 
      {
            printf("Statements -> Epsilon\n");
            char str[100];
            sprintf(str, "");
            $$ = str;
      }
      | Statement SEMICOLON Statements {
            printf("Statements -> Statement SEMICOLON Statements\n");
            char str[100];
            sprintf(str, "%s\n%s\n", $1, $3);
      }
            
  Declaration: 
      Identifiers COLON INTEGER {
            printf("Declaration -> Identifiers COLON INTEGER\n");
            std::string check1 = $1;
            if (!find(check1)){
                  char error_str[100];
                  sprintf(error_str, "Unidentified variable: %s\n", $1);
                  yyerror(error_str);
            }
            char str[100];
            sprintf(str, ". %s\n= %s, %s\n", $1, $1, $3);  
            $$ = str;    
      }
      | Identifiers COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF {
            printf("Declaration -> IDENTIFIER COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF\n");
            std::string check1 = $1;
            if (!find(check1)){
                  char error_str[100];
                  sprintf(error_str, "Unidentified variable: %s\n", $1);
                  yyerror(error_str);
            }
            char str[100];
            sprintf(str, ".[] %s, %s\n", $1, $5);   
            $$ = str;   
      }  
  
  Identifiers: 
      Identifier {
            printf("Identifiers -> Identifier\n");
            $$ = $1;      
      }

  Identifier: 
      IDENTIFIER {
            printf("Identifier -> IDENT %s\n", yylval.id_val);
            $$ = $1;      
      }
  
  Statement: 
      variable ASSIGN Expression {printf("Statement -> variable ASSIGN Expression\n");}
      | IF Bool_Exp THEN Statements ENDIF {printf("Statement -> IF Bool_Exp THEN Statements ENDIF\n");}
      | IF Bool_Exp THEN Statements ELSE Statements ENDIF {printf("Statement -> IF Bool_Exp THEN Statements ELSE Statements ENDIF\n");}
      | WHILE Bool_Exp BEGINLOOP Statements ENDLOOP {printf("Statement -> WHILE Bool_Exp BEGINLOOP Statements ENDLOOP\n");}
      | DO BEGINLOOP Statements ENDLOOP WHILE Bool_Exp {printf("Statement -> DO BEGINLOOP Statements ENDLOOP WHILE Bool_Exp\n");}
      | READ variable {printf("Statement -> READ variable\n");}
      | WRITE variable {printf("Statement -> WRITE variable\n");}
      | CONTINUE {printf("Statement -> CONTINUE\n");}
      | BREAK {printf("Statement -> BREAK\n");}
      | RETURN Expression {printf("Statement -> RETURN Expression\n");}
  
  Bool_Exp: 
      {printf("boolexp flag\n");} Nots Expression Comp Expression {printf("Bool_Exp -> Nots Expression Comp Expression\n");}

  Nots:  
      {printf("Nots -> epsilon\n");}
      | NOT Nots {printf("Nots -> NOT Nots\n");}

  Comp: 
      EQ {
            printf("Comp -> EQ\n");
            char str[2] = "==";
            $$ = str;      
      }
      | NEQ {
            printf("Comp -> NEQ\n");
            char str[2] = "!=";
            $$ = str;
      }
      | LT {
            printf("Comp -> LT\n");
            char str[1] = "<";
            $$ = str;      
      }
      | GT {
            printf("Comp -> GT\n");
            char str[1] = ">";
            $$ = str;
      }
      | LTE {
            printf("Comp -> LTE\n");
            char str[2] = "<=";
            $$ = str;      
      }
      | GTE {
            printf("Comp -> GTE\n");
            char str[2] = ">=";
            $$ = str;
      }
  
  Expression: 
      Mult_Expr {printf("Expression -> Mult_Expr\n");}
      | Mult_Expr ADD Mult_Expr {printf("Expression -> Mult_Expr ADD Mult_Expr\n");}
      | Mult_Expr SUB Mult_Expr {printf("Expression -> Mult_Expr SUB Mult_Expr\n");}
  
  Mult_Expr: 
      Term {printf("Mult_Expr -> Term\n");}
      | Term MULT Term {printf("Mult_Expr -> Term MULT Term\n");}
      | Term DIV Term {printf("Mult_Expr -> Term DIV Term\n");}
      | Term MOD Term {printf("Mult_Expr -> Term MOD Term\n");}

  Term: 
      variable {printf("Term -> variable\n");}
      | NUMBER {printf("Term -> NUMBER\n");}
      | L_PAREN Expression R_PAREN {printf("Term -> L_PAREN Expression R_PAREN\n");}
      | IDENTIFIER L_PAREN Expressions R_PAREN {printf("Term -> IDENTIFIER L_PAREN Expressions R_PAREN\n");}

  Expressions: 
      Expression {
            printf("Expressions -> Expression\n");
            $$ = $1;
            }
      | Expression COMMA Expressions {
            printf("Expressions -> Expression COMMA Expressions\n");
            $$ = $1;
      }

  variable: 
      IDENTIFIER {
            printf("variable -> IDENTIFIER\n");
            $$ = $1;
      }
      | IDENTIFIER L_SQUARE_BRACKET Expression R_SQUARE_BRACKET {
            printf("variable -> IDENTIFIER L_SQUARE_BRACKET Expression R_SQUARE_BRACKET\n");
            // save symbol with type = Type::array ?
            $$ = $1;
      }
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