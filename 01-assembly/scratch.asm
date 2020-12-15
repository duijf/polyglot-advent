global _start

%include "linux64.asm"

;;; Syscall calling convention.
;;; system call number: `rax`.
;;; arguments: `rdi`, `rsi`, `rdx`, `r10`, `r8`, `r9`.

section .text
_start:
    mov rax, to_parse
    call parse

    exit EXIT_SUCCESS

;;; rax - address of the string to parse.
parse:
    push rax


section .data
    to_parse db "1337", 0
