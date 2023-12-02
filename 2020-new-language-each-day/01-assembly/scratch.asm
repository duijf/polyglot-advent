global _start

%include "linux64.asm"

;;; Syscall calling convention.
;;; system call number: `rax`.
;;; arguments: `rdi`, `rsi`, `rdx`, `r10`, `r8`, `r9`.

;;; Saved registers
;;; `rsp`, `rbp`, `rbx`, `r12`, `r13`, `r14`, `r15`.

section .text
_start:
    mov rax, to_parse
    call parse

    exit EXIT_SUCCESS

;;; `rax`: address of the string to parse.
parse:
    push r12
    push r13
    mov rdi, 0
    mov r12, rax
_loop:
    movzx r13, byte [r12]

    cmp r13, 0
    je _end

    inc r12
    inc rdi

    jmp _loop
_end:
    pop r13
    pop r12
    ret


section .data
    to_parse db "1337", 0
