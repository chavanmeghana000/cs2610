.section .data

.global ans # need to declare as a global variable
ans: .space 40
.section .text
.global decrypt # need to declare as a global variable

decrypt:
# perform decryption over the string cipher_text

la t0, ans
la t1, cipher_text

la t2, desub

li t3, 0
li t6, 'a'
decipher:
    add t1, t1,t3
    add t0, t0, t3
    lb t4, 0(t1)
    sub t4, t4, t6
    add t2, t2, t4
    lb t4, 0(t2)
    sb t4, 0(t0)
    la t2, desub
    sub t1, t1, t3
    sub t0, t0, t3
    addi t3, t3, 1
    li t5, 34
    beq t3, t5, done
    j decipher

done:
ret