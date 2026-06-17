.data
N:          .word 6789        # Input number
min_sp:     .word 0              # To track lowest sp
max_sp:     .word 0              # To track highest sp

.text
.globl main

main:
    la t0, N
    lw a0, 0(t0)

    # Initialize stack tracking
    mv t1, sp

    la t2, min_sp
    sw t1, 0(t2)

    la t3, max_sp
    sw t1, 0(t3)

    jal ra, sumDigits #call recursive 

    # After return:
    # a0 = result

    # Compute stack usage = max_sp - min_sp
    la t2, min_sp
    lw t2, 0(t2)

    la t3, max_sp
    lw t3, 0(t3)

    sub a1, t3, t2      # stack usage in a1

end:
    li a7, 10
    ecall


sumDigits:
    
    la t0, min_sp #checking min_sp
    lw t1, 0(t0)
    blt sp, t1, update_min
    j skip_min

update_min:
    sw sp, 0(t0)

skip_min:

    
    la t0, max_sp #checking max_sp
    lw t1, 0(t0)
    bgt sp, t1, update_max
    j skip_max

update_max:
    sw sp, 0(t0)

skip_max:

    # Base case: if N < 10 return N
    li t0, 10
    blt a0, t0, base_case

    #stack
    addi sp, sp, -8
    sw ra, 4(sp)
    sw a0, 0(sp)

    # Compute N/10 and N%10
    li t0, 10
    div t1, a0, t0     # t1 = N / 10
    rem t2, a0, t0     # t2 = N % 10

    # Recursive call with N/10
    mv a0, t1
    jal ra, sumDigits

    # Restore original N and ra
    lw t3, 0(sp)       
    lw ra, 4(sp)
    addi sp, sp, 8

    # comupate reminder
    li t0, 10
    rem t2, t3, t0

    # result = remainder + recursive result
    add a0, a0, t2

    jr ra

base_case:
    # return N directly
    jr ra