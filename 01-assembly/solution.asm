%include "linux64.asm"

%define BUFFER_SIZE 1024

global _start

;;; Syscall arguments: rdi, rsi, rdx, r10, r8, r9.

section .text
_start:
    mov rax, SYS_OPEN
    mov rdi, input_file
    mov rsi, O_RDONLY
    checked_syscall open_err_msg

    exit EXIT_SUCCESS


section .data
    ;; Filename to read the input from.
    input_file db "input", 0

    ;; Error messages for the different problems we can encounter.
    open_err_msg db "Could not open file", 10, 0
    read_err_msg db "Could not read from file descriptor", 10, 0
    write_err_msg db "Could not write to file descriptor", 10, 0
    parse_err_msg db "Could not parse input file contents", 10, 0
    buffer_size_err_msg db "Increase the BUFFER_SIZE", 10, 0

section .bss
    buffer resb BUFFER_SIZE
    parsed_numbers resb BUFFER_SIZE
