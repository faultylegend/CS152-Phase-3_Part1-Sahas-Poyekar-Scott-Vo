    /* cs152-miniL phase2 */
%{
#include "miniL-parser.h"
#include <stdio.h>
#include <stdlib.h>  

#include <string>
#include <string.h>
#include <vector>

enum Type { Integer, Array };
struct Symbol {
  std::string name;
  Type type;
};
struct Function {
  std::string name;
  std::vector<Symbol> declarations;
};

std::vector <Function> symbol_table;


Function *get_function() {
  // gets the symbol at the top of the stack
  int last = symbol_table.size()-1;
  return &symbol_table[last];
}

bool find(std::string &value) {
  Function *f = get_function();
  for(int i=0; i < f->declarations.size(); i++) {
    Symbol *s = &f->declarations[i];
    if (s->name == value) {
      return true;
    }
  }
  return false;
}

void add_function_to_symbol_table(std::string &value) {
  Function f; 
  f.name = value; 
  symbol_table.push_back(f);
}

void add_variable_to_symbol_table(std::string &value, Type t) {
  Symbol s;
  s.name = value;
  s.type = t;
  Function *f = get_function();
  f->declarations.push_back(s);
}

void print_symbol_table(void) {
  printf("symbol table:\n");
  printf("--------------------\n");
  for(int i=0; i<symbol_table.size(); i++) {
    printf("function: %s\n", symbol_table[i].name.c_str());
    for(int j=0; j<symbol_table[i].declarations.size(); j++) {
      printf("  locals: %s\n", symbol_table[i].declarations[j].name.c_str());
    }
  }
  printf("--------------------\n");
}

std::string output_string;

struct CodeNode {
      std::string code;
      std::string name;
      bool arr = false;
      
      ~CodeNode(){
            //write to
      }
};

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
  struct Function func;
  struct Symbol symb;
}

%define parse.error verbose
%locations

/* %start program */
%start program

%token FUNCTION IDENTIFIER SEMICOLON BEGIN_PARAMS END_PARAMS BEGIN_LOCALS END_LOCALS BEGIN_BODY END_BODY COLON INTEGER ARRAY L_SQUARE_BRACKET R_SQUARE_BRACKET OF ASSIGN IF THEN ENDIF ELSE WHILE BEGINLOOP ENDLOOP DO READ WRITE CONTINUE BREAK RETURN NOT EQ NEQ LT GT LTE GTE ADD L_PAREN R_PAREN COMMA SUB MULT DIV MOD TRUE FALSE IDENT NUMBER

%token <code_node> CODE

%type <symb> Function Declarations Declaration variable Expression Identifiers Expressions Bool_Exp Mult_Expr Comp Term
%type <func> Statement Statements 

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
  
  Identifiers: Identifier {printf("Identifiers -> Identifier\n");
              }

  Identifier: IDENTIFIER {printf("Identifier -> IDENT %s\n", yylval.id_val);
            }
  
  Statement: variable ASSIGN Expression {
                  std::string var_name = $1;
                  std::string error;
                  if (!find(var_name)) {
                        yyerror(error.c_str());
                  }

                  CodeNode *node = new CodeNode;
                  node->code = $3->code; 
                  node->code += std::string("= ") + var_name + std::string(", ") + $3->name + std::string("\n");
                  node->name = var_name;
                  $$ = node;
            }
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

  Comp: EQ {CodeNode *node = new CodeNode;
            node->code = "";
            node->name = "== ";

            $$ = node;
            }
        | NEQ {CodeNode *node = new CodeNode;
            node->code = "";
            node->name = "!= ";

            $$ = node;
            }
        | LT {CodeNode *node = new CodeNode;
            node->code = "< ";
            node->name = "< ";

            $$ = node;
            }
        | GT {CodeNode *node = new CodeNode;
            node->code = "";
            node->name = "> ";

            $$ = node;
            }
        | LTE {CodeNode *node = new CodeNode;
            node->code = "";
            node->name = "<= ";

            $$ = node;
            }
        | GTE {CodeNode *node = new CodeNode;
            node->code = "";
            node->name = ">= ";

            $$ = node;
            }
  
  Expression: Mult_Expr {printf("Expression -> Mult_Expr\n");}
              | Mult_Expr ADD Mult_Expr {
                    std::string temp = create_temp();
                    CodeNode *node = new CodeNode;
                    node->code = $1->code + $3->code + decl_temp_code(temp);
                    node->code += std::string("+ ") + temp + std::strings(", ") + $1->name + std::string(", ") + $3->name + std::string("\n");
                    node->name = temp;
                    $$ = node;
              }
              | Mult_Expr SUB Mult_Expr {
                    std::string temp = create_temp();
                    CodeNode *node = new CodeNode;
                    node->code = $1->code + $3->code + decl_temp_code(temp);
                    node->code += std::string("- ") + temp + std::strings(", ") + $1->name + std::string(", ") + $3->name + std::string("\n");
                    node->name = temp;
                    $$ = node;
              }
  
  Mult_Expr: Term {printf("Mult_Expr -> Term\n");}
             | Term MULT Term {
                    std::string temp = create_temp();
                    CodeNode *node = new CodeNode;
                    node->code = $1->code + $3->code + decl_temp_code(temp);
                    node->code += std::string("* ") + temp + std::strings(", ") + $1->name + std::string(", ") + $3->name + std::string("\n");
                    node->name = temp;
                    $$ = node;
              }
             | Term DIV Term {
                    std::string temp = create_temp();
                    CodeNode *node = new CodeNode;
                    node->code = $1->code + $3->code + decl_temp_code(temp);
                    node->code += std::string("/ ") + temp + std::strings(", ") + $1->name + std::string(", ") + $3->name + std::string("\n");
                    node->name = temp;
                    $$ = node;
              }
             | Term MOD Term {
                    std::string temp = create_temp();
                    CodeNode *node = new CodeNode;
                    node->code = $1->code + $3->code + decl_temp_code(temp);
                    node->code += std::string("% ") + temp + std::strings(", ") + $1->name + std::string(", ") + $3->name + std::string("\n");
                    node->name = temp;
                    $$ = node;
              }

  Term: variable {
    std::string temp;
    std::string temp_name = create_temp();

    temp += $1->code;
    add_variable_to_symbol_table(temp,$1->type);

    }
        | NUMBER {printf("Term -> NUMBER\n");}
        | L_PAREN Expression R_PAREN {printf("Term -> L_PAREN Expression R_PAREN\n");}
        | IDENTIFIER L_PAREN Expressions R_PAREN {printf("Term -> IDENTIFIER L_PAREN Expressions R_PAREN\n");}

  Expressions: Expression {printf("Expressions -> Expression\n");}
              | Expression COMMA Expressions {printf("Expressions -> Expression COMMA Expressions\n");}

  variable: IDENTIFIER {
                  CodeNode *node = new CodeNode;
                  node->code = "";
                  node->name = yylval.id_val;
                  std::string error;
                  if (!find(node->name, INTEGER, error)) {
                        yyerror(error.c_str());
                  }
                  $$ = node;
            }
            | IDENTIFIER L_SQUARE_BRACKET Expression R_SQUARE_BRACKET {
                  CodeNode *node = new CodeNode;
                  node->code = $3.code;
                  std::string temp = yylval.id_val;
                  
                  temp += std::string(", ") + std::string($3.name);
                  node->name = temp;
                  $$ = node;

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