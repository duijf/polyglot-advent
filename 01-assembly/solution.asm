;;; solution.asm

%include "linux64.asm"

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

;; Parse `buffer` into `parsed_numbers`.
;;
;; `buffer` contains ASCII data, which means that the digits 0 to 9
;; have the following byte values:
;;
;; dec char      dec char
;; 48  0         53  5
;; 49  1         54  6
;; 50  2         55  7
;; 51  3         56  8
;; 52  4         57  9
;;
;; Loop over `buffer`, read a character at a time. Interpret the bytes
;; as ASCII and add them to the running total.
;;
;; Move the pointer in `parsed_numbers` by one if we find a newline.
;;
;; Stop parsing if we hit a NUL character. We're at the end of the file.
parse_input:
_init:
    ;; `rdi` contains the index in `buffer`.
    mov rdi, buffer

    ;; `rsi` contains the current character that we're parsing.
    mov rsi, 0

    ;; `rdx` contains the intermediate parsed result. Initialize it to 0.
    mov rdx, 0

    ;; `r10` contains the index into `parsed_numbers`
    mov r10, parsed_numbers

    jmp _loop
_next:
    ;; Copy the parsed number into `parsed_numbers`.
    mov [r10], rdx

    ;; Reset the intermediate result.
    mov rdx, 0

    ;; Skip the current character (it's a newline).
    inc rdi

    ;; Increment the index into `parsed_numbers`
    inc r10
_loop:
    ;; `rsi` contains the current byte to be parsed. Read it from the buffer.
    ;; There appears to be a difference between "sign extension" and "zero
    ;; extension". Not sure what the difference is. Let's try zero extension,
    ;; as we're dealing with unsigned values here.
    ;;
    ;; More: https://stackoverflow.com/questions/20727379/

    movzx rsi, byte [rdi]

    ;; Check for the zero byte. If we get here, we're done parsing.
    cmp rsi, 0
    je _after

    ;; Newline character.
    cmp rsi, 10
    je _next

    ;; Start of the ASCII number range
    cmp rsi, 48
    jl error_parse

    ;; End of the ASCII number range (exclusive)
    cmp rsi, 58
    jge error_parse

    ;; Once we get here, we have a valid ASCII character that we need to parse.
    ;; Multiply the current intermediate result by 10, convert `rsi` to a decimal
    ;; value and add to the intermediate result.
    imul rdx, 10
    sub rsi, 48
    add rdx, rsi

    ;; Increment the index into the buffer we're parsing.
    inc rdi

    jmp _loop

_after:
    jmp exit

calc:


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
parsed_numbers resb BUFFER_SIZE
