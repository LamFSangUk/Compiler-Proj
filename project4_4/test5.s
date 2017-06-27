.data
 inin: .asciiz "input: "
 outout: .asciiz "output: "
newline: .asciiz "\n"
.text
input:
	 addi  $sp,$sp,-4 
	   sw  $ra,0($sp) 
li $v0, 4
la $a0, inin
syscall
li $v0, 5
syscall
	 move  $t1,$v0 
	 addi  $sp,$fp,-4 
	   lw  $ra,0($sp) 
	 addi  $sp,$sp,4 
	   lw  $fp,0($sp) 
	 addi  $sp,$sp,4 
jr $ra
output:
	 addi  $sp,$sp,-4 
	   sw  $ra,0($sp) 
li $v0, 4
la $a0, outout
syscall
li $v0, 1
lw $a0, 4($fp)
syscall
li $v0, 4
la $a0, newline
syscall
	 addi  $sp,$fp,-4 
	   lw  $ra,0($sp) 
	 addi  $sp,$sp,4 
	   lw  $fp,0($sp) 
	 addi  $sp,$sp,4 
jr $ra
.globl main
main:
	   li  $t1,0 
	 addi  $sp,$sp,-4 
	   sw  $fp,0($sp) 
	 move  $fp,$sp 
	 addi  $sp,$sp,-4 
	   sw  $ra,0($sp) 
	 addi  $sp,$sp,-16 
	   li  $t1,1 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
a memloc 0 para_num 0
	 addi  $t2,$fp,-8 
	 move  $t1,$t2 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	   sw  $t2,0($t1) 
	 move  $t1,$t2 
	   li  $t1,2 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
b memloc 1 para_num 0
	 addi  $t2,$fp,-12 
	 move  $t1,$t2 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	   sw  $t2,0($t1) 
	 move  $t1,$t2 
	   li  $t1,3 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
c memloc 2 para_num 0
	 addi  $t2,$fp,-16 
	 move  $t1,$t2 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	   sw  $t2,0($t1) 
	 move  $t1,$t2 
	   li  $t1,4 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
d memloc 3 para_num 0
	 addi  $t2,$fp,-20 
	 move  $t1,$t2 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	   sw  $t2,0($t1) 
	 move  $t1,$t2 
a memloc 0 para_num 0
	 addi  $t2,$fp,-8 
	   lw  $t1,0($t2) 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
b memloc 1 para_num 0
	 addi  $t2,$fp,-12 
	   lw  $t1,0($t2) 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	  add  $t1,$t2,$t1 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
c memloc 2 para_num 0
	 addi  $t2,$fp,-16 
	   lw  $t1,0($t2) 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
d memloc 3 para_num 0
	 addi  $t2,$fp,-20 
	   lw  $t1,0($t2) 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	  add  $t1,$t2,$t1 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	   li  $t1,5 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	  add  $t1,$t2,$t1 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	   li  $t1,6 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	  add  $t1,$t2,$t1 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	  add  $t1,$t2,$t1 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	   li  $t1,7 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	  add  $t1,$t2,$t1 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	   li  $t1,8 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	   li  $t1,9 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	  mul  $t1,$t2,$t1 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	  add  $t1,$t2,$t1 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
a memloc 0 para_num 0
	 addi  $t2,$fp,-8 
	 move  $t1,$t2 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	   sw  $t2,0($t1) 
	 move  $t1,$t2 
a memloc 0 para_num 0
	 addi  $t2,$fp,-8 
	   lw  $t1,0($t2) 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	 addi  $sp,$sp,-4 
	   sw  $fp,0($sp) 
	 move  $fp,$sp 
	jal	output
	 addi  $sp,$sp,4 
c memloc 2 para_num 0
	 addi  $t2,$fp,-16 
	   lw  $t1,0($t2) 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
d memloc 3 para_num 0
	 addi  $t2,$fp,-20 
	   lw  $t1,0($t2) 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	  mul  $t1,$t2,$t1 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
b memloc 1 para_num 0
	 addi  $t2,$fp,-12 
	   lw  $t1,0($t2) 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	  sub  $t1,$t2,$t1 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
b memloc 1 para_num 0
	 addi  $t2,$fp,-12 
	 move  $t1,$t2 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	   sw  $t2,0($t1) 
	 move  $t1,$t2 
b memloc 1 para_num 1
	 addi  $t2,$fp,-8 
	   lw  $t1,0($t2) 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	 addi  $sp,$sp,-4 
	   sw  $fp,0($sp) 
	 move  $fp,$sp 
	jal	output
	 addi  $sp,$sp,4 
d memloc 3 para_num 1
	 addi  $t2,$fp,-16 
	   lw  $t1,0($t2) 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
c memloc 2 para_num 1
	 addi  $t2,$fp,-12 
	   lw  $t1,0($t2) 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	   li  $t1,1 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	  sub  $t1,$t2,$t1 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	  div  $t1,$t2,$t1 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
c memloc 2 para_num 1
	 addi  $t2,$fp,-12 
	 move  $t1,$t2 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	   sw  $t2,0($t1) 
	 move  $t1,$t2 
c memloc 2 para_num 1
	 addi  $t2,$fp,-12 
	   lw  $t1,0($t2) 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	 addi  $sp,$sp,-4 
	   sw  $fp,0($sp) 
	 move  $fp,$sp 
	jal	output
	 addi  $sp,$sp,4 
a memloc 0 para_num 1
	 addi  $t2,$fp,-4 
	   lw  $t1,0($t2) 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
b memloc 1 para_num 1
	 addi  $t2,$fp,-8 
	   lw  $t1,0($t2) 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	  div  $t1,$t2,$t1 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
c memloc 2 para_num 1
	 addi  $t2,$fp,-12 
	   lw  $t1,0($t2) 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
c memloc 2 para_num 1
	 addi  $t2,$fp,-12 
	   lw  $t1,0($t2) 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	  mul  $t1,$t2,$t1 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	  sub  $t1,$t2,$t1 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
d memloc 3 para_num 1
	 addi  $t2,$fp,-16 
	 move  $t1,$t2 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	   sw  $t2,0($t1) 
	 move  $t1,$t2 
d memloc 3 para_num 1
	 addi  $t2,$fp,-16 
	   lw  $t1,0($t2) 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	 addi  $sp,$sp,-4 
	   sw  $fp,0($sp) 
	 move  $fp,$sp 
	jal	output
	 addi  $sp,$sp,4 
	 addi  $sp,$fp,-4 
	   lw  $ra,0($sp) 
	 addi  $sp,$sp,4 
	   lw  $fp,0($sp) 
	 addi  $sp,$sp,4 
	jr $ra
