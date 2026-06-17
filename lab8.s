.section .text
.global main

main:
    li t0, -1
    csrw pmpaddr0, t0
    li t0, 0x1F
    csrw pmpcfg0, t0
    li t0, 0x100
    csrs medeleg, t0
    li t0, 0x1800
    csrc mstatus, t0
    li t0, 0x800
    csrs mstatus, t0
    la t0, supervisor
    csrw stvec, t0
    csrw mepc, t0
    mret

supervisor:
    li s0, 0x8F003000
    li t0, 0x8F004000
    srli t0, t0, 2
    ori t0, t0, 0x01
    sd t0, 0(s0)

    li s1, 0x8F004000
    li t0, 0x8F005000
    srli t0, t0, 2
    ori t0, t0, 0x01
    sd t0, 0(s1)

    li t0, 0x8F007000
    srli t0, t0, 2
    ori t0, t0, 0x01
    sd t0, 24(s1)

    li s2, 0x8F005000
    li t0, 0x8F006000
    srli t0, t0, 2
    ori t0, t0, 0x01
    sd t0, 0(s2)

    li s4, 0x8F007000
    li t0, 0x8F008000
    srli t0, t0, 2
    ori t0, t0, 0x01
    li t1, 960
    add t2, s4, t1
    sd t0, 0(t2)

    li s3, 0x8F006000
    li t0, 0x8F001000
    srli t0, t0, 2
    ori t0, t0, 0xDB
    sd t0, 0(s3)
    
    li t0, 0x8F002000
    srli t0, t0, 2
    ori t0, t0, 0xD7
    sd t0, 8(s3)

    li s5, 0x8F008000
    li t0, 0x8F001000
    srli t0, t0, 2
    ori t0, t0, 0xCB
    sd t0, 0(s5)

    li t0, 0x8F000000
    li t1, 0x8F003000
    srli t1, t1, 12
    or t0, t0, t1
    la t1, satp_config
    sd t0, 0(t1)

    li t0, 0x100
    csrc sstatus, t0

    la t1, satp_config
    ld t2, 0(t1)
    sfence.vma zero, zero
    csrrw zero, satp, t2
    sfence.vma zero, zero

    li t4, 0
    csrrw zero, sepc, t4
    sret

.balign 4096
user_code:
    la t0, var1
    lw t1, 0(t0)
    la t0, var2
    lw t2, 0(t0)
    la t0, var3
    lw t3, 0(t0)
    la t0, var4
    lw t4, 0(t0)
user_loop:
    j user_loop

.section .data
.balign 4096
var1: .word 1
var2: .word 2
var3: .word 3
var4: .word 4

satp_config: .dword 0
