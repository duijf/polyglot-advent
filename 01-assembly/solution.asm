%include "linux64.asm"

%define BUFFER_SIZE 1024

global _start

;;; Syscall arguments: rdi, rsi, rdx, r10, r8, r9.

section .text
_start:
    call open_input
    call read_input

    exit EXIT_SUCCESS

;;; Open the `input` file and save the file descriptor into the
;;; `fd` address.
open_input:
    mov rax, SYS_OPEN
    mov rdi, input_file
    mov rsi, O_RDONLY

    checked_syscall open_err_msg

    mov [fd], rax
    ret

;;; Read from `fd` into `input_buffer`. Exit with an error when there
;;; are more bytes in `fd` than available in `input_buffer`.
read_input:
    mov rax, SYS_READ
    mov rdi, [fd]
    mov rsi, input_buffer
    mov rdx, BUFFER_SIZE

    checked_syscall read_err_msg

    ;; Raise an error if we read the full buffer.
    cmp rax, BUFFER_SIZE
    jge _read_input_error
    ret
_read_input_error:
    mov rax, buffer_size_err_msg
    call error

section .data
    ;; Filename to read the input from.
    input_file db "input", 0

    ;; File descriptor of the open
    fd dw 0

    ;; Error messages for the different problems we can encounter.
    open_err_msg db "Could not open file", 10, 0
    read_err_msg db "Could not read from file descriptor", 10, 0
    write_err_msg db "Could not write to file descriptor", 10, 0
    parse_err_msg db "Could not parse input file contents", 10, 0
    buffer_size_err_msg db "Increase the BUFFER_SIZE", 10, 0

section .bss
    input_buffer resb BUFFER_SIZE
    number_array resb BUFFER_SIZE
