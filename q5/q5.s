.section .rodata
default_file: .asciz "input.txt"
mode:         .asciz "r"
yes_str:      .asciz "Yes\n"
no_str:       .asciz "No\n"
err_str:      .asciz "Error opening file\n"

.text
.globl main

main:
	addi sp, sp, -48
	sd ra, 40(sp)
	sd s0, 32(sp)
	sd s1, 24(sp)
	sd s2, 16(sp)
	sd s3, 8(sp)
	sd s4, 0(sp)

	addi s0, x0, 0
	addi s1, x0, 1

	addi t0, x0, 2
	blt a0, t0, L_use_default
	ld a0, 8(a1)
	jal x0, L_do_open

L_use_default:
	lui a0, %hi(default_file)
	addi a0, a0, %lo(default_file)

L_do_open:
	lui a1, %hi(mode)
	addi a1, a1, %lo(mode)
	jal ra, fopen
	beq a0, x0, L_err
	addi s0, a0, 0

	addi a0, s0, 0
	addi a1, x0, 0
	addi a2, x0, 2
	jal ra, fseek

	addi a0, s0, 0
	jal ra, ftell
	addi s3, a0, 0

	beq s3, x0, L_yes_exit

	addi s3, s3, -1
	addi a0, s0, 0
	addi a1, s3, 0
	addi a2, x0, 0
	jal ra, fseek
	
	addi a0, s0, 0
	jal ra, fgetc
	addi t0, x0, 10
	bne a0, t0, L_init_loop
	addi s3, s3, -1

L_init_loop:
	addi s2, x0, 0

L_loop:
	bge s2, s3, L_yes_exit

	addi a0, s0, 0
	addi a1, s2, 0
	addi a2, x0, 0
	jal ra, fseek
	
	addi a0, s0, 0
	jal ra, fgetc
	addi s4, a0, 0

	addi a0, s0, 0
	addi a1, s3, 0
	addi a2, x0, 0
	jal ra, fseek
	
	addi a0, s0, 0
	jal ra, fgetc

	bne s4, a0, L_no_exit

	addi s2, s2, 1
	addi s3, s3, -1
	jal x0, L_loop

L_yes_exit:
	lui a0, %hi(yes_str)
	addi a0, a0, %lo(yes_str)
	jal ra, printf
	addi s1, x0, 0
	jal x0, L_cleanup

L_no_exit:
	lui a0, %hi(no_str)
	addi a0, a0, %lo(no_str)
	jal ra, printf
	addi s1, x0, 1
	jal x0, L_cleanup

L_err:
	lui a0, %hi(err_str)
	addi a0, a0, %lo(err_str)
	jal ra, printf

L_cleanup:
	beq s0, x0, L_finish
	addi a0, s0, 0
	jal ra, fclose

L_finish:
	addi a0, s1, 0
	ld ra, 40(sp)
	ld s0, 32(sp)
	ld s1, 24(sp)
	ld s2, 16(sp)
	ld s3, 8(sp)
	ld s4, 0(sp)
	addi sp, sp, 48
	jalr x0, ra, 0
	
