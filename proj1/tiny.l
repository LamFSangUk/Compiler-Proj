/****************************************************/
/* File: tiny.l                                     */
/* Lex specification for TINY                       */
/* Compiler Construction: Principles and Practice   */
/* Kenneth C. Louden                                */
/* Modified By SangUk                               */
/****************************************************/

%{
#include "globals.h"
#include "util.h"
#include "scan.h"
/* lexeme of identifier or reserved word */
char tokenString[MAXTOKENLEN+1];
%}

digit       [0-9]
number      {digit}+
letter      [a-zA-Z]
identifier  {letter}+
newline     \n
whitespace  [ \t]+

%%

"if"            {return IF;}
"then"          {return THEN;}
"else"          {return ELSE;}
"end"           {return END;}
"repeat"        {return REPEAT;}
"until"         {return UNTIL;}
"read"          {return READ;}
"write"         {return WRITE;}
"int"			{return INT;}
"while"			{return WHILE;}
"return"		{return RETURN;}
":="            {return ASSIGN;}
"=="			{return SAME;}
"!="			{return DIFF;}
"="             {return EQ;}
"<"             {return LT;}
"<="			{return LE;}
">"				{return GT;}
">="			{return GE;}
"+"             {return PLUS;}
"-"             {return MINUS;}
"*"             {return TIMES;}
"/"             {return OVER;}
"("             {return LPAREN;}
")"             {return RPAREN;}
"{"				{return LQBRACE;}
"}"				{return RQBRACE;}
"["				{return LSBRACE;}
"]"				{return RSBRACE;}
","				{return COMMA;}
";"             {return SEMI;}
{number}        {return NUM;}
{identifier}    {return ID;}
{newline}       {lineno++;}
{whitespace}    {/* skip whitespace */}
"/*"            { char c;
				  char flag=FALSE;
                  while(c!=EOF){
					c=input();
					if(c=='\n') lineno++;
					if(c=='/' && flag)
						return COMMENT;
					else if(c=='*') flag=TRUE;
					else flag=FALSE;
				  }
				  return COMMENTERR;
                }
.               {return ERROR;}

%%

TokenType getToken(void)
{ static int firstTime = TRUE;
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
    if(currentToken!=COMMENT) fprintf(listing,"\t%d\t\t ",lineno);
    printToken(currentToken,tokenString);
  }
  return currentToken;
}

