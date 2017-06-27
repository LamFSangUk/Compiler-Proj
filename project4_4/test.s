# C- Compilation to SPIM Code
# File: test.s
.data
xx: .word 0
aa: .word 0
ab: .word 0
ba: .word 0:3
bb: .word 0:5
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
--3
--4
--8
x:
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $ra,0($sp) #	push temp(save_reg_num) to sp
	 addi  $sp,$sp,0 #	how_many
--8
# -> compound
# <- compound
	 addi  $sp,$fp,-4 #	sp=fp-4
	   lw  $ra,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	   lw  $fp,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	jr $ra
--13
mul:
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $ra,0($sp) #	push temp(save_reg_num) to sp
	 addi  $sp,$sp,0 #	how_many
--13
# -> compound
--12
# -> return
--12
# -> Op 

275
--12
# -> Const
	   li  $t1,2 
# <- Const
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--12
# -> Id
     t	 addi  $t2,$fp,0 #	not yet implemented
	   lw  $t1,0($t2) 
# <- Id
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	  mul  $t1,$t2,$t1 #	t2=t2*ac
# <- Op
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
--24
test:
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $ra,0($sp) #	push temp(save_reg_num) to sp
------------x
------------tmp
	 addi  $sp,$sp,-2 #	how_many
--24
# -> compound
--17
--18
--19
# -> Op 

268
--19
# -> Const
	   li  $t1,3 
# <- Const
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--19
# -> Array
--19
# -> Const
	   li  $t1,2 
# <- Const
	   la  $t2,bb
	   li  $t3,4 
	  mul  $t3,$t1,$t3 
	  add  $t1,$t2,$t3 
# <- Array
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	   sw  $t2,0($t1) 
	 move  $t1,$t2 
# <- Op
--21
# -> Op 

268
--21
# -> Id
     x	 addi  $t2,$fp,3 #	not yet implemented
	   lw  $t1,0($t2) 
# <- Id
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	 addi  $sp,$sp,-4 
	   sw  $fp,0($sp) 
	 move  $fp,$sp 
	jal	mul
	 addi  $sp,$sp,1 
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--21
# -> Id
   tmp	 addi  $t2,$fp,4 #	not yet implemented
	 move  $t1,$t2 
# <- Id
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	   sw  $t2,0($t1) 
	 move  $t1,$t2 
# <- Op
--23
# -> Op 

269
--23
# -> Op 

273
--23
# -> Id
    aa	 addi  $t2,$fp,0 #	not yet implemented
	   lw  $t1,0($t2) 
# <- Id
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--23
# -> Op 

276
--23
# -> Op 

275
--23
# -> Id
    ab	 addi  $t2,$fp,1 #	not yet implemented
	   lw  $t1,0($t2) 
# <- Id
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--23
# -> Op 

274
--23
# -> Array
--23
# -> Const
	   li  $t1,0 
# <- Const
	   la  $t2,bb
	   li  $t3,4 
	  mul  $t3,$t1,$t3 
	  add  $t1,$t2,$t3 
	   lw  $t1,0($t1) 
# <- Array
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--23
# -> Array
--23
# -> Const
	   li  $t1,0 
# <- Const
	   la  $t2,bb
	   li  $t3,4 
	  mul  $t3,$t1,$t3 
	  add  $t1,$t2,$t3 
	   lw  $t1,0($t1) 
# <- Array
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	  sub  $t1,$t2,$t1 #	op -
# <- Op
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	  mul  $t1,$t2,$t1 #	t2=t2*ac
# <- Op
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--23
# -> Array
--23
# -> Const
	   li  $t1,1 
# <- Const
	   la  $t2,bb
	   li  $t3,4 
	  mul  $t3,$t1,$t3 
	  add  $t1,$t2,$t3 
	   lw  $t1,0($t1) 
# <- Array
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	  div  $t1,$t2,$t1 #	op /
# <- Op
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	  add  $t1,$t2,$t1 #	op +
# <- Op
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--23
# -> Op 

273
--23
# -> Op 

275
--23
# -> Id
    aa	 addi  $t2,$fp,0 #	not yet implemented
	   lw  $t1,0($t2) 
# <- Id
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--23
# -> Id
    ab	 addi  $t2,$fp,1 #	not yet implemented
	   lw  $t1,0($t2) 
# <- Id
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	  mul  $t1,$t2,$t1 #	t2=t2*ac
# <- Op
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--23
# -> Op 

276
--23
# -> Array
--23
# -> Const
	   li  $t1,0 
# <- Const
	   la  $t2,ba
	   li  $t3,4 
	  mul  $t3,$t1,$t3 
	  add  $t1,$t2,$t3 
	   lw  $t1,0($t1) 
# <- Array
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--23
# -> Op 

273
--23
# -> Array
--23
# -> Const
	   li  $t1,0 
# <- Const
	   la  $t2,bb
	   li  $t3,4 
	  mul  $t3,$t1,$t3 
	  add  $t1,$t2,$t3 
	   lw  $t1,0($t1) 
# <- Array
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--23
# -> Const
	   li  $t1,3 
# <- Const
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	  add  $t1,$t2,$t1 #	op +
# <- Op
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	 addi  $sp,$sp,-4 
	   sw  $fp,0($sp) 
	 move  $fp,$sp 
	jal	mul
	 addi  $sp,$sp,1 
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
	  slt  $t1,$t2,$t1 #	slt(<) t2, ac
# <- Op
# <- compound
	 addi  $sp,$fp,-4 #	sp=fp-4
	   lw  $ra,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	   lw  $fp,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	jr $ra
--26
--71
.global main
main:
	   li  $t1,0 #	load const
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $fp,0($sp) #	push temp(save_reg_num) to sp
	 move  $fp,$sp #	fp=sp
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $ra,0($sp) #	push temp(save_reg_num) to sp
------------ca
------------cb
size: 3
------------b
------------ca
size: 3
------------ca
------------c
	 addi  $sp,$sp,-10 #	how_many
--71
# -> compound
--30
--31
--37
# -> if
--33
# -> Op 

266
--33
# -> Id
    ca	 addi  $t2,$fp,0 #	not yet implemented
	   lw  $t1,0($t2) 
# <- Id
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--33
# -> Const
	   li  $t1,0 
# <- Const
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	  seq  $t1,$t2,$t1 #	seq(==) t2, ac
# <- Op
	  bne:     t1, label0 
--35
# -> if-else
--34
# -> Op 

266
--34
# -> Array
--34
# -> Const
	   li  $t1,0 
# <- Const
	 addi  $t2,$fp,-20 
	   li  $t3,4 
	  mul  $t3,$t1,$t3 
	  add  $t1,$t2,$t3 
	   lw  $t1,0($t1) 
# <- Array
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--34
# -> Const
	   li  $t1,1 
# <- Const
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	  seq  $t1,$t2,$t1 #	seq(==) t2, ac
# <- Op
	  bne:     t1, label1 
--34
# -> Op 

268
--34
# -> Op 

273
--34
# -> Op 

274
--34
# -> Op 

273
--34
# -> Const
	   li  $t1,2 
# <- Const
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--34
# -> Const
	   li  $t1,5 
# <- Const
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	  add  $t1,$t2,$t1 #	op +
# <- Op
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--34
# -> Const
	   li  $t1,3 
# <- Const
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	  sub  $t1,$t2,$t1 #	op -
# <- Op
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--34
# -> Const
	   li  $t1,7 
# <- Const
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	  add  $t1,$t2,$t1 #	op +
# <- Op
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--34
# -> Array
--34
# -> Const
	   li  $t1,2 
# <- Const
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
	    j:  label2 
label1:
--35
# -> Op 

268
--35
# -> Const
	   li  $t1,3 
# <- Const
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--35
# -> Array
--35
# -> Const
	   li  $t1,2 
# <- Const
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
label2:
# <- if-else
label0:
# <- if
--37
# -> Op 

268
--37
# -> Op 

268
--37
# -> Op 

268
--37
# -> Id
    aa	 addi  $t2,$fp,0 #	not yet implemented
	   lw  $t1,0($t2) 
# <- Id
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--37
# -> Array
--37
# -> Const
	   li  $t1,0 
# <- Const
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
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--37
# -> Array
--37
# -> Const
	   li  $t1,2 
# <- Const
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
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--37
# -> Id
    ca	 addi  $t2,$fp,0 #	not yet implemented
	 move  $t1,$t2 
# <- Id
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	   sw  $t2,0($t1) 
	 move  $t1,$t2 
# <- Op
--40
# -> if-else
--39
# -> Op 

266
--39
# -> Id
    ca	 addi  $t2,$fp,0 #	not yet implemented
	   lw  $t1,0($t2) 
# <- Id
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--39
# -> Const
	   li  $t1,3 
# <- Const
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	  seq  $t1,$t2,$t1 #	seq(==) t2, ac
# <- Op
	  bne:     t1, label3 
--39
# -> Op 

268
--39
# -> Array
--39
# -> Const
	   li  $t1,2 
# <- Const
	 addi  $t2,$fp,-20 
	   li  $t3,4 
	  mul  $t3,$t1,$t3 
	  add  $t1,$t2,$t3 
	   lw  $t1,0($t1) 
# <- Array
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--39
# -> Array
--39
# -> Const
	   li  $t1,0 
# <- Const
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
	    j:  label4 
label3:
--40
# -> while
label5:
--40
# -> Id
    ca	 addi  $t2,$fp,0 #	not yet implemented
	   lw  $t1,0($t2) 
# <- Id
	 bnez:     t1, label6 
--40
# -> Op 

268
--40
# -> Const
	   li  $t1,4 
# <- Const
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--40
# -> Array
--40
# -> Const
	   li  $t1,1 
# <- Const
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
	    j:  label5 
label6:
# <- while
label4:
# <- if-else
--62
# -> compound
--61
# -> while
label7:
--43
# -> Array
--43
# -> Const
	   li  $t1,1 
# <- Const
	 addi  $t2,$fp,-20 
	   li  $t3,4 
	  mul  $t3,$t1,$t3 
	  add  $t1,$t2,$t3 
	   lw  $t1,0($t1) 
# <- Array
	 bnez:     t1, label8 
--61
# -> compound
--60
# -> if-else
--44
# -> Op 

266
--44
# -> Array
--44
# -> Const
	   li  $t1,0 
# <- Const
	 addi  $t2,$fp,-20 
	   li  $t3,4 
	  mul  $t3,$t1,$t3 
	  add  $t1,$t2,$t3 
	   lw  $t1,0($t1) 
# <- Array
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--44
# -> Array
--44
# -> Const
	   li  $t1,2 
# <- Const
	 addi  $t2,$fp,-20 
	   li  $t3,4 
	  mul  $t3,$t1,$t3 
	  add  $t1,$t2,$t3 
	   lw  $t1,0($t1) 
# <- Array
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	  seq  $t1,$t2,$t1 #	seq(==) t2, ac
# <- Op
	  bne:     t1, label9 
--53
# -> compound
--45
--52
# -> compound
--47
--51
# -> compound
--50
# <- compound
# <- compound
# <- compound
	    j:  label10 
label9:
--60
# -> compound
--55
--56
# -> Op 

268
--56
# -> Const
	   li  $t1,4 
# <- Const
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--56
# -> Id
     c	 addi  $t2,$fp,0 #	not yet implemented
	 move  $t1,$t2 
# <- Id
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	   sw  $t2,0($t1) 
	 move  $t1,$t2 
# <- Op
--60
# -> if
--57
# -> Op 

266
--57
# -> Id
     c	 addi  $t2,$fp,0 #	not yet implemented
	   lw  $t1,0($t2) 
# <- Id
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--57
# -> Const
	   li  $t1,4 
# <- Const
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	  seq  $t1,$t2,$t1 #	seq(==) t2, ac
# <- Op
	  bne:     t1, label11 
--59
# -> compound
--58
# -> return
	 addi  $sp,$fp,-4 
	   lw  $ra,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	   lw  $fp,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	jr $ra
# <- return
# <- compound
label11:
# <- if
# <- compound
label10:
# <- if-else
# <- compound
	    j:  label7 
label8:
# <- while
# <- compound
--66
# -> compound
# <- compound
--68
	 addi  $sp,$sp,-4 
	   sw  $fp,0($sp) 
	 move  $fp,$sp 
	jal	x
	 addi  $sp,$sp,0 
--69
# -> Const
	   li  $t1,3 
# <- Const
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
# -> Op 

274
--69
# -> Const
	   li  $t1,5 
# <- Const
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--69
# -> Op 

276
--69
# -> Id
    ab	 addi  $t2,$fp,1 #	not yet implemented
	   lw  $t1,0($t2) 
# <- Id
	 addi  $sp,$sp,-4 #	sp -= 4
	   sw  $t1,0($sp) #	push temp(save_reg_num) to sp
--69
# -> Const
	   li  $t1,3 
# <- Const
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	  div  $t1,$t2,$t1 #	op /
# <- Op
	   lw  $t2,0($sp) #	pop temp(save_reg_num) to sp
	 addi  $sp,$sp,4 #	sp += 4
	  sub  $t1,$t2,$t1 #	op -
# <- Op
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
# -> Id
	 move  $t1,$t2 
	   lw  $t1,0($t2) 
# <- Id
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	 addi  $sp,$sp,-4 
	   sw  $fp,0($sp) 
	 move  $fp,$sp 
	jal	test
	 addi  $sp,$sp,3 
--70
# -> return
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
# End of execution.
