/****************************************************/
/* File: tiny.l										*/
/* Lex specification for TINY						*/
/* Compiler Construction: Principles and Practices	*/
/* Kenneth C. Louden								*/
/* Modifined By Sang Uk								*/
/****************************************************/

%{
#include "globals.h"
#include "util.h"
#include "scan.h"

char tokenString[MAXTOKENLEN+1];
%}

digit       [0-9]
number      {digit}+
letter      [a-zA-Z]
identifier  {letter}+
newline     \n
whitespace  [ \t]+

%%

"if"      	{return IF;}
"else"      {return ELSE;}
"int"		{return INT;}
"return"	{return RETURN;}
"void"		{return VOID;}
"while"		{return WHILE;}
"+"         {return PLUS;}
"-"         {return MINUS;}
"*"         {return TIMES;}
"/"         {return OVER;}
"<"         {return LT;}
"<="		{return LTE;}
">"			{return GT;}
">="		{return GTE;}
"=="		{return EQ;}
"!="		{return NEQ;}
"="			{return ASSIGN;}
";"         {return SEMI;}
","			{return COMMA;}
"("         {return LPAREN;}
")"         {return RPAREN;}
"["			{return LSBRAC;}
"]"			{return RSBRAC;}
"{"			{return LBRAC;}
"}"			{return RBRAC;}
{number}        {return NUM;}
{identifier}    {return ID;}
{newline}       {lineno++;}
{whitespace}    {/* skip whitespace */}
"/*"		{ char c;
				while (1) {
					while (1) {
						c = input();
						if (c != '*' && c != EOF)
						{ if (c == '\n')
							lineno++;
						} else
							break;
					}
					if ( c == '*' )
					{	while (1) 
						{	c = input();
							if ( c != '*' )
								break;
						}
						if ( c == '/' )
						{	break;
						}
					}
					if ( c == '\n' )
						lineno++;
					else if ( c == EOF )
						return COMMENTERROR;
				}
			}
.			{return ERROR;}
%%

TokenType getToken(void) 
{	static int firstTime = TRUE;
  	TokenType currentToken;
	if (firstTime)
	{ firstTime = FALSE;
		lineno++;
		yyin = source;
		yyout = listing;
	}
	currentToken = yylex();
	strncpy(tokenString,yytext,MAXTOKENLEN);
	if (TraceScan) {
	 	fprintf(listing,"\t%d\t",lineno);
		printToken(currentToken,tokenString);
	}
	return currentToken;
}	
