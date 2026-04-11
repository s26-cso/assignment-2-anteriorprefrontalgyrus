.cstring
format_str: .asciz "%d "
newline_str: .asciz "\n"

.text
.globl _main

_main:
	pushq %rbp
	movq %rsp, %rbp
	subq $32, %rsp

	cmpl $2, %edi
	jl L_end

	movq %rsi, -8(%rbp)
	decl %edi
	movl %edi, -20(%rbp)

	movslq %edi, %rdi
	imulq $12, %rdi
	call _malloc
	movq %rax, -16(%rbp)

	movl $0, -24(%rbp)
L_parse_loop:
	movl -24(%rbp), %eax
	cmpl -20(%rbp), %eax
	jge L_parse_done

	movq -8(%rbp), %rsi
	movl %eax, %ecx
	incl %ecx
	movslq %ecx, %rcx
	movq (%rsi, %rcx, 8), %rdi
	
	call _atoi

	movl -24(%rbp), %ecx
	movslq %ecx, %rcx
	movq -16(%rbp), %r8

	movl %eax, (%r8, %rcx, 4)

	movl -20(%rbp), %edx
	movslq %edx, %rdx
	leaq (%r8, %rdx, 4), %r9
	
	movl $-1, (%r9, %rcx, 4)

	incl -24(%rbp)
	jmp L_parse_loop
L_parse_done:

	movq -16(%rbp), %r8
	movl -20(%rbp), %r11d
	movslq %r11d, %rdx

	leaq (%r8, %rdx, 4), %r9
	leaq (%r9, %rdx, 4), %r10

	xorl %eax, %eax
	xorl %ecx, %ecx

L_nge_loop:
	cmpl %r11d, %ecx
	jge L_nge_done

	movslq %ecx, %rdi
	movl (%r8, %rdi, 4), %edx

L_nge_inner:
	cmpl $0, %eax
	je L_nge_push

	movl %eax, %esi
	decl %esi
	movslq %esi, %rsi
	movl (%r10, %rsi, 4), %edi

	movslq %edi, %rdi
	movl (%r8, %rdi, 4), %esi

	cmpl %edx, %esi
	jge L_nge_push

	movl %ecx, (%r9, %rdi, 4)
	
	decl %eax
	jmp L_nge_inner

L_nge_push:
	movslq %eax, %rsi
	movl %ecx, (%r10, %rsi, 4) 
	incl %eax
	
	incl %ecx
	jmp L_nge_loop
L_nge_done:

	movl $0, -24(%rbp)
L_print_loop:
	movl -24(%rbp), %eax
	cmpl -20(%rbp), %eax
	jge L_print_done

	movslq %eax, %rcx
	movq -16(%rbp), %r8
	movl -20(%rbp), %edx
	movslq %edx, %rdx
	leaq (%r8, %rdx, 4), %r9

	movl (%r9, %rcx, 4), %esi
	leaq format_str(%rip), %rdi
	xorl %eax, %eax
	call _printf

	incl -24(%rbp)
	jmp L_print_loop
L_print_done:

	leaq newline_str(%rip), %rdi
	xorl %eax, %eax
	call _printf

	movq -16(%rbp), %rdi
	call _free

L_end:
	xorl %eax, %eax
	leave
	ret
