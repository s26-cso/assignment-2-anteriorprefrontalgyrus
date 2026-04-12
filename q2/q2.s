.section .rodata
format_str: .asciz "%d "
newline_str: .asciz "\n"

.text
.globl main

main:
	addi sp, sp, -80
	sd ra, 72(sp)
	sd s0, 64(sp)
	sd s1, 56(sp)
	sd s2, 48(sp)
	sd s3, 40(sp)
	sd s4, 32(sp)
	sd s5, 24(sp)
	sd s6, 16(sp)
	sd s7, 8(sp)
	sd s8, 0(sp)

	addi s0, a0, 0
	addi s1, a1, 0

	addi t0, x0, 2
	blt s0, t0, L_end

	addi s2, s0, -1

	slli t0, s2, 3
	slli t1, s2, 2
	add a0, t0, t1
	jal ra, malloc
	addi s3, a0, 0

	addi s4, x0, 0
L_parse_loop:
	bge s4, s2, L_parse_done

	addi t0, s4, 1
	slli t0, t0, 3
	add t0, s1, t0
	ld a0, 0(t0)
	jal ra, atoi

	slli t1, s4, 2
	add t2, s3, t1
	sw a0, 0(t2)

	slli t3, s2, 2
	add t4, s3, t3
	add t4, t4, t1
	addi t5, x0, -1
	sw t5, 0(t4)

	addi s4, s4, 1
	jal x0, L_parse_loop
L_parse_done:

	slli t0, s2, 2
	add s5, s3, t0
	add s6, s5, t0

	addi s7, x0, 0
	addi s4, x0, 0

L_nge_loop:
	bge s4, s2, L_nge_done

	slli t1, s4, 2
	add t2, s3, t1
	lw s8, 0(t2)

L_nge_inner:
	beq s7, x0, L_nge_push

	addi t0, s7, -1
	slli t0, t0, 2
	add t0, s6, t0
	lw t1, 0(t0)

	slli t2, t1, 2
	add t2, s3, t2
	lw t3, 0(t2)

	bge t3, s8, L_nge_push

	slli t2, t1, 2
	add t2, s5, t2
	sw s4, 0(t2)

	addi s7, s7, -1
	jal x0, L_nge_inner

L_nge_push:
	slli t0, s7, 2
	add t0, s6, t0
	sw s4, 0(t0)

	addi s7, s7, 1
	addi s4, s4, 1
	jal x0, L_nge_loop
L_nge_done:

	addi s4, x0, 0
L_print_loop:
	bge s4, s2, L_print_done

	slli t0, s4, 2
	add t0, s5, t0
	lw a1, 0(t0)

	lui a0, %hi(format_str)
	addi a0, a0, %lo(format_str)
	jal ra, printf

	addi s4, s4, 1
	jal x0, L_print_loop
L_print_done:

	lui a0, %hi(newline_str)
	addi a0, a0, %lo(newline_str)
	jal ra, printf

	addi a0, s3, 0
	jal ra, free

L_end:
	addi a0, x0, 0
	ld ra, 72(sp)
	ld s0, 64(sp)
	ld s1, 56(sp)
	ld s2, 48(sp)
	ld s3, 40(sp)
	ld s4, 32(sp)
	ld s5, 24(sp)
	ld s6, 16(sp)
	ld s7, 8(sp)
	ld s8, 0(sp)
	addi sp, sp, 80
	jalr x0, ra, 0
	
