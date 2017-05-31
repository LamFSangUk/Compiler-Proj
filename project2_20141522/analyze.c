/****************************************************/
/* File: analyze.c                                  */
/* Semantic analyzer implementation                 */
/* for the TINY compiler                            */
/* Compiler Construction: Principles and Practice   */
/* Kenneth C. Louden                                */
/****************************************************/

#include "symtab.h"
#include "analyze.h"

/* counter for variable memory locations */
static int location[256] = {0};
static int func_count=0;
static int paraloc=0;

/* Procedure traverse is a generic recursive 
 * syntax tree traversal routine:
 * it applies preProc in preorder and postProc 
 * in postorder to tree pointed to by t
 */
static void traverse( TreeNode * t,
               void (* preProc) (TreeNode *),
               void (* postProc) (TreeNode *) )
{ if (t != NULL)
  { preProc(t);
    { int i;
      for (i=0; i < MAXCHILDREN; i++)
        traverse(t->child[i],preProc,postProc);
    }
    postProc(t);
    traverse(t->sibling,preProc,postProc);
  }
}

static void symtabError(TreeNode * t, char * msg)
{
	fprintf(listing,"Symbol error at line %d: %s %s\n",t->lineno, msg,t->attr.name);
	Error = TRUE;
}

/* nullProc is a do-nothing procedure to 
 * generate preorder-only or postorder-only
 * traversals from traverse
 */
static void nullProc(TreeNode * t)
{ if (t==NULL) return;
  else return;
}

/* Procedure insertNode inserts 
 * identifiers stored in t into 
 * the symbol table 
 */
static int funcscope=FALSE;
static void insertNode( TreeNode * t)
{ switch (t->nodekind)
  { case StmtK:
      switch (t->kind.stmt)
      { case CompK:
			if(!funcscope)
				st_scopeup();
			else {
				funcscope=FALSE;
				paraloc=0;
			}
			break;
        default:
          break;
      }
      break;
    case ExpK:
      switch (t->kind.exp)
      { case IdK:
		case ArrK:
		case CallK:

          if (!st_lookup(t->attr.name,1))
          /* not yet in table, so treat as new definition */
            symtabError(t,"Undeclared Symbol");
          else
          /* already in table, so ignore location, 
             add line number of use only */ 
            st_insert(t,0,1);
          break;
        default:
          break;
      }
      break;
	case DclrK:
		switch(t->kind.dclr){
			int loc;
			case VarArrK:
				if(!funcscope) location[func_count]-=4*t->size;
			case VarK:
				if(!funcscope) { loc=location[func_count]; location[func_count]-=4; }
				else { loc=paraloc; paraloc+=4; }

				if(st_lookup(t->attr.name,0))
				/* already in table, so it is an error. */
					symtabError(t,"Already Declared Symbol ");
				else{
					st_insert(t,loc,0);
					printf("lev:%s %d\n",t->attr.name,st->scope_lev);
				}
				
				break;
			case FuncK:	
				
				if(st_lookup(t->attr.name,0))
					/* already in table, so it is an error. */
					symtabError(t,"Already Declared Function ");
				else{
					st_insert(t,func_count++,0);
					location[func_count]=-4*(func_count-1);
					funcscope=TRUE;
					st_scopeup();
				}
				break;
		}
		break;
    default:
      break;
  }
}

/* Function buildSymtab constructs the symbol 
 * table by preorder traversal of the syntax tree
 */
void buildSymtab(TreeNode * syntaxTree)
{ 
	st_scopeup();	
	if(TraceAnalyze) fprintf(listing,"\nSymbol table:\n\n");
	traverse(syntaxTree,insertNode,st_scopedown);
 	printSymTab(listing);
}

static void typeError(TreeNode * t, char * message)
{ fprintf(listing,"Type error\tat line %d: %s\n",t->lineno,message);
  Error = TRUE;
}

static char getOperator(int token){
	char c;
	switch(token){
		case PLUS:	c='+';break;
		case MINUS: c='-';break;
		case TIMES: c='*';break;
		case OVER:	c='/';break;
		default:
			break;
	}
	return c;
}

static int return_flag=0;
static int final_flag=0;
static TreeNode * returnNode=NULL;
static TreeNode * paralist=NULL;
static TreeNode * arglist=NULL;
/* Procedure checkNode performs
 * type checking at a single tree node
 */
static void checkNode(TreeNode * t)
{ switch (t->nodekind)
  { case ExpK:
      switch (t->kind.exp)
      { char op;
		BucketList l;
		case OpK:
			op=getOperator(t->attr.op);	

			//Check For Left Child
			if(t->child[0]->type == Void){
				typeError(t,"Operand1 expected Integer, but actual was Void");
				//fprintf(listing,"\t\t\tExp: %s %c %s\n",t->child[0]->attr.name,op,t->child[1]->attr.name);
				break;
			}
			//Check for Right Child
			if(t->child[1]->type == Void){
				typeError(t,"Operand2 expected Integer, but actual was Void");				
				//fprintf(listing,"\t\t\tExp: %s %c %s\n",t->child[0]->attr.name,op,t->child[1]->attr.name);
				break;
			}
			//Assigh check for same type
			if(t->child[0]->type != t->child[1]->type){
				//Actually No need in Cminus, cause all type of var to operate is integer
				typeError(t,"Operator ERROR: different type");
				break;
			}
			t->type=t->child[0]->type;
			break;
		case IdK:
			l=st_lookup(t->attr.name,1);
			
			//Check it exists.
			if(l==NULL){
				fprintf(listing,"Symbol error\tat line %d: %s %s\n",t->lineno,"Undeclared Variable",t->attr.name);
				Error=TRUE;
				break;
			}
			if(l->arrsize>-1){
				fprintf(listing,"Type error\tat line %d: Symbol %s is Array\n",t->lineno,t->attr.name);
				Error=TRUE;
			}

			break;
		case ArrK:
			//Check for Array or Var
			l=st_lookup(t->attr.name,1);
			//check it exists
			if(l==NULL){
				fprintf(listing,"Symbol error\tat line %d: %s %s\n",t->lineno,"Undeclared Array",t->attr.name);
				Error=TRUE;
				break;
			}			

			if(l->arrsize==-1){
				typeError(t,"Symbol is not Array");
				break;
			}

			//Check For Array Idx
			if(!t->child[0] || t->child[0]->type!=Integer){
				typeError(t,"invalid subscript of array\n\t\t\texpected int but actual was void");
				break;
			}
			break;
		case CallK:
			//Is it function?
			l=st_lookup(t->attr.name,1);
			
			//Check it exists.
			if(l==NULL){
				fprintf(listing,"Symbol error\tat line %d: %s %s\n",t->lineno,"Undeclared Function",t->attr.name);
				Error=TRUE;
				break;
			}

			if(l->vpf!=Func){
				typeError(t,"Symbol is not Function");
				break;
			}
			paralist=l->paranode;
			arglist=t->child[0];
			while(paralist){
				if(!arglist){
					typeError(t,"The num of parameter is different");
					break;
				}

				if(paralist->type != arglist->type){
					typeError(t,"parameter doesn't match type");
					break;
				}
				arglist=arglist->sibling;
				paralist=paralist->sibling;
			}
			if(arglist){
				typeError(t,"The num of parameter is different");
				break;
			}
			break;
        default:
          break;
		
      }
      break;
    case StmtK:
      switch (t->kind.stmt)
      { 
		case CompK:
			if(st->next) st->up->down=st->next;
			st=st->up;
			break;
		case ReturnK:
			return_flag=1;
			returnNode=t;
			if(t->child[0]) t->type=t->child[0]->type;
			else t->type=Void;
			break;
		default:
			break;
      }
      break;
	case DclrK:
		if(final_flag){
			typeError(t,"main function should be the last declaration");
			break;
		}
		switch (t->kind.dclr)
		{
			case VarK:
			case VarArrK:
					if(t->type==Void){//Cannot declare VOID type var
					typeError(t,"Cannot Declare VOID Type Variable");
					break;
				}
				/*if(t->para!=0 && strcmp(t->attr.name,"main")==0){
					typeError(t,"main function cannot have parameters");
				}*/
				break;
			case FuncK:
				if(strcmp(t->attr.name,"main")==0){
					final_flag=1;
					//Error for main
					if(t->type!=Void){
						typeError(t,"main function should have void type");
						break;
					}
				}

				if(return_flag==1){
					if(t->type!=returnNode->type){
						typeError(t,"Expected Same Type betwwen Func and Return, but actual was different");
						break;
					}
				}
				else{
					if(t->type!=Void){
						typeError(t,"Expected Return, but actual didn't exist");
						break;
					}
				}
				returnNode=NULL;
				return_flag=0;	
				break;
			default:
				break;
		}
		break;
    default:
      break;

  }
}

/* Procedure typeCheck performs type checking 
 * by a postorder syntax tree traversal
 */
static void FindScope(TreeNode *t){
	if(t->nodekind==StmtK && t->kind.stmt==CompK) 
		if(st->down) st=st->down;
}

void typeCheck(TreeNode * syntaxTree)
{ traverse(syntaxTree,FindScope,checkNode);
}
