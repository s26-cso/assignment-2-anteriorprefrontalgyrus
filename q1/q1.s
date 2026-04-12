.text
.globl make_node
.globl insert
.globl get
.globl getAtMost

# functions as given in problem statement 

make_node:
	addi sp, sp, -16
	sd ra, 8(sp)
	sd s0, 0(sp)
	addi s0, a0, 0
	addi a0, x0, 24
	jal ra, malloc
	beq a0, x0, L_make_node_done
	sw s0, 0(a0)
	sd x0, 8(a0)
	sd x0, 16(a0)
L_make_node_done:
	ld ra, 8(sp)
	ld s0, 0(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

insert:
	addi sp, sp, -32
	sd ra, 24(sp)
	sd s0, 16(sp)
	sd s1, 8(sp)
	bne a0, x0, L_insert_not_null
	addi a0, a1, 0
	jal ra, make_node
	jal x0, L_insert_done
L_insert_not_null:
	addi s0, a0, 0
	addi s1, a1, 0
	lw t0, 0(s0)
	beq t0, s1, L_insert_done_root
	blt s1, t0, L_insert_left
	ld a0, 16(s0)
	addi a1, s1, 0
	jal ra, insert
	sd a0, 16(s0)
	jal x0, L_insert_done_root
L_insert_left:
	ld a0, 8(s0)
	addi a1, s1, 0
	jal ra, insert
	sd a0, 8(s0)
L_insert_done_root:
	addi a0, s0, 0
L_insert_done:
	ld ra, 24(sp)
	ld s0, 16(sp)
	ld s1, 8(sp)
	addi sp, sp, 32
	jalr x0, ra, 0

get:
L_get_loop:
	beq a0, x0, L_get_done
	lw t0, 0(a0)
	beq t0, a1, L_get_done
	blt a1, t0, L_get_left
	ld a0, 16(a0)
	jal x0, L_get_loop
L_get_left:
	ld a0, 8(a0)
	jal x0, L_get_loop
L_get_done:
	jalr x0, ra, 0

getAtMost:
	addi t1, x0, -1
	addi t2, a1, 0
L_getAtMost_loop:
	beq t2, x0, L_getAtMost_done
	lw t0, 0(t2)
	beq t0, a0, L_getAtMost_exact
	blt t0, a0, L_getAtMost_less
	ld t2, 8(t2)
	jal x0, L_getAtMost_loop
L_getAtMost_less:
	addi t1, t0, 0
	ld t2, 16(t2)
	jal x0, L_getAtMost_loop
L_getAtMost_exact:
	addi t1, t0, 0
L_getAtMost_done:
	addi a0, t1, 0
	jalr x0, ra, 0
	
