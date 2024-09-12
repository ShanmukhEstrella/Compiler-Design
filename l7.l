%{
	#include <stdlib.h>
    #include<bits/stdc++.h>
    using namespace std;
	#include "l7.tab.h"
	void yyerror(string);
	extern char mytext[];
%}

%%

"->" {return ARROW;}
"|"  {return OR;}
"GRAMMAR" {return GRAMMAR;}
"QUERY" {return QUERY;}
"FIRST" {return FIRST;}
"FOLLOW" {return FOLLOW;}
"PROD" {return PROD;}
"eps" {return EPS;}
[A-Z]"\'" {strcpy(yylval.strval,yytext);return NONTERMINAL;}
[A-Z] {strcpy(yylval.strval,yytext);return NONTERMINAL;}
[a-z] {strcpy(yylval.strval,yytext);return TERMINAL;}
"+" {strcpy(yylval.strval,yytext);return TERMINAL;}
"-" {strcpy(yylval.strval,yytext);return TERMINAL;}
"*" {strcpy(yylval.strval,yytext);return TERMINAL;}
"/" {strcpy(yylval.strval,yytext);return TERMINAL;}
"(" {strcpy(yylval.strval,yytext);return TERMINAL;}
")" {strcpy(yylval.strval,yytext);return TERMINAL;}
";" {return SEMICOLON;}
[ \r\t]	     {}
[\n]       {yylineno++;}
.	         {yyerror("unknown charachter");}
%%

int yywrap(void)
{
    return 1;
}
