.data
N:        .word 4

buffer:   .space 21        # supports N <= 10
newline:  .asciz "\n"

.text
.globl main


main:
    # Load N
    la t0, N
    lw t0, 0(t0)

    # a0 = open, a1 = close, a2 = idx
    mv a0, t0
    mv a1, t0
    li a2, 0

    jal ra, printParens

end:
    li a7, 10
    ecall

printParens:

    # Save stack frame
    addi sp, sp, -16
    sw ra, 12(sp)
    sw a0, 8(sp)
    sw a1, 4(sp)
    sw a2, 0(sp)

    # Base case
    beq a0, zero, check_close
    j recurse_part

check_close:
    beq a1, zero, print_string
    j recurse_part
 
 print_string:
    # null terminate buffer
    la t0, buffer
    add t0, t0, a2
    sb zero, 0(t0)

    # write buffer
    li a0, 1
    la a1, buffer
    lw a2, 0(sp)        # idx
    li a7, 64
    ecall

    # print newline
    li a0, 1
    la a1, newline
    li a2, 1
    li a7, 64
    ecall

    j restore_return

recurse_part:

    # Restore original values for checks
    lw t1, 8(sp)   # open
    lw t2, 4(sp)   # close
    lw t3, 0(sp)   # idx

    # if (open > 0) 
    ble t1, zero, skip_open

    # buffer[idx] = '('
    la t0, buffer
    add t0, t0, t3
    li t4, '('
    sb t4, 0(t0)

    # call with (open-1, close, idx+1)
    addi a0, t1, -1
    mv a1, t2
    addi a2, t3, 1
    jal ra, printParens

skip_open:

    #  if (close > open) 
    lw t1, 8(sp)   # open
    lw t2, 4(sp)   # close
    lw t3, 0(sp)   # idx

    ble t2, t1, restore_return

    # buffer[idx] = ')'
    la t0, buffer
    add t0, t0, t3
    li t4, ')'
    sb t4, 0(t0)

    # call with (open, close-1, idx+1)
    mv a0, t1
    addi a1, t2, -1
    addi a2, t3, 1
    jal ra, printParens

restore_return:
    lw ra, 12(sp)
    lw a0, 8(sp)
    lw a1, 4(sp)
    lw a2, 0(sp)
    addi sp, sp, 16
    jr ra