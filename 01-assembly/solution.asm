;;; solution.asm

%define SYS_EXIT 60
%define SYS_OPEN 2
%define SYS_READ 0
%define SYS_WRITE 1

%define STDIN 0
%define STDOUT 1
%define STDERR 2

%define EXIT_SUCCESS 0
%define EXIT_FAILURE 1

%define O_RDONLY 0

%define BUFFER_SIZE 1024

global _start

;; System calls
;; 
;; - Set `rax` to the system call number you want.
;; - Pass arguments in `rdi`, `rsi`, `rdx`, `r10`, `r8`, `r9`.
;; - Run the `syscall` instruction.
;; - The result is available in `rax`.
;;
;; A list of syscalls is available here:
;; https://filippo.io/linux-syscall-table/
;;
;; Source: https//gitlab.com/x86-psABIs/x86-64-ABI/-/blob/
;; 1ad6252fc69fcb16ce379413ea7e6f79e648398f/x86-64-ABI/kernel.tex#L23

section .text
_start:
    mov rax, SYS_OPEN
    mov rdi, input_file
    mov rsi, O_RDONLY
    syscall

    ;; Check if rax (return value of the syscall) is less than zero.
    ;; Jump to the error handler in that case.
    cmp rax, 0
    jl error_open

    mov [fd], rax

read_input:
    mov rax, SYS_READ
    mov rdi, [fd]
    mov rsi, buffer
    mov rdx, BUFFER_SIZE
    syscall

    ;; If we didn't read any bytes, there is nothing that we can
    ;; compute about. If we read less than 
    cmp rax, 0
    je exit
    jl error_read

    ;; If we read BUFFER_SIZE of input, then there is a chance we
    ;; didn't read the whole input file in one go. Prompt to increase
    ;; the BUFFER_SIZE.
    cmp rax, BUFFER_SIZE
    je error_buffer_size

exit:
    mov rax, SYS_EXIT
    mov rdi, EXIT_SUCCESS
    syscall

error_buffer_size:
    mov rsi, buffer_size_err_msg
    mov rdx, buffer_size_err_msg_len
    jmp error

error_read:
    mov rsi, read_err_msg
    mov rdx, read_err_msg_len
    jmp error

error_write:
    mov rsi, write_err_msg
    mov rdx, write_err_msg_len
    jmp error

error_open:
    mov rsi, open_err_msg
    mov rdx, open_err_msg_len
    jmp error

error_parse:
    mov rsi, parse_err_msg
    mov rdx, parse_err_msg_len
    jmp error

error:
    mov rax, SYS_WRITE
    mov rdi, STDERR
    syscall

    mov rax, SYS_EXIT
    mov rdi, EXIT_FAILURE
    syscall

section .data
;; File descriptor for the file to cat.
fd dw 0
;; Input file to open. Null terminated. I don't want to do argument
;; parsing for now.
input_file db "input", 0
open_err_msg db "Could not open file", 10
open_err_msg_len equ $ - open_err_msg
read_err_msg db "Could not read from file descriptor", 10
read_err_msg_len equ $ - read_err_msg
write_err_msg db "Could not write to file descriptor", 10
write_err_msg_len equ $ - write_err_msg
parse_err_msg db "Could not parse input file contents", 10
parse_err_msg_len equ $ - parse_err_msg
buffer_size_err_msg db "Increase the BUFFER_SIZE", 10
buffer_size_err_msg_len equ $ - buffer_size_err_msg

section .bss
buffer resb BUFFER_SIZE
