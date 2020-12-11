%include "linux64.asm"

global _start

section .text
_start:
    mov rax, message
    call print

    mov rax, SYS_EXIT
    mov rdi, EXIT_SUCCESS
    syscall

section .data
message db "Hello, world", 10, 0
