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
k:
	 addi  $sp,$sp,-4 
	   sw  $ra,0($sp) 
	 addi  $sp,$sp,0 
	 addi  $t2,$fp,0 
	   lw  $t1,0($t2) 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	   li  $t1,3 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	  add  $t1,$t2,$t1 
	 addi  $sp,$fp,-4 
	   lw  $ra,0($sp) 
	 addi  $sp,$sp,4 
	   lw  $fp,0($sp) 
	 addi  $sp,$sp,4 
	jr $ra
	 addi  $sp,$fp,-4 
	   lw  $ra,0($sp) 
	 addi  $sp,$sp,4 
	   lw  $fp,0($sp) 
	 addi  $sp,$sp,4 
	jr $ra
g:
	 addi  $sp,$sp,-4 
	   sw  $ra,0($sp) 
	 addi  $sp,$sp,-4 
	 addi  $t2,$fp,0 
	   lw  $t1,0($t2) 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	   li  $t1,1 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	  seq  $t1,$t2,$t1 
	 bnez  $t1, label0 
	    j  label1 
label0:
	   li  $t1,2 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	 addi  $sp,$sp,-4 
	   sw  $fp,0($sp) 
	 move  $fp,$sp 
	jal	k
	 addi  $sp,$sp,4 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	 addi  $t2,$fp,0 
	 move  $t1,$t2 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	   sw  $t2,0($t1) 
	 move  $t1,$t2 
label1:
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
	 addi  $sp,$sp,-8 
	   li  $t1,1 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	 addi  $t2,$fp,0 
	 move  $t1,$t2 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	   sw  $t2,0($t1) 
	 move  $t1,$t2 
	   li  $t1,2 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	 addi  $t2,$fp,0 
	 move  $t1,$t2 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	   sw  $t2,0($t1) 
	 move  $t1,$t2 
	 addi  $t2,$fp,0 
	   lw  $t1,0($t2) 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	 addi  $sp,$sp,-4 
	   sw  $fp,0($sp) 
	 move  $fp,$sp 
	jal	g
	 addi  $sp,$sp,4 
	 addi  $t2,$fp,0 
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
