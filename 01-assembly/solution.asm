%include "linux64.asm"

%define BUFFER_SIZE 1024
%define MAX_PARSED_NUMBERS 256

global _start

;;; Syscall arguments: rdi, rsi, rdx, r10, r8, r9.

section .text
_start:
    call open_input
    call read_input

    ;; Test case for parse_numbers
    mov rax, test_number
    call parse_numbers

    mov [total_parsed_numbers], rax

    cmp qword [number_array], 2008
    jne _parse_fail

    cmp qword [number_array+8], 1529
    jne _parse_fail

    cmp qword [number_array+16], 1594
    jne _parse_fail

    exit EXIT_SUCCESS

_parse_fail:
    mov rax, parse_invalid
    call error

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

;;; Parse the input string of ASCII characters into an array of 64 bit
;;; integers.
;;;
;;; Assumes numbers are separated by newlines.
;;; Stops parsing after reading a NUL byte.
;;;
;;; Exits with an error if there are more numbers to parse than
;;; MAX_PARSED_NUMBERS.
parse_numbers:
    mov r8, input_buffer        ; Read pointer.
    mov r9, number_array        ; Write pointer.
    mov r10, 0                  ; Running total.
    mov r11, 0                  ; Amount of parsed numbers.
_parse_numbers_loop:
    ;; Read a byte of the string. Zero extend the bytes. (We want
    ;; an unsigned number).
    movzx rsi, byte [r8]

    ;; Check if we're at the end of the string.
    cmp rsi, 0
    je _parse_numbers_end

    ;; Check if we're on a newline.
    cmp rsi, 10
    je _parse_numbers_next

    ;; We have anohter digit. `current_total *= 10`.
    imul r10, 10

    ;; Parse character and add it to our total. Assume no incorrect
    ;; input.
    sub rsi, 48
    add r10, rsi

    inc r8                      ; Advance read pointer
    jmp _parse_numbers_loop
_parse_numbers_next:
    mov [r9], r10               ; Write parse result of this round to array.
    mov r10, 0                  ; Reset running total.
    inc r11                     ; Inrement amount of parsed numbers.

    inc r8                      ; Advance read pointer.
    add r9, 8                   ; Advance write pointer (elems are 8 bytes long).
    jmp _parse_numbers_loop
_parse_numbers_end:
    mov rax, r11
    ret

section .data
    ;; Filename to read the input from.
    input_file db "input", 0

    ;; File descriptor of the open
    fd dw 0

    test_number db "1334", 10, 0
    parse_invalid db "Parsed number was incorrect", 10, 0

    ;; Error messages for the different problems we can encounter.
    open_err_msg db "Could not open file", 10, 0
    read_err_msg db "Could not read from file descriptor", 10, 0
    write_err_msg db "Could not write to file descriptor", 10, 0
    parse_err_msg db "Could not parse input file contents", 10, 0
    buffer_size_err_msg db "Increase the BUFFER_SIZE", 10, 0

section .bss
    input_buffer resb BUFFER_SIZE
    ;; Allocate in chunks of 8 bytes, because we're parsing these numbers
    ;; into 64 bit integers.
    number_array resq MAX_PARSED_NUMBERS

    ;; Total amount of parsed numbers.
    total_parsed_numbers resq 0
