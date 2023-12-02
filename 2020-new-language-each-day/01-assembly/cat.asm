;;; cat.asm
;;;
;;; Print the contents of a file on stdout. The filename is hardcoded
;;; because I don't want to learn about argument parsing right now.

%include "linux64.asm"

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
    checked_syscall open_err_msg

    ;; Save the open file descriptor into memory.
    mov [fd], rax

read_write:
    mov rax, SYS_READ
    mov rdi, [fd]
    mov rsi, buffer
    mov rdx, BUFFER_SIZE
    checked_syscall read_err_msg

    ;; If we didn't read any bytes, there is nothing left to
    ;; write. Therefore exit.
    cmp rax, 0
    je _exit

    ;; Write the same number of bytes as we just read.
    mov rdx, rax
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, buffer
    checked_syscall write_err_msg

    jmp read_write

_exit:
    exit EXIT_SUCCESS

section .data
;; File descriptor for the file to cat.
fd dw 0
;; Filename to open. Null terminated. I don't want to do argument
;; parsing for now.
filename db "input", 0
open_err_msg db "Could not open file", 10, 0
read_err_msg db "Could not read from file descriptor", 10, 0
write_err_msg db "Could not write to file descriptor", 10, 0

section .bss
buffer resb BUFFER_SIZE
