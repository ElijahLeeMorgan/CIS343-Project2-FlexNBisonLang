/*
Flex file, written in Lex.
CIS 343 - Project 2
Elijah Morgan
*/

%option noyywrap
%option yylineno

%{ // Definitions: vars, structs, etc.
#include "zoomjoystrong.h"
#include "zoomjoystrong.tab.h"
#include <string.h>
%}

%%//pattern (regex)  action (C code)
(?i:END)            {return END;}
"."                 {return END_STATEMENT;}
";"                 {return END_STATEMENT;} // The language_creation.pdf file wants "." as the end statement, but the sample program uses ";". Implementing both just in case.
(?i:POINT)          {return POINT;}
(?i:LINE)           {return LINE;}
(?i:CIRCLE)         {return CIRCLE;}
(?i:RECTANGLE)      {return RECTANGLE;}
(?i:SET_COLOR)      {return SET_COLOR;}
[0-9]+              {yylval.inum = atoi(yytext); return INT;}
[0-9]+\.[0-9]+      {yylval.fnum = atof(yytext); return FLOAT;}
\$.                 {yylval.sval = strdup(yytext + 1); return VARIBLE;} // vars '$i'
"="                 {return EQUALS;}
"+"                 {return PLUS;}
"-"                 {return MINUS;}
"*"                 {return MULT;}
"//".*              {} // Inline Comments
"/"                 {return DIV;}
[ \t\n]             {} // Whitespace
.                   {
                        printf("Line %d: Unrecognized character '%s'\n", 
                        yylineno, yytext); 
                        exit(1); 
                    }
%%
