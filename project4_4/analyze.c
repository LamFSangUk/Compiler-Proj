/****************************************************/
/* File: analyze.c                                  */
/* Semantic analyzer implementation                 */
/* for the TINY compiler                            */
/* Compiler Construction: Principles and Practice   */
/* Kenneth C. Louden                                */
/****************************************************/

#include "symtab.h"
#include "analyze.h"

#define ARGS -10

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
	fprintf(listing,"Symbol error\tat line %-4d: %s %s\n",t->lineno, msg,t->attr.name);
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
			if(!funcscope){
				st_scopeup();
				location[st->scope_lev]=0;
			}
			else {
				funcscope=FALSE;
			}
			break;
        default:
          break;
      }
      break;
    case ExpK:
      switch (t->kind.exp)
      { TreeNode * temp;
		case CallK:
			temp=t->child[0];
			while(temp){
				temp->para=ARGS;
				temp=temp->sibling;
			}
		case IdK:
		case ArrK:

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
			BucketList l;
			case VarArrK:
				//if(!funcscope) location[func_count]-=4*t->size;
			case VarK:
				

				if(l=st_lookup(t->attr.name,0)){
				/* already in table, so it is an error. */
					symtabError(t,"Already Declared Symbol");
					fprintf(listing,"\t\t\t\tfirst declared at line %d\n",l->lines->lineno);
				}
				else{
					st_insert(t,location[st->scope_lev]++,0);
				}
				
				break;
			case FuncK:	
				
				if(l=st_lookup(t->attr.name,0)){
					/* already in table, so it is an error. */
					symtabError(t,"Already Declared Symbol");
					fprintf(listing,"\t\t\t\tfirst declared at line %d\n",l->lines->lineno);
				}
				else{
					st_insert(t,location[st->scope_lev]++,0);
				}
				funcscope=TRUE;
				st_scopeup();
				location[st->scope_lev]=0;
				
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

static int return_flag=0;
static int final_flag=0;
static TreeNode * returnNode[256];
static TreeNode * paralist=NULL;
static TreeNode * arglist=NULL;
/* Procedure checkNode performs
 * type checking at a single tree node
 */
static void checkNode(TreeNode * t)
{ switch (t->nodekind)
  { BucketList l;
	case ExpK:
      switch (t->kind.exp)
      { case OpK:

			//Check For Left Child and Right Child
			if(t->child[0]->type == Void || t->child[1]->type==Void){
				fprintf(listing,"Type error\tat line %-4d: Invalid type in ",t->lineno);
				if(t->attr.op==PLUS || t->attr.op==MINUS){
					fprintf(listing,"addexp ");
				}
				else if(t->attr.op==TIMES || t->attr.op==OVER){
					fprintf(listing,"term ");
				}
				fprintf(listing,"expression\n");
				fprintf(listing,"\t\t\t\toperand1 has type ");
				if(t->child[0]->type==Integer) fprintf(listing,"Integer ");
				else fprintf(listing,"Void ");
				fprintf(listing,", operand2 has type ");
				if(t->child[1]->type==Integer) fprintf(listing,"Integer ");
				else fprintf(listing,"Void ");
				fprintf(listing,"\n");
				Error=TRUE;
				break;
			}
			//Assigh check for same type
			if(t->child[0]->type != t->child[1]->type){
				//Actually No need in Cminus, cause all type of var to operate is integer
				fprintf(listing,"Type error\tat line %-4d: Different Type between operands\n",t->lineno);
				break;
			}
			t->type=t->child[0]->type;
			break;
		case IdK:
			l=st_lookup(t->attr.name,1);
			
			//Check it exists.
			if(l==NULL){
				//Already Checked in Symtable Error.
				break;
			}
			if(l->arrsize>-1 && t->para!=ARGS){
				fprintf(listing,"Type error\tat line %-4d: Symbol %s is an Array\n",t->lineno,t->attr.name);
				Error=TRUE;
				break;
			}
			if(l->vpf==Func){
				fprintf(listing,"Type error\tat line %-4d: Symbol %s is a Function\n",t->lineno,t->attr.name);
				Error=TRUE;
				break;
			}

			break;
		case ArrK:
			//Check for Array or Var
			l=st_lookup(t->attr.name,1);
			//check it exists
			if(l==NULL){
				//Already Checked in Symtable Error.
				break;
			}			

			if(l->arrsize==-1){
				fprintf(listing,"Type error\tat line %-4d: Symbol %s is NOT an Array\n",t->lineno,t->attr.name);
				Error=TRUE;
				break;
			}

			//Check For Array Idx
			if(!t->child[0] || t->child[0]->type!=Integer){
				fprintf(listing,"Type error\tat line %-4d: Invalid subscript of array\n\t\t\t\texpected INT but actually was VOID\n",t->lineno);
				Error=TRUE;
			}
			break;
		case CallK:
			//Is it function?
			l=st_lookup(t->attr.name,1);
			
			//Check it exists.
			if(l==NULL){
				//Already Checked in Symtable Error.
				break;
			}

			if(l->vpf!=Func){
				fprintf(listing,"Type error\tat line %-4d: Symbol %s is NOT a Function\n",t->lineno,t->attr.name);
				Error=TRUE;
				break;
			}
			paralist=l->paranode;
			arglist=t->child[0];
			while(paralist){
				if(!arglist){
					fprintf(listing,"Type error\tat line %-4d: Call Function(%s) has LESS arguments\n",t->lineno,t->attr.name);
					Error=TRUE;
					break;
				}

				if(paralist->type != arglist->type){
					fprintf(listing,"Type error\tat line %-4d: Parameter %s has DIFF type with Argument %s\n",t->lineno,paralist->attr.name,arglist->attr.name);
				}
				arglist=arglist->sibling;
				paralist=paralist->sibling;
			}
			if(arglist){
				fprintf(listing,"Type error\tat line %-4d: Call Function(%s) has MORE arguments\n",t->lineno,t->attr.name);
				Error=TRUE;				
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
			returnNode[return_flag++]=t;
			if(t->child[0]) t->type=t->child[0]->type;
			else t->type=Void;
			break;
		default:
			break;
      }
      break;
	case DclrK:
		if(final_flag && st->scope_lev==0){
			fprintf(listing,"Type error\tat line %-4d: The main function must be the last declaration\n",t->lineno);
			Error=TRUE;
			break;
		}
		switch (t->kind.dclr)
		{
			case VarK:
			case VarArrK:
				if(t->type==Void){//Cannot declare VOID type var
					fprintf(listing,"Type error\tat line %-4d: CANNOT declare VOID type variable\n",t->lineno);
					Error=TRUE;
				}		
				break;
			case FuncK:

				if(strcmp(t->attr.name,"main")==0){
					//Error for main
					
					final_flag=1;//Main function is the last dclr.

					//Main_function is Void type
					if(t->type!=Void){
						fprintf(listing,"Type error\tat line %-4d: The main function must be of type VOID\n",t->lineno);
						Error=TRUE;
					}
					//Main function cannot have the parameters
					if(t->child[0]!=NULL){
						fprintf(listing,"Type error\tat line %-4d: The main function CANNOT have parameters\n",t->lineno);
						Error=TRUE;
					}
				}
				
				//Return Stmt exists.
				if(return_flag){
					while(return_flag){
						if(t->type!=returnNode[--return_flag]->type){
							fprintf(listing,"Type error\tat line %-4d: Different type between FUNC(%s) and RETURN\n",t->lineno,t->attr.name);
							Error=TRUE;
						}
						returnNode[return_flag]=NULL;
					}
				}
				else{
					if(t->type!=Void){
						fprintf(listing,"Type error\tat line %-4d: Integer function(%s) expected RETURN, but actually has NO RETURN\n",t->lineno,t->attr.name);
						Error=TRUE;	
					}
				}
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
	if(t->nodekind==DclrK && t->kind.dclr==FuncK){
		funcscope=TRUE;
		if(st->down) st=st->down;
	}
	if(t->nodekind==StmtK && t->kind.stmt==CompK){
		if(funcscope) funcscope=FALSE;
		else if(st->down) st=st->down;
	}
}

void typeCheck(TreeNode * syntaxTree)
{ traverse(syntaxTree,FindScope,checkNode);
}
