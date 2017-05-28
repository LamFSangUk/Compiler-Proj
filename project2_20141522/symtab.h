/****************************************************/
/* File: symtab.h                                   */
/* Symbol table interface for the TINY compiler     */
/* (allows only one symbol table)                   */
/* Compiler Construction: Principles and Practice   */
/* Kenneth C. Louden                                */
/****************************************************/

#ifndef _SYMTAB_H_
#define _SYMTAB_H_

#include"globals.h"

/* SIZE is the size of the hash table */
#define SIZE 211

/* SHIFT is the power of two used as multiplier
   in hash function  */
#define SHIFT 4

/* the list of line numbers of the source
 * code in which a variable is referenced
 */
typedef struct LineListRec
   { int lineno;
     struct LineListRec * next;
   } * LineList;

/* The record in the bucket lists for
 * each variable, including name,
 * assigned memory location, and
 * the list of line numbers in which
 * it appears in the source code
 */
typedef struct BucketListRec
   { char * name;
     LineList lines;
         DclrExpType type;
         int vpf;
         int arrsize;
     int memloc ; /* memory location for variable */
     struct BucketListRec * next;
   } * BucketList;

typedef struct SymbolTableList{
        BucketList hashTable[SIZE];
        int scope_lev;
		//Point to Parent or Child
		struct SymbolTableList * up;
		struct SymbolTableList * down;
		//Point to Siblings
        struct SymbolTableList * next;
		struct SymbolTableList * prev;
}*SymTabList;

SymTabList st;

/* Procedure st_insert inserts line numbers and
 * memory locations into the symbol table
 * loc = memory location is inserted only the
 * first time, otherwise ignored
 */
void st_insert( TreeNode * t, int loc , int mode);

/* Function st_lookup returns Buctket of symtab
 * location of a variable or NULL if not found
 */
BucketList st_lookup ( char * name, int mode);

/* Procedure printSymTab prints a formatted 
 * listing of the symbol table contents 
 * to the listing file
 */

void st_scopeup();
void st_scopedown();
void printSymTab(FILE * listing);

#endif
