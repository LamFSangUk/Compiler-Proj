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

          if (st_lookup(t->attr.name,1) == -1)
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

				if(st_lookup(t->attr.name,0)>-1)
				/* already in table, so it is an error. */
					symtabError(t,"Already Declared Symbol ");
				else
					st_insert(t,loc,0);
				
				break;
			case FuncK:	
				
				if(st_lookup(t->attr.name,0)>-1)
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
 	if (TraceAnalyze) printSymTab(listing);
	//st_scopedown();
	//printSymTab(listing);
}

static void typeError(TreeNode * t, char * message)
{ fprintf(listing,"Type error at line %d: %s\n",t->lineno,message);
  Error = TRUE;
}

/* Procedure checkNode performs
 * type checking at a single tree node
 */
static void checkNode(TreeNode * t)
{ switch (t->nodekind)
  { case ExpK:
      switch (t->kind.exp)
      { /*case OpK:
          if ((t->child[0]->type != Integer) ||
              (t->child[1]->type != Integer))
            typeError(t,"Op applied to non-integer");
          if ((t->attr.op == EQ) || (t->attr.op == LT))
            t->type = Boolean;
          else
            t->type = Integer;
          break;
        case ConstK:
        case IdK:
          t->type = Integer;
          break;
        default:
          break;
		*/
      }
      break;
    case StmtK:
      switch (t->kind.stmt)
      { /*case IfK:
          if (t->child[0]->type == Integer)
            typeError(t->child[0],"if test is not Boolean");
          break;
        case AssignK:
          if (t->child[0]->type != Integer)
            typeError(t->child[0],"assignment of non-integer value");
          break;
        case WriteK:
          if (t->child[0]->type != Integer)
            typeError(t->child[0],"write of non-integer value");
          break;
        case RepeatK:
          if (t->child[1]->type == Integer)
            typeError(t->child[1],"repeat test is not Boolean");
          break;
        default:
          break;*/
      }
      break;
	case DclrK:
		switch (t->kind.dclr)
		{
			case VarK:
			case VarArrK:
				if(t->type==Void){//Cannot declare VOID type var
					typeError(t,"Cannot Declare VOID Type Variable");
				}
				break;
			case FuncK:	
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
void typeCheck(TreeNode * syntaxTree)
{ traverse(syntaxTree,nullProc,checkNode);
}
