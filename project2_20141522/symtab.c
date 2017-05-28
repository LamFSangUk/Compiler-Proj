/****************************************************/
/* File: symtab.c                                   */
/* Symbol table implementation for the TINY compiler*/
/* (allows only one symbol table)                   */
/* Symbol table is implemented as a chained         */
/* hash table                                       */
/* Compiler Construction: Principles and Practice   */
/* Kenneth C. Louden                                */
/****************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symtab.h"
#include "globals.h"

/* the hash function */
static int hash ( char * key )
{ int temp = 0;
  int i = 0;
  while (key[i] != '\0')
  { temp = ((temp << SHIFT) + key[i]) % SIZE;
    ++i;
  }
  return temp;
}

/* Procedure st_insert inserts line numbers and
 * memory locations into the symbol table
 * loc = memory location is inserted only the
 * first time, otherwise ignored
 */
void st_insert( TreeNode * tnode, int loc ,int mode)
// mpde 0 for just current scope, use it in Dclr
// mode 1 for all scope, use it in Exp
{ int h = hash(tnode->attr.name);
	if(mode==0){
		BucketList l =  st->hashTable[h];
		while ((l != NULL) && (strcmp(tnode->attr.name,l->name) != 0))
			l = l->next;
		if (l == NULL) /* variable not yet in table of current scope */
		{ l = (BucketList) malloc(sizeof(struct BucketListRec));
			l->name = tnode->attr.name;
			l->lines = (LineList) malloc(sizeof(struct LineListRec));
			l->lines->lineno = tnode->lineno;
			if(tnode->kind.dclr==FuncK) l->vpf=Func;
			else{
				if(tnode->para) l->vpf=Para;
				else l->vpf=Var;
			}
			l->arrsize=tnode->size;
			l->type=tnode->type;
			l->memloc = loc;
			l->lines->next = NULL;
			l->next = st->hashTable[h];
			st->hashTable[h] = l; }
		else /* found in table, so just add line number */
		{ LineList t = l->lines;
			while (t->next != NULL) t = t->next;
			t->next = (LineList) malloc(sizeof(struct LineListRec));
			t->next->lineno = tnode->lineno;
			t->next->next = NULL;
			
		}
	}
	else{
		SymTabList temp=st;
		while(temp!=NULL){
			BucketList l = temp->hashTable[h];
			while((l!=NULL) && (strcmp(tnode->attr.name,l->name) !=0))
				l=l->next;
			if(l!=NULL){//found
				LineList t = l->lines;
				
				tnode->type=l->type;

				while(t->next != NULL){
					if(t->lineno == tnode->lineno) return; //eleminate the duplicated LineListRec
					 t = t->next;
				}
				if(t->lineno == tnode->lineno) return;
				t->next = (LineList) malloc(sizeof(struct LineListRec));
				t->next->lineno = tnode->lineno;
				t->next->next=NULL;
				
				return;
			}

			temp=temp->up;
		}
		//Error Undclr
	}
} /* st_insert */

/* Function st_lookup returns Bucket of symtab
 * location of a variable or NULL if not found
 */
BucketList st_lookup ( char * name, int mode)
// mpde 0 for just current scope
// mode 1 for all scope
{ int h = hash(name);
	SymTabList temp=st;
 	while(temp!=NULL){
		BucketList l =  temp->hashTable[h];
 		while ((l != NULL) && (strcmp(name,l->name) != 0))
    		l = l->next;
  		if (l == NULL) {
			if(mode==0) return NULL;//No exist in cur scope. Err
			else temp=temp->up;
		}
  		else return l;
	}
	return NULL;
}

void st_scopeup(){
	int i;
	SymTabList newst = (SymTabList)malloc(sizeof(struct SymbolTableList));

	if(st){
		newst->scope_lev = st->scope_lev+1;
		newst->up = st;
		//newst->prev = NULL;
		if(st->down) {
			SymTabList temp=st->down;
			while(temp->next) temp=temp->next;
			temp->next = newst;
			//newst->prev = st->down;
		}
		else st->down = newst;
	}
	else{
		newst->scope_lev = 0;
		newst->next =  newst->down = newst->up = NULL;
	}

	//initialize the hashtab.
	for(i=0;i<SIZE;i++) newst->hashTable[i]=NULL;

	st = newst;
}

void st_scopedown(TreeNode* t){
	if(t->nodekind==StmtK){
		if(t->kind.stmt==CompK && st){
			printSymTab(listing);
			//while(st->prev) {
			//	printf("move to sibling: %d\n",st->scope_lev);
			//	st=st->prev;
			//}
			//st->up->down=st;
			st=st->up;
		}
	}
	//else if(t==syntaxTree
}

/* Procedure printSymTab prints a formatted 
 * listing of the symbol table contents 
 * to the listing file
 */
void printSymTab(FILE * listing)
{ int i;
	if(TraceAnalyze){
		fprintf(listing,"Variable Name  Scope  Location  V/P/F  Array?  Size  Type  Line Numbers\n");
		fprintf(listing,"-------------  -----  --------  -----  ------  ----  ----  ------------\n");
		for (i=0;i<SIZE;++i)
		{ if (st->hashTable[i] != NULL)
			{ BucketList l = st->hashTable[i];
				while (l != NULL)
				{ LineList t = l->lines;
					fprintf(listing,"%-14s ",l->name);
					fprintf(listing,"%-5d  ", st->scope_lev);
					fprintf(listing,"%-8d  ",l->memloc);
					
					if(l->vpf == 2) fprintf(listing,"Func   ");
					else if(l->vpf==1) fprintf(listing,"Para   ");
					else fprintf(listing,"Var    ");
	
					if(l->arrsize!=-1) fprintf(listing,"TRUE    %-4d  ",l->arrsize);
					else fprintf(listing,"FALSE   -     ");
					
					if(l->type==Void) fprintf(listing,"void  ");
					else if(l->type==Integer)fprintf(listing,"int   ");
					else fprintf(listing,"      ");
					while (t != NULL)
					{ fprintf(listing,"%4d ",t->lineno);
						t = t->next;
					}
					fprintf(listing,"\n");
					l = l->next;
				}
			}
		}
		fprintf(listing,"\n");
	}
} /* printSymTab */
