/* The code generator implementation                */
/* for the TINY compiler                            */
/* (generates code for the TM machine)              */
/* Compiler Construction: Principles and Practice   */
/* Kenneth C. Louden                                */
/****************************************************/

#include "globals.h"
#include "symtab.h"
#include "code.h"
#include "cgen.h"


#define v0 2
#define t0 8
#define ac 9
#define t2 10
#define t3 11
#define s5 20
#define s6 21
#define sp 29
#define fp 30
#define ra 31


/* tmpOffset is the memory offset for temps
   It is decremented each time a temp is
   stored, and incremeted when loaded again
   */
static int tmpOffset = 0;

/////////////////////project4/////////////
static int how_many_locals=0;		// count how many local variables from current state
static int label_num=0;
static int assign_flag=0;			// 1 : when it is processing assign statement
static int call_flag=0;				// 1 : when it is processing call statement

/* prototype for internal recursive code generator */
static void cGen (TreeNode * tree);

static char* getRegisterName(int num)
{
	switch(num)
	{
		case 2: return "v0"; break;
		case 8: return "t0"; break;
		case 9: return "t1"; break;
		case 10: return "t2"; break;
		case 11: return "t3"; break;
		case 20: return "s5"; break;
		case 21: return "s6"; break;
		case 29: return "sp"; break;
		case 30: return "fp"; break;
		case 31: return "ra"; break;
		default: Error=1; break;
	}

}

/* Procedure genStmt generates code at a statement node */
static void genStmt( TreeNode * tree)
{ TreeNode * p1, * p2, * p3;
	int savedLoc1,savedLoc2,currentLoc;
	int loc;
	switch (tree->kind.stmt) {

		case IfelseK :
			if (TraceCode) 
				emitComment("-> if-else") ;

			p1 = tree->child[0] ;
			p2 = tree->child[1] ;
			p3 = tree->child[2] ;

			/* generate code for test expression */
			cGen(p1);

			savedLoc1 = label_num++;
			emitBranch("bne",getRegisterName(ac),"label",savedLoc1,NULL);
			cGen(p2);

			savedLoc2=label_num++;
			emitBranch("j",NULL,"label",savedLoc2,NULL);
			emitLabel(savedLoc1);
			cGen(p3);
			emitLabel(savedLoc2);

			if (TraceCode)  
				emitComment("<- if-else") ;
			break; /* if_elsek */

		case IfK:
			if (TraceCode) 
				emitComment("-> if") ;

			p1 = tree->child[0] ;
			p2 = tree->child[1] ;

			/* generate code for test expression */
			cGen(p1);

			savedLoc1 = label_num++;
			emitBranch("bne",getRegisterName(ac),"label",savedLoc1,NULL);
			cGen(p2);
			emitLabel(savedLoc1);

			if (TraceCode)  
				emitComment("<- if") ;
			break; /* if_k */

		case WhileK:
			if (TraceCode) 
				emitComment("-> while") ;
			p1 = tree->child[0] ;
			p2 = tree->child[1] ;

			savedLoc1 = label_num++;
			emitLabel(savedLoc1);
			cGen(p1);

			savedLoc2=label_num++;
			emitBranch("bnez",getRegisterName(ac),"label",savedLoc2,NULL);
			cGen(p2);
			emitBranch("j",NULL,"label",savedLoc1,NULL);
			emitLabel(savedLoc2);

			if (TraceCode)  
				emitComment("<- while") ;
			break; /* repeat */

		case ReturnK: 
			if (TraceCode) 
				emitComment("-> return") ;
			p1=tree->child[0];

			if(p1)
				cGen(p1);

			emitRRM("addi",getRegisterName(sp),getRegisterName(fp),-4,NULL);

			pop(ra);
			pop(fp);

			fprintf(code,"\tjr $ra\n");

			if (TraceCode)  
				emitComment("<- return") ;

			break;

		case CompK: 
			if (TraceCode) 
				emitComment("-> compound") ;

			p1=tree->child[0];
			p2=tree->child[1];

			if(p1)
				cGen(p1);
			if(p2)
				cGen(p2);

			if (TraceCode)  
				emitComment("<- compound") ;

			break;

		default:
			break;
	}
} /* genStmt */


/* Procedure genExp generates code at an expression node */
static void genExp( TreeNode * tree)
{	
	int loc;
	TreeNode * p1, * p2;
	BucketList l;
	switch (tree->kind.exp) {

		case ConstK :
			if (TraceCode) 
				emitComment("-> Const") ;

			emitRM("li",getRegisterName(ac),tree->attr.val,NULL);

			if (TraceCode)  emitComment("<- Const") ;
			break; /* ConstK */

		case IdK :	
			if (TraceCode) 
				emitComment("-> Id") ;

		
			/////////////////////////////////////////// not yet implemented ////////////////////////////////////////
				l = tree->bl;
			printf("Codegen %s %d\n",tree->attr.name, l->arrsize);
			if(l->arrsize !=-1)		// if id is array (pass address of array as argument, then the name of the array is recognized as IdK)
				emitRR("move",getRegisterName(ac),getRegisterName(t2),NULL);
			else
				emitRRM("addi",getRegisterName(t2),getRegisterName(fp),0,"not yet implemented");
			/////////////////////////////////////////// not yet implemented ////////////////////////////////////////



			if(!assign_flag){		//if it is not assign statement, get the value of id				
				emitRMR("lw",getRegisterName(ac),0,getRegisterName(t2),NULL);

			}
			else								// in case of assignment, move address to t1
				emitRR("move",getRegisterName(ac),getRegisterName(t2),NULL);

			if (TraceCode)  emitComment("<- Id") ;
			break; /* IdK */

		case OpK :
			if (TraceCode) 
				emitComment("-> Op \n") ;

			fprintf(code,"%d\n",tree->attr.op);
			p1 = tree->child[0];
			p2 = tree->child[1];

			if(tree->attr.op !=ASSIGN){
				cGen(p1);	// left hand side
				push(ac);
	
				cGen(p2);	// right hand side
				pop(t2);
			}

			switch (tree->attr.op) {
				case PLUS :
					emitRRR("add",getRegisterName(ac),getRegisterName(t2),getRegisterName(ac),"op +");
					break;

				case MINUS :
					emitRRR("sub",getRegisterName(ac),getRegisterName(t2),getRegisterName(ac),"op -");
					break;

				case TIMES :
					emitRRR("mul",getRegisterName(ac),getRegisterName(t2),getRegisterName(ac),"t2=t2*ac");
					break;

				case OVER :
					emitRRR("div",getRegisterName(ac),getRegisterName(t2),getRegisterName(ac),"op /");
					break;

				case LT :
					emitRRR("slt",getRegisterName(ac),getRegisterName(t2),getRegisterName(ac),"slt(<) t2, ac") ;
					break;

				case LE:
					emitRRR("sle",getRegisterName(ac),getRegisterName(t2),getRegisterName(ac),"sle(<=) t2, ac") ;
					break;

				case GT:
					emitRRR("sgt",getRegisterName(ac),getRegisterName(t2),getRegisterName(ac),"sgt(>) t2, ac") ;
					break;

				case GE:
					emitRRR("sge",getRegisterName(ac),getRegisterName(t2),getRegisterName(ac),"sge(>=) t2, ac") ;
					break;

				case SAME :
					emitRRR("seq",getRegisterName(ac),getRegisterName(t2),getRegisterName(ac),"seq(==) t2, ac") ;
					break;

				case DIFF:
					emitRRR("sne",getRegisterName(ac),getRegisterName(t2),getRegisterName(ac),"sne(!=) t2, ac") ;
					break;

				case ASSIGN:
					p1=tree->child[0];
					p2=tree->child[1];

					cGen(p2);		//right hand side
					push(ac);

					assign_flag=1;				
					cGen(p1);		// left hand side
					pop(t2);


					if(assign_flag)
						assign_flag=0;		// initiate assign_flag


					emitRMR("sw",getRegisterName(t2),0,getRegisterName(ac),NULL);	// value of ac <- t2
					emitRR("move",getRegisterName(ac),getRegisterName(t2),NULL);	
					break;

				default:
					emitComment("BUG: Unknown operator");
					break;
			} /* case op */

			if (TraceCode)  emitComment("<- Op") ;
			break; /* OpK */

		case ArrK: 
			if (TraceCode) 
				emitComment("-> Array") ;
			p1=tree->child[0];

			if(p1)	//[exp]
				cGen(p1);



			///////////////////////////////// not implemented /////////////////////////////////////////////
			l = tree->bl;

			if(l->scope_lev == 0)
				fprintf(code,"\tlda t2, name\n");
			else
			emitRRM("addi",getRegisterName(t2),getRegisterName(fp),-20,"not yet, need to implement finding right bucketList");
			///////////////////////////////// not implemented /////////////////////////////////////////////


			emitRM("li",getRegisterName(t3),4,NULL);		// get type size(int) of array to register t3
			emitRRR("mul",getRegisterName(t3),getRegisterName(ac),getRegisterName(t3),NULL);		// 4*exp
			emitRRR("add",getRegisterName(ac),getRegisterName(t2),getRegisterName(t3),NULL);	// &array + 4*exp

			if(p1 && !assign_flag)	// if it is not assign statement, get the value
			{
				//printf("---> %d\n",assign_flag);
				emitRMR("lw",getRegisterName(ac),0,getRegisterName(ac),NULL);
			}

			if (TraceCode)  
				emitComment("<- Array") ;
			break; /*ArrK */

		case CallK: 
			call_flag=1;
			p1=tree->child[0];		// parameter
			
			while(p1){
				genExp(p1);			// generate code for each parameter

				emitRRM("addi",getRegisterName(sp),getRegisterName(sp),-4,NULL);
				emitRMR("sw",getRegisterName(ac),0,getRegisterName(sp),NULL);

				p1=p1->sibling;
			}

			if(call_flag)
				call_flag=0;

			emitRRM("addi",getRegisterName(sp),getRegisterName(sp),-4,NULL);
			emitRMR("sw",getRegisterName(fp),0,getRegisterName(sp),NULL);		// store fp to stack
			emitRR("move",getRegisterName(fp),getRegisterName(sp),NULL);		// sp <- fp
			fprintf(code,"\tjal	%s\n",tree->attr.name);							// function

			int para_num=0;	// save the number of parameters
			TreeNode* temp = tree->child[0];

			while(temp){
				para_num++;
				temp=temp->sibling;
			}

			emitRRM("addi",getRegisterName(sp),getRegisterName(sp),para_num,NULL);

			break;

		default:
			break;
	}
} /* genExp */

static void genDecl( TreeNode * tree)
{ TreeNode * p1, * p2, * p3;
	int savedLoc1,savedLoc2,currentLoc;
	int loc;
	BucketList l;
	switch (tree->kind.dclr) {
		case VarK: 
			break;
		case VarArrK: 
			break;
		case FuncK: 
			if(!strcmp(tree->attr.name,"main")){
				fprintf(code,".global main\n");	
				fprintf(code,"%s:\n",tree->attr.name);

				emitRM("li",getRegisterName(ac),0,"load const");
				push(fp);
				emitRR("move",getRegisterName(fp),getRegisterName(sp),"fp=sp");
				push(ra);
			}
			else{
				fprintf(code,"%s:\n",tree->attr.name);
				push(ra);
			}

			//////////////////////////////////////////////////////////not implemented ///////////////////////////////////////

			//=st_lookup(tree->attr.name);
			how_many_locals=0;
			find(tree->child[1]);
			emitRRM("addi",getRegisterName(sp),getRegisterName(sp),how_many_locals*(-1),"how_many");
			//////////////////////////////////////////////////////////not implemented ///////////////////////////////////////

			p2=tree->child[1];
			cGen(p2);

			emitRRM("addi",getRegisterName(sp),getRegisterName(fp),-4,"sp=fp-4");

			pop(ra);
			pop(fp);
			
			fprintf(code,"\tjr $ra\n");
			break;

		default: 
			emitComment("BUG: Unknown operator");
	}
} /* genDecl */


/* Procedure cGen recursively generates code by
 * tree traversal
 */
static void cGen( TreeNode * tree)
{ if (tree != NULL)
	{ 
		//		if(tree->attr.name)
		fprintf(code,"--%d\n",tree->lineno);

		switch (tree->nodekind) 
		{
			case StmtK:
				genStmt(tree);
				break;
			case ExpK:
				genExp(tree);
				break;
			case DclrK:
				genDecl(tree);
			default:
				break;
		}

		cGen(tree->sibling);
	}
}

/**********************************************/
/* the primary function of the code generator */
/**********************************************/
/* Procedure codeGen generates code to a code
 * file by traversal of the syntax tree. The
 * second parameter (codefile) is the file name
 * of the code file, and is used to print the
 * file name as a comment in the code file
 */
void codeGen(TreeNode * syntaxTree, char * codefile)
{   char * s = malloc(strlen(codefile)+7);
	BucketList l;
	int i=0;

	strcpy(s,"File: ");
	strcat(s,codefile);
	emitComment("C- Compilation to SPIM Code");
	emitComment(s);


	fprintf(code,".data\n");

	for (i = 0; i <SIZE; i++)				// add global variables to .data area
	{
		l = st->hashTable[i];
		while (l)
		{
			if (l->vpf == Var)
			{
				if (l->arrsize != -1)
					fprintf(code, "%s: .word 0:%d\n", l->name,l->arrsize);
				else 
					fprintf(code,"%s: .word 0\n",l->name);
			}
			l = l->next;
		}
	}


	fprintf(code," inin: .asciiz \"input: \"\n");
	fprintf(code," outout: .asciiz \"output: \"\n");
	fprintf(code,"newline: .asciiz \"\\n\"\n");
	fprintf(code,".text\n");


	//input----------------------------------------------------------------
	fprintf(code,"input:\n");


	push(ra);		// push return address 
	fprintf(code,"li $v0, 4\n");
	fprintf(code,"la $a0, inin\n");
	fprintf(code,"syscall\n");
	fprintf(code,"li $v0, 5\n");
	fprintf(code,"syscall\n");
	emitRR("move",getRegisterName(ac),getRegisterName(v0),"move ac to v0");

	// initiate fp, ra
	emitRRM("addi", getRegisterName(sp),getRegisterName(fp),-4, "sp = fp - 4");
	pop(ra);
	pop(fp);
	fprintf(code,"jr $ra\n");


	////output---------------------------------------------------------
	fprintf(code,"output:\n");

	push(ra);

	fprintf(code,"li $v0, 4\n");
	fprintf(code,"la $a0, outout\n");
	fprintf(code,"syscall\n");

	fprintf(code,"li $v0, 1\n");
	fprintf(code,"lw $a0, 4($fp)\n");
	fprintf(code,"syscall\n");

	fprintf(code,"li $v0, 4\n");
	fprintf(code,"la $a0, newline\n");
	fprintf(code,"syscall\n");


	// initiate fp and ra
	emitRRM("addi", getRegisterName(sp),getRegisterName(fp),-4, "sp = fp - 4");
	pop(ra);
	pop(fp);


	fprintf(code,"jr $ra\n");	

	cGen(syntaxTree);

	emitComment("End of execution.");
}

void find(TreeNode* cur)		// find how many local variables within the scope
{
	int i;

	if(cur)						// AST 현재 노드부터 시작해서 아래로 내려가면서 decl이 몇개 있는지 카운트
	{
		if(cur->nodekind==DclrK)
		{
			fprintf(code,"------------%s\n",cur->attr.name);
			if(cur->size!=-1)			// if it is Array
			{
				fprintf(code,"size: %d\n",cur->size);
				how_many_locals += cur->size;	
			}
			else						// if it is not an array
				how_many_locals++;
		}
		
		for(i=0;i<MAXCHILDREN;i++)
			find(cur->child[i]);
		
		find(cur->sibling);
	}
}


void push(int reg)
{
	emitRRM("addi", getRegisterName(sp),getRegisterName(sp),-4,"sp -= 4");
	emitRMR("sw", getRegisterName(reg),0,getRegisterName(sp),"push temp(save_reg_num) to sp");
}
void pop(int reg)
{
	emitRMR("lw",getRegisterName(reg),0,getRegisterName(sp), "pop temp(save_reg_num) to sp");
	emitRRM("addi", getRegisterName(sp),getRegisterName(sp),4, "sp += 4");
}
