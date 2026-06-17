.section .text
.global _start

_start:
    la sp, _machine_stack

    call setup_processes

    la t0, mtrap_handler
    csrw mtvec, t0

    # Enable timer interrupt
    li t0, 0x80
    csrw mie, t0

    li t0, 0x8
    csrw mstatus, t0

    # Set mtimecmp = 0x100
    li t1, 0x2004000
    li t0, 0x100
    sd t0, 0(t1)

    mret

# ----------------------------
# Trap Handler
# ----------------------------
.align 4
mtrap_handler:
    addi sp, sp, -256

    # Save registers
    sd ra, 0(sp)
    sd t0, 8(sp)
    sd t1, 16(sp)
    sd t2, 24(sp)
    sd t3, 32(sp)

    call increment_timer
    call switch_processes

    # Restore registers
    ld ra, 0(sp)
    ld t0, 8(sp)
    ld t1, 16(sp)
    ld t2, 24(sp)
    ld t3, 32(sp)

    addi sp, sp, 256
    mret

# ----------------------------
# Timer update
# ----------------------------
increment_timer:
    li t0, 0x2004000
    ld t1, 0(t0)
    addi t1, t1, 0x100
    sd t1, 0(t0)
    ret

.section .bss
.align 16
_machine_stack:
.space 4096