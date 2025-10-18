/*
Bison file.
CIS 343 - Project 2
Elijah Morgan
*/

%{
#include <stdio.h>
#include <stdlib.h>
%}

%union {
    int inum;      // For numbers
    char *sval;    // For strings/identifiers
    float fnum;    // For floats
}

%token <statement> END END_STATEMENT POINT LINE CIRCLE RECTANGLE SET_COLOR
%token <op> EQUALS PLUS MINUS MULT DIV
%token <num> INT FLOAT
%token <id> VARIBLE

%left PLUS MINUS
%left MULT DIV


%%
program:
    /* empty */
    | program statement
    ;

statement:
      VARIBLE '=' expr END_STATEMENT                              { printf("Assignment\n"); }
    | expr END_STATEMENT                                          { printf("Expression\n"); }
    | END_STATEMENT                                               { printf("\tEnd Statement\n"); }
    | POINT  expr ',' expr  END_STATEMENT                         { printf("Point (X: %d, Y: %d)\n", $2, $4); point($2, $4); }
    | LINE  expr ',' expr ',' expr ',' expr  END_STATEMENT        { printf("Line (X1: %d, Y1: %d, X2: %d, Y2: %d)\n", $2, $4, $6, $8); line($2, $4, $6, $8); }
    | CIRCLE  expr ',' expr ',' expr  END_STATEMENT               { printf("Circle (X: %d, Y: %d, R: %d)\n", $2, $4, $6); circle($2, $4, $6); }
    | RECTANGLE  expr ',' expr ',' expr ',' expr  END_STATEMENT   { printf("Rectangle (X: %d, Y: %d, W: %d, H: %d)\n", $2, $4, $6, $8); rectangle($2, $4, $6, $8); }
    | SET_COLOR  expr ',' expr ',' expr  END_STATEMENT            { printf("Set Color (R:%d G: %d B: %d)\n", $2, $4, $6); set_color($2, $4, $6);}
    | END                                                         { printf("End of Input\n"); finish(); exit(0); }
    ;

expr:
      NUMBER
    | VARIBLE
    | expr PLUS expr
    | expr MINUS expr
    | expr MULT expr
    | expr DIV expr
    ;

%%
