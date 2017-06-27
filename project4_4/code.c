/****************************************************/
/* File: code.c                                     */
/* TM Code emitting utilities                       */
/* implementation for the TINY compiler             */
/* Compiler Construction: Principles and Practice   */
/* Kenneth C. Louden                                */
/****************************************************/

#include "globals.h"
#include "code.h"

/* TM location number for current instruction emission */
static int emitLoc = 0 ;

/* Highest TM location emitted so far
   For use in conjunction with emitSkip,
   emitBackup, and emitRestore */
static int highEmitLoc = 0;

void emitLabel(int label_num)
{
	fprintf(code,"label%d:\n",label_num);
}

/* Procedure emitComment prints a comment line 
 * with comment c in the code file
 */
void emitComment( char * c )
{ if (TraceCode) fprintf(code,"# %s\n",c);}

void emitRR( char *op, char* r, char* s, char *c)	// register, register
{ fprintf(code,"\t%5s  $%s,$%s ",op,r,s);
  if (TraceCode && c) fprintf(code,"#\t%s",c) ;
  fprintf(code,"\n") ;
  if (highEmitLoc < emitLoc) highEmitLoc = emitLoc ;
} /* emitRR */


void emitRM( char *op, char* r, int s, char *c)		// register, immediate
{ fprintf(code,"\t%5s  $%s,%d ",op,r,s);
  if (TraceCode && c) fprintf(code,"#\t%s",c) ;
  fprintf(code,"\n") ;
  if (highEmitLoc < emitLoc) highEmitLoc = emitLoc ;
} /* emitRM */

void emitRRR( char *op, char* r, char* s, char* t, char *c)		// register, register, register
{ fprintf(code,"\t%5s  $%s,$%s,$%s ",op,r,s,t);
  if (TraceCode && c) fprintf(code,"#\t%s",c) ;
  fprintf(code,"\n") ;
  if (highEmitLoc < emitLoc) highEmitLoc = emitLoc ;
} /* emitRRR */

void emitRRM( char *op, char* r, char* s, int t, char *c)	// register, register, immediate
{ fprintf(code,"\t%5s  $%s,$%s,%d ",op,r,s,t);
  if (TraceCode && c) fprintf(code,"#\t%s",c) ;
  fprintf(code,"\n") ;
  if (highEmitLoc < emitLoc) highEmitLoc = emitLoc ;
} /* emitRRM */

void emitRMR( char * op, char* r, int d, char* s, char *c)	// register, immediate, register
{ fprintf(code,"\t%5s  $%s,%d($%s) ",op,r,d,s);
  if (TraceCode && c) fprintf(code,"#\t%s",c) ;
  fprintf(code,"\n") ;
  if (highEmitLoc < emitLoc)  highEmitLoc = emitLoc ;
} /* emitRMR */

/* Function emitSkip skips "howMany" code
 * locations for later backpatch. It also
 * returns the current code position
 */
int emitSkip( int howMany)
{  int i = emitLoc;
   emitLoc += howMany ;
   if (highEmitLoc < emitLoc)  highEmitLoc = emitLoc ;
   return i;
} /* emitSkip */

/* Procedure emitBackup backs up to 
 * loc = a previously skipped location
 */
void emitBackup( int loc)
{ if (loc > highEmitLoc) emitComment("BUG in emitBackup");
  emitLoc = loc ;
} /* emitBackup */

/* Procedure emitRestore restores the current 
 * code position to the highest previously
 * unemitted position
 */
void emitRestore(void)
{ emitLoc = highEmitLoc;}

/* Procedure emitRM_Abs converts an absolute reference 
 * to a pc-relative reference when emitting a
 * register-to-memory TM instruction
 * op = the opcode
 * r = target register
 * a = the absolute location in memory
 * c = a comment to be printed if TraceCode is TRUE
 */
void emitBranch( char *op, char* r,char* label, int a, char * c)
{ 
  if(r)
	fprintf(code,"\t%5s  $%s, %s%d ",op,r,label,a);
  else
	fprintf(code,"\t%5s  %5s%d ",op,label,a);
  
  ++emitLoc ;
  if (TraceCode && c) fprintf(code,"\t%s",c) ;
  fprintf(code,"\n") ;
  if (highEmitLoc < emitLoc) highEmitLoc = emitLoc ;
} /* emitRM_Abs */
