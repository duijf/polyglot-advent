;;; cat.asm
;;;
;;; Print the contents of a file on stdout. The filename is hardcoded
;;; because I don't want to learn about argument parsing right now.

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

section .text
_start:
    ;; Short intro to system calls.
    ;;
    ;; On the 64 bit architecture we're using, the `syscall`
    ;; instrucion hands over control to the kernel. The kernel
    ;; reads the value of the `rax` register. This register
    ;; contains the syscall number to execute.
    ;;
    ;; A list of syscalls is available here:
    ;; https://filippo.io/linux-syscall-table/
    ;;
    ;; Arguments are passed via registers (never via the stack).
    ;; Kernel arguments are passed via these registers in order:
    ;; rdi, rsi, rdx, r10, r8, r9.
    ;;
    ;; The value of the `rax` register will contain `-errno`.
    ;;
    ;; Source: https//gitlab.com/x86-psABIs/x86-64-ABI/-/blob/
    ;; 1ad6252fc69fcb16ce379413ea7e6f79e648398f/x86-64-ABI/kernel.tex#L23
    mov rax, SYS_OPEN
    mov rdi, filename
    mov rsi, O_RDONLY
    syscall

    ;; Check if rax (return value of the syscall) is less than zero.
    ;; Jump to the error handler in that case.
    cmp rax, 0
    jl error_open

    ;; Save the open file descriptor into memory.
    mov [fd], rax

read_write:
    mov rax, SYS_READ
    mov rdi, [fd]
    mov rsi, buffer
    mov rdx, BUFFER_SIZE
    syscall

    ;; If we didn't read any bytes, there is nothing left to
    ;; write. Therefore exit.
    cmp rax, 0
    je exit
    jl error_read

    ;; Write the same number of bytes as we just read.
    mov rdx, rax
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, buffer
    syscall

    cmp rax, 0
    jl error_write

    jmp read_write

exit:
    mov rax, SYS_EXIT
    mov rdi, EXIT_SUCCESS
    syscall

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
;; Filename to open. Null terminated. I don't want to do argument
;; parsing for now.
filename db "input", 0
open_err_msg db "Could not open file", 10
open_err_msg_len equ $ - open_err_msg
read_err_msg db "Could not read from file descriptor", 10
read_err_msg_len equ $ - read_err_msg
write_err_msg db "Could not write to file descriptor", 10
write_err_msg_len equ $ - write_err_msg

section .bss
buffer resb BUFFER_SIZE
