/*
Flex file, written in Lex.
CIS 343 - Project 2
Elijah Morgan
*/

%{ // Definitions: vars, structs, etc.
#include <zoomjoystrong.tab.h>
#include <string.h>
%}

//NOTE Keep your C code simple, logic is handled in Bison.
// Flex is to words, as Bison is to understanding, as C is to action
%%//pattern (regex)  action (C code)
(?i:END)            {return END;}
(?i:END_STATEMENT)  {return END_STATEMENT;}
(?i:POINT)          {return POINT;}
(?i:LINE)           {return LINE;}
(?i:CIRCLE)         {return CIRCLE;}
(?i:RECTANGLE)      {return RECTANGLE;}
(?i:SET_COLOR)      {return SET_COLOR;}
[0-9]+              {yylval.inum = atoi(yytext); return INT;}
[0-9]*\.[0-9]+      {yylval.inum = atof(yytext); return FLOAT;}
\$.                 {yytext[1]; return VARIBLE;} // vars '$i'
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
