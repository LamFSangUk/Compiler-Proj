# C- Compilation to SPIM Code
# File: t.s
.data
brr: .word 0:20
crr: .word 0:30
arr: .word 0:10
 inin: .asciiz "input: "
 outout: .asciiz "output: "
newline: .asciiz "\n"
.text
input:
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $ra,0($sp) #	push temp(save_reg_num) to sp
li $v0, 4
la $a0, inin
syscall
li $v0, 5
syscall
	 move  $t1,$v0 #	move ac to v0
	 addi  $sp,$fp,-4 #	sp = fp - 4
	   lw  $ra,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	   lw  $fp,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
jr $ra
output:
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $ra,0($sp) #	push temp(save_reg_num) to sp
li $v0, 4
la $a0, outout
syscall
li $v0, 1
lw $a0, 4($fp)
syscall
li $v0, 4
la $a0, newline
syscall
	 addi  $sp,$fp,-4 #	sp = fp - 4
	   lw  $ra,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	   lw  $fp,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
jr $ra
--1
--2
--6
f:
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $ra,0($sp) #	push temp(save_reg_num) to sp
	 addi  $sp,$sp,0 #	how_many
--6
# -> compound
# <- compound
	 addi  $sp,$fp,-4 #	sp=fp-4
	   lw  $ra,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	   lw  $fp,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	jr $ra
--24
func:
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $ra,0($sp) #	push temp(save_reg_num) to sp
------------a
size: 10
------------i
------------wvar
	 addi  $sp,$sp,-12 #	how_many
--24
# -> compound
--9
--10
--11
# -> Op 

268
--11
# -> Const
	   li  $t1,0 
# <- Const
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--11
# -> Id
     i	 addi  $t2,$fp,3 #	not yet implemented
	 move  $t1,$t2 
# <- Id
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	   sw  $t2,0($t1) 
	 move  $t1,$t2 
# <- Op
--21
# -> while
label0:
--12
# -> Op 

266
--12
# -> Id
  parB	 addi  $t2,$fp,1 #	not yet implemented
	   lw  $t1,0($t2) 
# <- Id
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--12
# -> Const
	   li  $t1,0 
# <- Const
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	  seq  $t1,$t2,$t1 #	seq(==) t2, ac
# <- Op
	 bnez:     t1, label1 
--21
# -> compound
--13
--14
# -> Op 

268
--14
# -> Op 

275
--14
# -> Op 

275
--14
# -> Id
  parB	 addi  $t2,$fp,1 #	not yet implemented
	   lw  $t1,0($t2) 
# <- Id
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--14
# -> Id
	 move  $t1,$t2 
	   lw  $t1,0($t2) 
# <- Id
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
# -> Id
     i	 addi  $t2,$fp,3 #	not yet implemented
	   lw  $t1,0($t2) 
# <- Id
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	 addi  $sp,$sp,-4 
	   sw  $fp,0($sp) 
	 move  $fp,$sp 
	jal	func
	 addi  $sp,$sp,2 
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	  mul  $t1,$t2,$t1 #	t2=t2*ac
# <- Op
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--14
# -> Op 

273
--14
# -> Array
--14
# -> Id
     i	 addi  $t2,$fp,3 #	not yet implemented
	   lw  $t1,0($t2) 
# <- Id
	 addi  $t2,$fp,-20 
	   li  $t3,4 
	  mul  $t3,$t1,$t3 
	  add  $t1,$t2,$t3 
	   lw  $t1,0($t1) 
# <- Array
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--14
# -> Op 

276
--14
# -> Array
--14
# -> Op 

273
--14
# -> Id
     i	 addi  $t2,$fp,3 #	not yet implemented
	   lw  $t1,0($t2) 
# <- Id
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--14
# -> Const
	   li  $t1,1 
# <- Const
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	  add  $t1,$t2,$t1 #	op +
# <- Op
	 addi  $t2,$fp,-20 
	   li  $t3,4 
	  mul  $t3,$t1,$t3 
	  add  $t1,$t2,$t3 
	   lw  $t1,0($t1) 
# <- Array
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--14
# -> Id
  parB	 addi  $t2,$fp,1 #	not yet implemented
	   lw  $t1,0($t2) 
# <- Id
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	  div  $t1,$t2,$t1 #	op /
# <- Op
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	  add  $t1,$t2,$t1 #	op +
# <- Op
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	  mul  $t1,$t2,$t1 #	t2=t2*ac
# <- Op
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--14
# -> Array
--14
# -> Id
     i	 addi  $t2,$fp,3 #	not yet implemented
	 move  $t1,$t2 
# <- Id
	 addi  $t2,$fp,-20 
	   li  $t3,4 
	  mul  $t3,$t1,$t3 
	  add  $t1,$t2,$t3 
# <- Array
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	   sw  $t2,0($t1) 
	 move  $t1,$t2 
# <- Op
--15
# -> Op 

268
--15
# -> Op 

274
--15
# -> Id
  parB	 addi  $t2,$fp,1 #	not yet implemented
	   lw  $t1,0($t2) 
# <- Id
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--15
# -> Const
	   li  $t1,1 
# <- Const
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	  sub  $t1,$t2,$t1 #	op -
# <- Op
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--15
# -> Id
  parB	 addi  $t2,$fp,1 #	not yet implemented
	 move  $t1,$t2 
# <- Id
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	   sw  $t2,0($t1) 
	 move  $t1,$t2 
# <- Op
--16
# -> Op 

268
--16
# -> Op 

273
--16
# -> Id
     i	 addi  $t2,$fp,3 #	not yet implemented
	   lw  $t1,0($t2) 
# <- Id
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--16
# -> Const
	   li  $t1,1 
# <- Const
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	  add  $t1,$t2,$t1 #	op +
# <- Op
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--16
# -> Id
     i	 addi  $t2,$fp,3 #	not yet implemented
	 move  $t1,$t2 
# <- Id
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	   sw  $t2,0($t1) 
	 move  $t1,$t2 
# <- Op
--21
# -> if
--17
# -> Op 

268
--17
# -> Array
--17
# -> Const
	   li  $t1,12 
# <- Const
	 addi  $t2,$fp,-20 
	   li  $t3,4 
	  mul  $t3,$t1,$t3 
	  add  $t1,$t2,$t3 
	   lw  $t1,0($t1) 
# <- Array
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--17
# -> Id
  parB	 addi  $t2,$fp,1 #	not yet implemented
	 move  $t1,$t2 
# <- Id
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	   sw  $t2,0($t1) 
	 move  $t1,$t2 
# <- Op
	  bne:     t1, label2 
--20
# -> if-else
--18
# -> Op 

266
--18
# -> Id
  wvar	 addi  $t2,$fp,0 #	not yet implemented
	   lw  $t1,0($t2) 
# <- Id
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--18
# -> Const
	   li  $t1,1 
# <- Const
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	  seq  $t1,$t2,$t1 #	seq(==) t2, ac
# <- Op
	  bne:     t1, label3 
--19
# -> Op 

268
--19
# -> Const
	   li  $t1,0 
# <- Const
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--19
# -> Id
     i	 addi  $t2,$fp,3 #	not yet implemented
	 move  $t1,$t2 
# <- Id
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	   sw  $t2,0($t1) 
	 move  $t1,$t2 
# <- Op
	    j:  label4 
label3:
--20
# -> Op 

268
--20
# -> Const
	   li  $t1,1 
# <- Const
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--20
# -> Id
     i	 addi  $t2,$fp,3 #	not yet implemented
	 move  $t1,$t2 
# <- Id
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	   sw  $t2,0($t1) 
	 move  $t1,$t2 
# <- Op
label4:
# <- if-else
label2:
# <- if
# <- compound
	    j:  label0 
label1:
# <- while
--23
# -> return
--23
# -> Array
--23
# -> Const
	   li  $t1,2 
# <- Const
	 addi  $t2,$fp,-20 
	   li  $t3,4 
	  mul  $t3,$t1,$t3 
	  add  $t1,$t2,$t3 
	   lw  $t1,0($t1) 
# <- Array
	 addi  $sp,$fp,-4 
	   lw  $ra,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	   lw  $fp,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	jr $ra
# <- return
# <- compound
	 addi  $sp,$fp,-4 #	sp=fp-4
	   lw  $ra,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	   lw  $fp,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	jr $ra
--26
--51
.global main
main:
	   li  $t1,0 #	load const
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $fp,0($sp) #	push temp(save_reg_num) to sp
	 move  $fp,$sp #	fp=sp
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $ra,0($sp) #	push temp(save_reg_num) to sp
------------tmp
------------one
------------two
------------tmp
------------tmp
------------tmp
	 addi  $sp,$sp,-6 #	how_many
--51
# -> compound
--29
--49
# -> while
label5:
--31
# -> Op 

268
--31
# -> Const
	   li  $t1,1 
# <- Const
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--31
# -> Id
   tmp	 addi  $t2,$fp,0 #	not yet implemented
	 move  $t1,$t2 
# <- Id
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	   sw  $t2,0($t1) 
	 move  $t1,$t2 
# <- Op
	 bnez:     t1, label6 
--49
# -> compound
--32
--33
# -> Op 

268
--33
# -> Array
--33
# -> Const
	   li  $t1,1 
# <- Const
	   la  $t2,arr
	   li  $t3,4 
	  mul  $t3,$t1,$t3 
	  add  $t1,$t2,$t3 
	   lw  $t1,0($t1) 
# <- Array
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--33
# -> Id
   one	 addi  $t2,$fp,0 #	not yet implemented
	 move  $t1,$t2 
# <- Id
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	   sw  $t2,0($t1) 
	 move  $t1,$t2 
# <- Op
--48
# -> if-else
--34
# -> Op 

266
--34
# -> Id
   one	 addi  $t2,$fp,0 #	not yet implemented
	   lw  $t1,0($t2) 
# <- Id
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--34
# -> Array
--34
# -> Const
	   li  $t1,2 
# <- Const
	   la  $t2,brr
	   li  $t3,4 
	  mul  $t3,$t1,$t3 
	  add  $t1,$t2,$t3 
	   lw  $t1,0($t1) 
# <- Array
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	  seq  $t1,$t2,$t1 #	seq(==) t2, ac
# <- Op
	  bne:     t1, label7 
--35
# -> Op 

268
--35
# -> Op 

266
--35
# -> Id
   one	 addi  $t2,$fp,0 #	not yet implemented
	   lw  $t1,0($t2) 
# <- Id
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--35
# -> Array
--35
# -> Const
	   li  $t1,3 
# <- Const
	   la  $t2,brr
	   li  $t3,4 
	  mul  $t3,$t1,$t3 
	  add  $t1,$t2,$t3 
	   lw  $t1,0($t1) 
# <- Array
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	  seq  $t1,$t2,$t1 #	seq(==) t2, ac
# <- Op
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--35
# -> Id
   tmp	 addi  $t2,$fp,0 #	not yet implemented
	 move  $t1,$t2 
# <- Id
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	   sw  $t2,0($t1) 
	 move  $t1,$t2 
# <- Op
	    j:  label8 
label7:
--48
# -> compound
--37
--38
--39
# -> Op 

268
--39
# -> Array
--39
# -> Const
	   li  $t1,2 
# <- Const
	   la  $t2,arr
	   li  $t3,4 
	  mul  $t3,$t1,$t3 
	  add  $t1,$t2,$t3 
	   lw  $t1,0($t1) 
# <- Array
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--39
# -> Id
   two	 addi  $t2,$fp,0 #	not yet implemented
	 move  $t1,$t2 
# <- Id
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	   sw  $t2,0($t1) 
	 move  $t1,$t2 
# <- Op
--46
# -> while
label9:
--40
# -> Op 

266
--40
# -> Array
--40
# -> Id
   one	 addi  $t2,$fp,0 #	not yet implemented
	   lw  $t1,0($t2) 
# <- Id
	   la  $t2,arr
	   li  $t3,4 
	  mul  $t3,$t1,$t3 
	  add  $t1,$t2,$t3 
	   lw  $t1,0($t1) 
# <- Array
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--40
# -> Array
--40
# -> Id
   tmp	 addi  $t2,$fp,1 #	not yet implemented
	   lw  $t1,0($t2) 
# <- Id
	   la  $t2,brr
	   li  $t3,4 
	  mul  $t3,$t1,$t3 
	  add  $t1,$t2,$t3 
	   lw  $t1,0($t1) 
# <- Array
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	  seq  $t1,$t2,$t1 #	seq(==) t2, ac
# <- Op
	 bnez:     t1, label10 
--46
# -> compound
--41
--46
# -> if
--42
# -> Const
	   li  $t1,1 
# <- Const
	  bne:     t1, label11 
--45
# -> compound
--43
--44
# -> Op 

268
--44
# -> Id
   one	 addi  $t2,$fp,0 #	not yet implemented
	   lw  $t1,0($t2) 
# <- Id
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--44
# -> Id
   tmp	 addi  $t2,$fp,0 #	not yet implemented
	 move  $t1,$t2 
# <- Id
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	   sw  $t2,0($t1) 
	 move  $t1,$t2 
# <- Op
# <- compound
label11:
# <- if
# <- compound
	    j:  label9 
label10:
# <- while
--47
# -> Op 

268
--47
# -> Id
   two	 addi  $t2,$fp,0 #	not yet implemented
	   lw  $t1,0($t2) 
# <- Id
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--47
# -> Id
   tmp	 addi  $t2,$fp,1 #	not yet implemented
	 move  $t1,$t2 
# <- Id
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	   sw  $t2,0($t1) 
	 move  $t1,$t2 
# <- Op
# <- compound
label8:
# <- if-else
# <- compound
	    j:  label5 
label6:
# <- while
--50
# -> Op 

268
--50
# -> Id
	   la  $t1,arr
	   lw  $t1,0($t2) 
# <- Id
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
# -> Const
	   li  $t1,45 
# <- Const
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	 addi  $sp,$sp,-4 
	   sw  $fp,0($sp) 
	 move  $fp,$sp 
	jal	func
	 addi  $sp,$sp,2 
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--50
# -> Id
   tmp	 addi  $t2,$fp,0 #	not yet implemented
	 move  $t1,$t2 
# <- Id
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	   sw  $t2,0($t1) 
	 move  $t1,$t2 
# <- Op
# <- compound
	 addi  $sp,$fp,-4 #	sp=fp-4
	   lw  $ra,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	   lw  $fp,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	jr $ra
# End of execution.
