.data
arr: .word 5,2,9,1,3,6
size: .word 6

.text
.global main

main:
la t0,arr
li t2,0 #i

loop: 
la t1,size
lw t1,0(t1)
addi t1, t1, -1
beq t1,t2,end
sub t4,t1,t2
li t3,0 #j


in_loop:
beq t3,t4,next
slli s1,t3,2
add s1,t0,s1
lw t6,0(s1)

addi t1,t3,1
slli t5,t1,2
add t5,t0,t5
lw t1,0(t5)
bgt t6,t1,swap
addi t3,t3,1
j in_loop

next:
addi t2,t2,1
j loop

swap:
addi t3,t3,1
sw t6,0(t5)
sw t1,0(s1)
j in_loop

end: 
li a7,93
ecall


