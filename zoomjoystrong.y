/*
Bison file.
CIS 343 - Project 2
Elijah Morgan
*/

%{
#include <stdio.h>
#include <stdlib.h>
#include "zoomjoystrong.h"

#define MAX_VARS 128

typedef struct {
    char name;
    float value;
    int initialized;
} symbol;

symbol symbol_table[MAX_VARS];

void set_variable(char name, float value) {
    symbol_table[(int)name].name = name;
    symbol_table[(int)name].value = value;
    symbol_table[(int)name].initialized = 1;
}

float get_variable(char name) {
    if (!symbol_table[(int)name].initialized) {
        fprintf(stderr, "Error: Variable '%c' not defined\n", name);
        return 0.0;
    }
    return symbol_table[(int)name].value;
}
%}

%union {
    int inum;      // For numbers
    char *sval;    // For strings/identifiers
    float fnum;    // For floats
}

%token END END_STATEMENT POINT LINE CIRCLE RECTANGLE SET_COLOR
%token EQUALS PLUS MINUS MULT DIV
%token <inum> INT
%token <fnum> FLOAT
%token <sval> VARIBLE

%type <fnum> expr

%left PLUS MINUS
%left MULT DIV


%%
program:
    /* empty */
    | program statement
    ;

statement:
    /* zoomjoystrong doesn't support float parameters, so I truncate floats to ints to keep things flowing */

      VARIBLE '=' expr END_STATEMENT                            { printf("Assignment"); }
    | expr END_STATEMENT                                        { printf("Expression"); }
    | END_STATEMENT                                             { printf("\t\tEnd Statement\n"); }
    | POINT expr ',' expr END_STATEMENT                         { 
                                                                    if ($2 < 0 || $4 < 0) {
                                                                        fprintf(stderr, "Error: Point coordinates must be non-negative\n");
                                                                    } else {
                                                                        printf("Point");
                                                                        point((int)$2, (int)$4); 
                                                                    }
                                                                }
    | LINE expr ',' expr ',' expr ',' expr END_STATEMENT        { 
                                                                    if ($2 < 0 || $4 < 0 || $6 < 0 || $8 < 0) {
                                                                        fprintf(stderr, "Error: Line coordinates must be non-negative\n");
                                                                    } else {
                                                                        printf("Line");
                                                                        line((int)$2, (int)$4, (int)$6, (int)$8);
                                                                    }
                                                                }
    | CIRCLE expr ',' expr ',' expr END_STATEMENT               { 
                                                                    if ($2 < 0 || $4 < 0 || $6 < 0) {
                                                                        fprintf(stderr, "Error: Circle coordinates and radius must be non-negative\n");
                                                                    } else {
                                                                        printf("Circle");
                                                                        circle((int)$2, (int)$4, (int)$6);
                                                                    }
                                                                }
    | RECTANGLE expr ',' expr ',' expr ',' expr END_STATEMENT   { 
                                                                    if ($2 < 0 || $4 < 0 || $6 < 0 || $8 < 0) {
                                                                        fprintf(stderr, "Error: Rectangle coordinates and dimensions must be non-negative\n");
                                                                    } else {
                                                                        printf("Rectangle");
                                                                        rectangle((int)$2, (int)$4, (int)$6, (int)$8);
                                                                    }
                                                                }
    | SET_COLOR expr ',' expr ',' expr END_STATEMENT            { 
                                                                    if ($2 < 0 || $2 > 255 || $4 < 0 || $4 > 255 || $6 < 0 || $6 > 255) {
                                                                        fprintf(stderr, "Error: Color values must be 0-255\n");
                                                                    } else {
                                                                        printf("Set color");
                                                                        set_color((int)$2, (int)$4, (int)$6);
                                                                    }
                                                                }
    | END                                                       { printf("End of Input\n"); finish(); exit(0); }
    ;

expr:
      INT                                                       { $$ = (float)$1; }
    | FLOAT                                                     { $$ = $1; }
    | VARIBLE                                                   { $$ = get_variable($1[0]); }
    | expr PLUS expr                                            { $$ = $1 + $3; }
    | expr MINUS expr                                           { $$ = $1 - $3; }
    | expr MULT expr                                            { $$ = $1 * $3; }
    | expr DIV expr                                             { 
                                                                    if ($3 == 0.0) {
                                                                        fprintf(stderr, "Error: Division by zero\n");
                                                                        $$ = 0.0;
                                                                    } else {
                                                                        $$ = $1 / $3;
                                                                    }
                                                                }
    ;

%%
