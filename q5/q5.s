.section __TEXT,__cstring
default_file: .asciz "input.txt"
mode:         .asciz "r"
yes_str:      .asciz "Yes\n"
no_str:       .asciz "No\n"
err_str:      .asciz "Error opening file\n"

	.text
	.globl _main

_main:
	pushq %rbp
	movq %rsp, %rbp
	subq $48, %rsp              

	movq $0, -8(%rbp)           
	movl $1, -32(%rbp)          

	cmpl $2, %edi               
	jl L_use_default
	movq 8(%rsi), %rdi          
	jmp L_do_open

L_use_default:
	leaq default_file(%rip), %rdi 

L_do_open:
	leaq mode(%rip), %rsi
	call _fopen
	testq %rax, %rax
	jz L_err
	movq %rax, -8(%rbp)         

	movq -8(%rbp), %rdi
	xorq %rsi, %rsi
	movl $2, %edx               
	call _fseek

	movq -8(%rbp), %rdi
	call _ftell
	movq %rax, -24(%rbp)        

	testq %rax, %rax
	jz L_yes_exit

	decq -24(%rbp)              
	movq -8(%rbp), %rdi
	movq -24(%rbp), %rsi
	movl $0, %edx               
	call _fseek
	movq -8(%rbp), %rdi
	call _fgetc
	cmpl $10, %eax              
	jne L_init_loop
	decq -24(%rbp)              

L_init_loop:
	movq $0, -16(%rbp)          

L_loop:
	movq -16(%rbp), %rcx        
	movq -24(%rbp), %rdx        
	cmpq %rdx, %rcx
	jge L_yes_exit              

	# Read Left
	movq -8(%rbp), %rdi
	movq -16(%rbp), %rsi
	movl $0, %edx
	call _fseek
	movq -8(%rbp), %rdi
	call _fgetc
	movl %eax, -28(%rbp)        

	# Read Right
	movq -8(%rbp), %rdi
	movq -24(%rbp), %rsi
	movl $0, %edx
	call _fseek
	movq -8(%rbp), %rdi
	call _fgetc                 

	# Compare
	movl -28(%rbp), %ecx        
	cmpl %eax, %ecx
	jne L_no_exit               

	incq -16(%rbp)
	decq -24(%rbp)
	jmp L_loop

L_yes_exit:
	leaq yes_str(%rip), %rdi
	xorl %eax, %eax
	call _printf
	movl $0, -32(%rbp)          
	jmp L_cleanup

L_no_exit:
	leaq no_str(%rip), %rdi
	xorl %eax, %eax
	call _printf
	movl $1, -32(%rbp)          
	jmp L_cleanup

L_err:
	leaq err_str(%rip), %rdi
	xorl %eax, %eax
	call _printf

L_cleanup:
	movq -8(%rbp), %rdi
	testq %rdi, %rdi            
	jz L_finish
	call _fclose

L_finish:
	movl -32(%rbp), %eax        
	leave
	ret
