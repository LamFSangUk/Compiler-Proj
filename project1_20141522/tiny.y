/****************************************************/
/* File: tiny.y                                     */
/* The TINY Yacc/Bison specification file           */
/* Compiler Construction: Principles and Practice   */
/* Kenneth C. Louden                                */
/* Modified By Sang Uk                              */
/****************************************************/
%{
#define YYPARSER /* distinguishes Yacc output from other code files */

#include "globals.h"
#include "util.h"
#include "scan.h"
#include "parse.h"

#define YYSTYPE TreeNode *
static char * savedName; /* for use in assignments */
static int savedSize;
static int savedNum;
static DclrExpType savedType;
static int savedLineNo;  /* ditto */
static TreeNode * savedTree; /* stores syntax tree for later return */

%}

%token IF ELSE INT WHILE RETURN VOID 
%token ID NUM COMMENT
%token SAME DIFF
%token ASSIGN LT LE GT GE PLUS MINUS TIMES OVER LPAREN RPAREN LQBRACE RQBRACE LSBRACE RSBRACE COMMA SEMI
%token ERROR COMMENTERR ENDFILE 

%% /* Grammar for TINY */

program     : dclr_list
                 { savedTree = $1;} 
            ;
dclr_list   : dclr_list dclr
                 { YYSTYPE t = $1;
                   if (t != NULL)
                   { while (t->sibling != NULL)
                        t = t->sibling;
                     t->sibling = $2;
                     $$ = $1; }
                     else $$ = $2;
                 }
            | dclr { $$ = $1; }
            ;
dclr		: var_dclr	{ $$ = $1; }
			| func_dclr	{ $$ = $1; }
			;
var_dclr	: type_spcf ID
				{ savedName = copyString(tokenString);
				  savedLineNo = lineno;
				} 
			  SEMI
				{ $$ = newDclrNode(VarK); 
				  $$->lineno = savedLineNo;
				  $$->attr.name = savedName;
				  $$->type = savedType;
				}
			| type_spcf ID 
				{ savedName = copyString(tokenString);
				  savedLineNo = lineno;
				}
			  LSBRACE NUM
				{ savedSize = atoi(tokenString); } 
			  RSBRACE SEMI
				{ $$ = newDclrNode(VarArrK); 
				  $$->lineno = savedLineNo;
				  $$->attr.name = savedName;
				  $$->type = savedType;
				}
			;
type_spcf	: INT	{ savedType = Integer; }
			| VOID	{ savedType = Void; }
			;
func_dclr	: type_spcf ID
				{ savedName = copyString(tokenStirng);
				  savedLineNo = lineno;
				}
			  LPAREN params RPAREN compstmt
				{ $$ = newDclrNode(FuncK);	
				  $$->child[0] = $1;
				  $$->child[1] = $5;
				  $$->child[2] = $7;
				  $$->lineno = savedLineNo;
				  $$->attr.name = savedName;
				}
			;
params		: para_list
				{ $$ = $1; }
			| VOID
			    { $$ = newExpNode(TypeK);
				  $$->type = Void;
				}
			;
para_list	: para_list COMMA param
				{ YYSTYPE t = $1;
				  if (t != NULL)
				  { 
					while(t->sibling != NULL)
						t = t->sibling;
					t->sibling = $3;
					$$ = $1;
				  }
				  else $$ = $3;
				}
			| param { $$ = $1; }
			; 
param 		: type_spcf ID
				{ $$ = newDclrNode(VarK);
				  $$->child[0] = $1;
				  $$->lineno = lineno;
				  $$->attr.name = copyString(tokenString);
				}
			| type_spcf ID
				{ savedName = copyString(tokenString);
				  savedLineNo = lineno;
				}
			  LSBRACE RSBRACE
				{ $$ = newDclrNode(VarArrK);
				  $$->child[0] = $1;
				  $$->lineno = savedLineNo;
				  $$->attr.name = savedName;
				}
			;
compstmt	: LQBRACE local_dclr stmt_list RQBRACE
				{ $$ = newStmtNode(CompK);
				  $$->child[0] = $2;
				  $$->child[1] = $3;
				}
			;
local_dclr	: local_dclr var_dclr
			 	{ YYSTYPE t = $1;
				  if (t != NULL)
				  {
					while(t->sibling != NULL)
						t = t->sibling;
					t->sibling = $2;
					$$ = $1;
				  }
				  else $$ = $2;
				}
			| /* empty */
				{ $$ = NULL; }
			;
stmt_list	: stmt_list stmt
				{ YYSTYPE t = $1;
				  if (t != NULL)
				  {
					while(t->sibling != NULL)
						t = t->sibling;
					t->sibling = $2;
					$$ = $1;
				  }
				  else $$ = $2;
				} /* empty */
				{ $$ = NULL; }
			|
			;
stmt		: expstmt	{ $$ = $1; }
			| compstmt	{ $$ = $1; }
			| selstmt	{ $$ = $1; }
			| iterstmt	{ $$ = $1; }
			| retstmt	{ $$ = $1; }
			;
expstmt		: exp SEMI	{ $$ = $1; }
			| SEMI		{ $$ = NULL; }
			;
selstmt		: IF LPAREN exp RPAREN stmt
				{ $$ = newStmtNode(IfK);
				  $$->child[0] = $3;
				  $$->child[1] = $5;
				}
			| IF LPAREN exp RPAREN stmt ELSE stmt
				{ $$ = newStmtNode(IfelseK);
				  $$->child[0] = $3;
				  $$->child[1] = $5;
				  $$->child[2] = $7;
				}
			;
iterstmt	: WHILE LPAREN exp RPAREN stmt
				{ $$ = newStmtNode(WhileK);
				  $$->child[0] = $3;
				  $$->child[1] = $5;
				}
			;
retstmt		: RETURN SEMI
				{ $$ = newStmtNode(ReturnK); }
			| RETURN exp SEMI
				{ $$ = newStmtNode(ReturnK);
				  $$->child[0] = $2;
				}
			;
exp			: var ASSIGN exp
				{ $$ = newExpNode(OpK);
				  $$->child[0] = $1;
				  $$->child[1] = $3;
				  $$->attr.op = ASSIGN;
				}
			| smpl_exp { $$ = $1; }
			;
var			: ID 
				{ $$ = newExpNode(IdK); 
				  $$->attr.name = copyString(tokenString);
				}
			| ID
				{ savedName = copyString(tokenString); }
			  LSBRACE exp RSBRACE
				{ $$ = newExpNode(ArrK);
				  $$->child[0] = $4;
				  $$->attr.name=savedName;
				}
			;
smpl_exp	: addexp relop addexp
				{ $$ = $2;
				  $$->child[0] = $1;
				  $$->child[1] = $3;
				}
			| addexp { $$ = $1; }
			;
relop		: LE
				{ $$ = newExpNode(OpK);
			 	  $$->attr.op = LE;
				}
			| LT
				{ $$ = newExpNode(OpK);
			 	  $$->attr.op = LT;
				}
			| GT 
				{ $$ = newExpNode(OpK);
			 	  $$->attr.op = GT;
				}
			| GE
				{ $$ = newExpNode(OpK);
			 	  $$->attr.op = GE;
				}	
			| SAME
				{ $$ = newExpNode(OpK);
			 	  $$->attr.op = SAME;
				}
			| DIFF 
				{ $$ = newExpNode(OpK);
				  $$->attr.op = DIFF;
				}	
			;
addexp		: addexp addop term
				{ $$ = $2;
				  $$->child[0] = $1;
				  $$->child[1] = $3;
				}
			| term { $$ = $1; }
			;
addop		: PLUS	
				{ $$ = newExpNode(OpK);
			 	  $$->attr.op = PLUS;
				}
			| MINUS
				{ $$ = newExpNode(OpK);
			 	  $$->attr.op = MINUS;
				}
			;
term		: term mulop factor
				{ $$ = $2;
				  $$->child[0] = $1;
				  $$->child[1] = $3;
				}
			| factor { $$ = $1; }
			;
mulop		: TIMES	
				{ $$ = newExpNode(OpK);
			 	  $$->attr.op = TIMES;
				}
			| OVER	
				{ $$ = newExpNode(OpK);
			 	  $$->attr.op = OVER;
				}
			;
factor		: LPAREN exp RPAREN { $$ = $2; }
			| var	{ $$ = $1; }
			| call	{ $$ = $1; }
			| NUM
				{ $$ = newExpNode(ConstK);
				  $$->attr.val = atoi(tokenString);
			;
call		: ID { savedName = copyString(tokenString); }
			   LPAREN args RPAREN
				{ $$ = newExpNode(CallK);
				  $$->child[0] = $4;
				  $$->attr.name = savedName;
				}
			;
args		: arg_list { $$ = $1; }
			| /* empty */
			;
arg_list	: arg_list COMMA exp
				{ YYSTYPE t = $1;
				  if (t!= NULL)
				  { while(t->sibling != NULL)
					  t = t->sibling;
					t->sibling = $3;
					$$ = $1;
				  }
				  else $$ = $3;
				}
			| exp { $$ = $1; }
			;
%%

int yyerror(char * message)
{ fprintf(listing,"Syntax error at line %d: %s\n",lineno,message);
  fprintf(listing,"Current token: ");
  printToken(yychar,tokenString);
  Error = TRUE;
  return 0;
}

/* yylex calls getToken to make Yacc/Bison output
 * compatible with ealier versions of the TINY scanner
 */
static int yylex(void)
{ return getToken(); }

TreeNode * parse(void)
{ yyparse();
  return savedTree;
}

