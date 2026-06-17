.data
A:
 .word 1,2,3
 .word 4,5,6
 .word 7,8,9
B:
 .word 2,2,2
 .word 2,2,2
 .word 2,2,2
C:
 .space 36

.text
.global main

.main
la t0,A
la t1,B
la t2,C
li t3,0 

loop:

li t4,0
lw t5,0(t0)
lw t6,0(t1)
mul t5,t5,t6
add t2,t2,t5
addi t0,t0,4
addi t1,t1,12

