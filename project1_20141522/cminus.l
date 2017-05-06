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
void PushName(char *);
char *savedName[STACKSIZE];
char *tempName;
int top_name=-1;
%}

digit       [0-9]
number      {digit}+
letter      [a-zA-Z]
identifier  {letter}+
newline     \n
whitespace  [ \t]+

%%

"if"            {return IF;}
"else"          {return ELSE;}
"int"			{return INT;}
"while"			{return WHILE;}
"return"		{return RETURN;}
"void"			{return VOID;}
"=="			{return SAME;}
"!="			{return DIFF;}
"="             {return ASSIGN;}
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
{identifier}    {tempName=copyString(yytext); return ID;}
{newline}       {lineno++;}
{whitespace}    {/* skip whitespace */}
"/*"            { char c;
				  char flag=FALSE;
                  while(c!=EOF){
					c=input();
					if(c=='\n') lineno++;
					if(c=='/' && flag)
						break;
					else if(c=='*') flag=TRUE;
					else flag=FALSE;
				  }
				  if( c==EOF ) return COMMENTERR;
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
  fprintf(listing, "%d: %d %s\n",lineno,currentToken,tokenString);
  if (TraceScan) {
    fprintf(listing,"\t%d\t\t ",lineno);
    printToken(currentToken,tokenString);
  }
  return currentToken;
}

void PushName(char* name){
	if(top_name<STACKSIZE-1){
		savedName[++top_name]=copyString(name);
	}	
	else{
		fprintf(listing,"Name Stack is Full\n");
		Error=TRUE;
	}
}
