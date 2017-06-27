.data
brr: .word 0:20
crr: .word 0:30
arr: .word 0:10
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
f:
	 addi  $sp,$sp,-4 
	   sw  $ra,0($sp) 
	 addi  $sp,$sp,0 
	 addi  $sp,$fp,-4 
	   lw  $ra,0($sp) 
	 addi  $sp,$sp,4 
	   lw  $fp,0($sp) 
	 addi  $sp,$sp,4 
	jr $ra
func:
	 addi  $sp,$sp,-4 
	   sw  $ra,0($sp) 
	 addi  $sp,$sp,-48 
	   li  $t1,0 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	 addi  $t2,$fp,-20 
	 move  $t1,$t2 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	   sw  $t2,0($t1) 
	 move  $t1,$t2 
label0:
	 addi  $t2,$fp,8 
	   lw  $t1,0($t2) 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	   li  $t1,0 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	  seq  $t1,$t2,$t1 
	 bnez  $t1, label1 
	 addi  $t2,$fp,8 
	   lw  $t1,0($t2) 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	 move  $t1,$t2 
	   lw  $t1,0($t2) 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	 addi  $t2,$fp,-20 
	   lw  $t1,0($t2) 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	 addi  $sp,$sp,-4 
	   sw  $fp,0($sp) 
	 move  $fp,$sp 
	jal	func
	 addi  $sp,$sp,8 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	  mul  $t1,$t2,$t1 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	 addi  $t2,$fp,-20 
	   lw  $t1,0($t2) 
	 addi  $t2,$fp,-20 
	   li  $t3,4 
	  mul  $t3,$t1,$t3 
	 addi  $t1,$t2,$t3 
	   lw  $t1,0($t1) 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	 addi  $t2,$fp,-20 
	   lw  $t1,0($t2) 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	   li  $t1,1 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	  add  $t1,$t2,$t1 
	 addi  $t2,$fp,-20 
	   li  $t3,4 
	  mul  $t3,$t1,$t3 
	 addi  $t1,$t2,$t3 
	   lw  $t1,0($t1) 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	 addi  $t2,$fp,8 
	   lw  $t1,0($t2) 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	  div  $t1,$t2,$t1 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	  add  $t1,$t2,$t1 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	  mul  $t1,$t2,$t1 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	 addi  $t2,$fp,-20 
	 move  $t1,$t2 
	 addi  $t2,$fp,-20 
	   li  $t3,4 
	  mul  $t3,$t1,$t3 
	 addi  $t1,$t2,$t3 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	   sw  $t2,0($t1) 
	 move  $t1,$t2 
	 addi  $t2,$fp,8 
	   lw  $t1,0($t2) 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	   li  $t1,1 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	  sub  $t1,$t2,$t1 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	 addi  $t2,$fp,8 
	 move  $t1,$t2 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	   sw  $t2,0($t1) 
	 move  $t1,$t2 
	 addi  $t2,$fp,-20 
	   lw  $t1,0($t2) 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	   li  $t1,1 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	  add  $t1,$t2,$t1 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	 addi  $t2,$fp,-20 
	 move  $t1,$t2 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	   sw  $t2,0($t1) 
	 move  $t1,$t2 
	   li  $t1,12 
	 addi  $t2,$fp,-20 
	   li  $t3,4 
	  mul  $t3,$t1,$t3 
	 addi  $t1,$t2,$t3 
	   lw  $t1,0($t1) 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	 addi  $t2,$fp,8 
	 move  $t1,$t2 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	   sw  $t2,0($t1) 
	 move  $t1,$t2 
	 bnez  $t1, label2 
	 addi  $t2,$fp,-8 
	   lw  $t1,0($t2) 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	   li  $t1,1 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	  seq  $t1,$t2,$t1 
	 bnez  $t1, label3 
	   li  $t1,0 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	 addi  $t2,$fp,-20 
	 move  $t1,$t2 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	   sw  $t2,0($t1) 
	 move  $t1,$t2 
	    j  label4 
label3:
	   li  $t1,1 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	 addi  $t2,$fp,-20 
	 move  $t1,$t2 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	   sw  $t2,0($t1) 
	 move  $t1,$t2 
label4:
label2:
	    j  label0 
label1:
	   li  $t1,2 
	 addi  $t2,$fp,-20 
	   li  $t3,4 
	  mul  $t3,$t1,$t3 
	 addi  $t1,$t2,$t3 
	   lw  $t1,0($t1) 
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
.globl main
main:
	   li  $t1,0 
	 addi  $sp,$sp,-4 
	   sw  $fp,0($sp) 
	 move  $fp,$sp 
	 addi  $sp,$sp,-4 
	   sw  $ra,0($sp) 
	 addi  $sp,$sp,-24 
label5:
	   li  $t1,1 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	 addi  $t2,$fp,-8 
	 move  $t1,$t2 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	   sw  $t2,0($t1) 
	 move  $t1,$t2 
	 bnez  $t1, label6 
	   li  $t1,1 
	   la  $t2,arr
	   li  $t3,4 
	  mul  $t3,$t1,$t3 
	 addi  $t1,$t2,$t3 
	   lw  $t1,0($t1) 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	 addi  $t2,$fp,-8 
	 move  $t1,$t2 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	   sw  $t2,0($t1) 
	 move  $t1,$t2 
	 addi  $t2,$fp,-8 
	   lw  $t1,0($t2) 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	   li  $t1,2 
	   la  $t2,brr
	   li  $t3,4 
	  mul  $t3,$t1,$t3 
	 addi  $t1,$t2,$t3 
	   lw  $t1,0($t1) 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	  seq  $t1,$t2,$t1 
	 bnez  $t1, label7 
	 addi  $t2,$fp,-8 
	   lw  $t1,0($t2) 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	   li  $t1,3 
	   la  $t2,brr
	   li  $t3,4 
	  mul  $t3,$t1,$t3 
	 addi  $t1,$t2,$t3 
	   lw  $t1,0($t1) 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	  seq  $t1,$t2,$t1 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	 addi  $t2,$fp,-8 
	 move  $t1,$t2 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	   sw  $t2,0($t1) 
	 move  $t1,$t2 
	    j  label8 
label7:
	   li  $t1,2 
	   la  $t2,arr
	   li  $t3,4 
	  mul  $t3,$t1,$t3 
	 addi  $t1,$t2,$t3 
	   lw  $t1,0($t1) 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	 addi  $t2,$fp,-8 
	 move  $t1,$t2 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	   sw  $t2,0($t1) 
	 move  $t1,$t2 
label9:
	 addi  $t2,$fp,-8 
	   lw  $t1,0($t2) 
	   la  $t2,arr
	   li  $t3,4 
	  mul  $t3,$t1,$t3 
	 addi  $t1,$t2,$t3 
	   lw  $t1,0($t1) 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	 addi  $t2,$fp,-12 
	   lw  $t1,0($t2) 
	   la  $t2,brr
	   li  $t3,4 
	  mul  $t3,$t1,$t3 
	 addi  $t1,$t2,$t3 
	   lw  $t1,0($t1) 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	  seq  $t1,$t2,$t1 
	 bnez  $t1, label10 
	   li  $t1,1 
	 bnez  $t1, label11 
	 addi  $t2,$fp,-8 
	   lw  $t1,0($t2) 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	 addi  $t2,$fp,-8 
	 move  $t1,$t2 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	   sw  $t2,0($t1) 
	 move  $t1,$t2 
label11:
	    j  label9 
label10:
	 addi  $t2,$fp,-8 
	   lw  $t1,0($t2) 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	 addi  $t2,$fp,-12 
	 move  $t1,$t2 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	   sw  $t2,0($t1) 
	 move  $t1,$t2 
label8:
	    j  label5 
label6:
	   la  $t1,arr
	   lw  $t1,0($t2) 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	   li  $t1,45 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	 addi  $sp,$sp,-4 
	   sw  $fp,0($sp) 
	 move  $fp,$sp 
	jal	func
	 addi  $sp,$sp,8 
	 addi  $sp,$sp,-4 
	   sw  $t1,0($sp) 
	 addi  $t2,$fp,0 
	 move  $t1,$t2 
	   lw  $t2,0($sp) 
	 addi  $sp,$sp,4 
	   sw  $t2,0($t1) 
	 move  $t1,$t2 
	 addi  $sp,$fp,-4 
	   lw  $ra,0($sp) 
	 addi  $sp,$sp,4 
	   lw  $fp,0($sp) 
	 addi  $sp,$sp,4 
	jr $ra
