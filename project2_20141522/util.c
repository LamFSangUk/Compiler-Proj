/****************************************************/
/* File: util.c										*/
/* Utility functions implementation					*/
/* for the TINY compiler							*/
/* Compiler Construction: Principles and Practices	*/
/* Kenneth C. Louden								*/
/* Modified by Sang Uk								*/
/****************************************************/

#include "globals.h"
#include "util.h"

/* Procedure printToken prints a token
 * and its lexeme to the listing file
 */
void printToken(TokenType token, const char* tokenString)
{
	switch(token)
	{
	case IF: 		fprintf(listing,"IF\n"); break;
	case ELSE: 		fprintf(listing,"ELSE\n"); break;
	case INT: 		fprintf(listing,"INT\n"); break;
	case WHILE: 	fprintf(listing,"WHILE\n"); break;
	case RETURN: 	fprintf(listing,"RETURNs\n"); break;
	case VOID: 		fprintf(listing,"VOID\n"); break;
	case ASSIGN: 	fprintf(listing,"=\n"); break;	
	case SAME: 		fprintf(listing,"==\n"); break;
	case DIFF: 		fprintf(listing,"!=\n"); break;
	case LT: 		fprintf(listing,"<\n"); break;
	case LE: 		fprintf(listing,"<=\n"); break;
	case GT: 		fprintf(listing,">\n"); break;
	case GE: 		fprintf(listing,">=\n"); break;
	case LQBRACE: 	fprintf(listing,"{\n"); break;
	case RQBRACE: 	fprintf(listing,"}\n"); break;
	case LSBRACE: 	fprintf(listing,"[\n"); break;
	case RSBRACE: 	fprintf(listing,"]\n"); break;
	case LPAREN: 	fprintf(listing,"(\n"); break;
	case RPAREN: 	fprintf(listing,")\n"); break;
	case COMMA: 	fprintf(listing,",\n"); break;
	case SEMI: 		fprintf(listing,";\n"); break;
	case PLUS: 		fprintf(listing,"+\n"); break;
	case MINUS: 	fprintf(listing,"-\n"); break;
	case TIMES: 	fprintf(listing,"*\n"); break;
	case OVER: 		fprintf(listing,"/\n"); break;
	case ENDFILE: 	fprintf(listing,"EOF\n"); break;
	case NUM:
		fprintf(listing,
			"NUM\t%s\n",tokenString);
		break;
	case ID:
		fprintf(listing,
			"ID\t%s\n",tokenString);
		break;
	case ERROR:
		fprintf(listing,
			"ERROR\t%s\n",tokenString);
		break;
	case COMMENTERR: fprintf(listing,"ERROR\tCOMMENT ERROR\n"); break;
	default:/*shoud never happen*/
		fprintf(listing,"Unknown token: %d\n",token);
	}
}

/* Function newStmtNode creates a new statement
 * node for syntax tree construction
 */
TreeNode * newStmtNode(StmtKind kind)
{
	TreeNode * t = (TreeNode *) malloc(sizeof(TreeNode));
	int i;
	if(t==NULL)
		fprintf(listing,"Out of memory error at line %d\n",lineno);
	else{
		for(i=0;i<MAXCHILDREN;i++) t->child[i] = NULL;
		t->sibling = NULL;
		t->nodekind = StmtK;
		t->kind.stmt = kind;
		t->lineno = lineno;
		t->size = 0;
	}
	return t;
}

/* Function newExpNode creates a new expression
 * node for syntax tree construction
 */
TreeNode * newExpNode(ExpKind kind)
{
	TreeNode * t = (TreeNode *) malloc(sizeof(TreeNode));
	int i;
	if(t==NULL)
		fprintf(listing,"Out of memory error at line %d\n",lineno);
	else{
		for(i=0;i<MAXCHILDREN;i++) t->child[i] = NULL;
		t->sibling = NULL;
		t->nodekind = ExpK;
		t->kind.exp = kind;
		t->lineno = lineno;
		t->type = Void;
		t->size = 0;
	}
	return t;
}

/* Function newDclrNode creates a new declaration
 * node for syntax tree construction
*/ 
TreeNode * newDclrNode(DclrKind kind)
{
	TreeNode * t = (TreeNode *) malloc(sizeof(TreeNode));
	int i;
	if(t==NULL)
		fprintf(listing,"Out of memory error at line %d\n",lineno);
	else{
		for(i=0;i<MAXCHILDREN;i++) t->child[i] = NULL;
		t->sibling = NULL;
		t->nodekind = DclrK;
		t->kind.dclr = kind;
		t->lineno = lineno;
		t->type = Void;
		t->size = 0;
		t->para = FALSE;
	}
	return t;
}


/* Function copyString allocates and makes a new
 * copy of an existing string
 */
char * copyString(char * s)
{
	int n;
	char * t;
	if(s==NULL) return NULL;
	n=strlen(s)+1;
	t=malloc(n);
	if(t==NULL)
		fprintf(listing,"Out of memory error at line %d\n",lineno);
	else strcpy(t,s);
	return t;
}

/* Variable indentno is used by printTree to
 * store current number of spaces to indent
 */
static indentno = 0;
int assignflag = 0;

/* macros to increase/decrease indentation */
#define INDENT indentno+=2
#define UNINDENT indentno-=2

/* printSpaces indests by printing spaces */
static void printSpaces(void)
{
	int i;
	for(i=0;i<indentno;i++)
		fprintf(listing," ");
}

/* procedure printTree prints a syntax tree to the
 * listing file using indentation to indicate subtrees
 */
void printTree(TreeNode * tree)
{
	int i;
	INDENT;
	while(tree!=NULL){
		if(assignflag==0) printSpaces();
		
		if(tree->nodekind==StmtK)
		{
			switch(tree->kind.stmt){
			case IfK:
				fprintf(listing,"If\n");
				printSpaces();
				fprintf(listing,"Condition:\n");
				break;
			case IfelseK:
				fprintf(listing,"If Else\n");
				printSpaces();
				fprintf(listing,"Condition:\n");
				break;
			case WhileK:
				fprintf(listing,"While\n");
				printSpaces();
				fprintf(listing,"Condition:\n");
				break;
			case ReturnK:
				fprintf(listing,"Return\n");
				break;
			case CompK:
				fprintf(listing,"Compound Statement\n");
				break;
			default:
				fprintf(listing,"Unknown StmtNode kind\n");
				break;
			}
		}
		else if(tree->nodekind==ExpK)
		{
			switch(tree->kind.exp){
			case OpK:
				if(tree->attr.op==ASSIGN){
					fprintf(listing,"ASSIGN to: ");
					assignflag++;
				}
				else{
					fprintf(listing,"Op: ");
					printToken(tree->attr.op,"\0");
				}
				break;
			case ConstK:
				fprintf(listing,"Const: %d\n",tree->attr.val);
				break;
			case IdK:
				if(assignflag>0) {
					fprintf(listing, "%s\n",tree->attr.name);
					assignflag--;
				}
				else fprintf(listing,"Var Id: %s\n",tree->attr.name);
				break;
			case ArrK:
				if(assignflag>0){
					fprintf(listing, "%s[]\n",tree->attr.name);
					assignflag--;
				}
				else fprintf(listing,"Arr Id: %s[]\n",tree->attr.name);
				break;
			case CallK:
				fprintf(listing,"Function Call: %s\n",tree->attr.name);
				break;
			default:
				fprintf(listing,"Unknown ExpNode kind\n");
				break;
			}
		}
		else if(tree->nodekind==DclrK)
		{
			switch(tree->kind.dclr){
			case VarK:
				if(tree->para == TRUE)
					fprintf(listing,"NonArray Varaible Parameter\n");
				else
					fprintf(listing,"NonArray Variable Declaration\n");
				INDENT;
				printSpaces();
				if(tree->type==Integer){
					fprintf(listing,"Type: int\n");
					printSpaces();
					fprintf(listing,"Id: %s\n",tree->attr.name);
				}
				else if(tree->type==Void){
					fprintf(listing,"Type: void\n");
					printSpaces();
					fprintf(listing,"Id: %s\n",tree->attr.name);
				}
				else
					fprintf(listing,"Unknown Varaible Type\n");
				UNINDENT;
				break;
			case VarArrK:
				if(tree->para == TRUE)
					fprintf(listing,"Array Variable Parameter\n");
				else
					fprintf(listing,"Array Variable Declaration\n");
				INDENT;
				printSpaces();
				if(tree->type==Integer){
					fprintf(listing,"Type: int\n");
					printSpaces();
					fprintf(listing,"Id: %s[]\n",tree->attr.name);
					if(tree->para == FALSE){
						printSpaces();
						fprintf(listing,"Size: %d\n",tree->size);
					}
				}
				else if(tree->type==Void){
					fprintf(listing,"Type: void\n");
					printSpaces();
					fprintf(listing,"Id: %s\n",tree->attr.name);
					if(tree->para == FALSE){
						printSpaces();
						fprintf(listing,"Size: %d\n",tree->size);
					}

				}
				else
					fprintf(listing,"Unknown Varaible Type\n");
				UNINDENT;
				break;
			case FuncK:
				fprintf(listing,"Function Declaration\n");
				INDENT;
				printSpaces();
				if(tree->type==Integer){
					fprintf(listing,"Type: int\n");
					printSpaces();
					fprintf(listing,"Id: %s\n",tree->attr.name);
				}
				else if(tree->type==Void){
					fprintf(listing,"Type: void\n");
					printSpaces();
					fprintf(listing,"Id: %s\n",tree->attr.name);
				}
				else
					fprintf(listing,"Unknown Varaible Type\n");

				UNINDENT;
				break;
			default:
				fprintf(listing,"Unknown DclrNode kind\n");
				break;
			}
		}
		else fprintf(listing,"Unknown node kind\n");
		for(i=0;i<MAXCHILDREN;i++)
			printTree(tree->child[i]);
		tree=tree->sibling;
	}
	UNINDENT;
}
