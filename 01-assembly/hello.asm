%define SYS_EXIT 60
%define SYS_WRITE 1
%define STDOUT 1
%define EXIT_SUCCESS 0

global _start

section .text
_start:
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, message
    mov rdx, 13
    syscall

    mov rax, SYS_EXIT
    mov rdi, EXIT_SUCCESS
    syscall

section .data
message db "Hello, world", 10
