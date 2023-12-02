%include "linux64.asm"

global _start

section .text
_start:
    mov rax, message
    call print

    exit EXIT_SUCCESS

section .data
message db "Hello, world", 10, 0
