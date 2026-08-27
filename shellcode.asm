section .text

global main
main:   xor rax, rax
        push rax
        mov rbx, 0x68732f2f6e69622f     
        push rbx
        lea rdi, [rsp]
        push rax
        push rdi
        lea rsi, [rsp]
        lea rdx, [rsi + 8]
        mov rax, 59
        syscall
        mov rdi, 67
        mov rax, 60
        syscall