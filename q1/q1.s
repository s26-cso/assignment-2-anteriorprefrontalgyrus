.text

	.globl _make_node
	.globl _insert
	.globl _get
	.globl _getAtMost

	.set NODE_VAL, 0
	.set NODE_LEFT, 8
	.set NODE_RIGHT, 16
	.set NODE_SIZE, 24

_make_node:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp

	movl %edi, -4(%rbp)
	movl $NODE_SIZE, %edi
	call _malloc

	testq %rax, %rax
	jz L_make_node_done

	movl -4(%rbp), %ecx
	movl %ecx, NODE_VAL(%rax)
	movq $0, NODE_LEFT(%rax)
	movq $0, NODE_RIGHT(%rax)

L_make_node_done:
	leave
	ret

_insert:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp

	testq %rdi, %rdi
	jnz L_insert_not_null

	movl %esi, %edi
	call _make_node
	jmp L_insert_done

L_insert_not_null:
	movq %rdi, -8(%rbp)
	movl %esi, -12(%rbp)

	movl NODE_VAL(%rdi), %edx
	cmpl %edx, %esi
	je L_insert_done_root
	jl L_insert_left

	movq NODE_RIGHT(%rdi), %rdi
	movl -12(%rbp), %esi
	call _insert
	movq -8(%rbp), %rcx
	movq %rax, NODE_RIGHT(%rcx)
	jmp L_insert_done_root

L_insert_left:
	movq NODE_LEFT(%rdi), %rdi
	movl -12(%rbp), %esi
	call _insert
	movq -8(%rbp), %rcx
	movq %rax, NODE_LEFT(%rcx)

L_insert_done_root:
	movq -8(%rbp), %rax

L_insert_done:
	leave
	ret

_get:
	pushq %rbp
	movq %rsp, %rbp
	movq %rdi, %rax

L_get_loop:
	testq %rax, %rax
	jz L_get_done

	movl NODE_VAL(%rax), %edx
	cmpl %edx, %esi
	je L_get_done
	jl L_get_left

	movq NODE_RIGHT(%rax), %rax
	jmp L_get_loop

L_get_left:
	movq NODE_LEFT(%rax), %rax
	jmp L_get_loop

L_get_done:
	leave
	ret

_getAtMost:
	pushq %rbp
	movq %rsp, %rbp

	movl $-1, %eax
	movq %rsi, %rcx

L_getAtMost_loop:
	testq %rcx, %rcx
	jz L_getAtMost_done

	movl NODE_VAL(%rcx), %edx
	cmpl %edi, %edx
	je L_getAtMost_exact
	jl L_getAtMost_less

	movq NODE_LEFT(%rcx), %rcx
	jmp L_getAtMost_loop

L_getAtMost_less:
	movl %edx, %eax
	movq NODE_RIGHT(%rcx), %rcx
	jmp L_getAtMost_loop

L_getAtMost_exact:
	movl %edx, %eax

L_getAtMost_done:
	leave
	ret
