;;; solution.asm - Advent of Code 2020 challenges 1a and 1b.
;;; Run using run.sh from this directory. Look at the readme
;;; for instructions.

%include "linux64.asm"

%define BUFFER_SIZE 1024
%define MAX_PARSED_NUMBERS 256

global _start

;;; Syscall arguments: rdi, rsi, rdx, r10, r8, r9.

section .text
_start:
    call open_input
    call read_input
    call parse_numbers
    call find_sum

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
    mov [total_parsed_numbers], r11
    ret

;;; Find two numbers within `number_array` that sum to 2020 and multiply
;;; them. We basically want an assembly version of:
;;;
;;; for (int i = 0; i < total_parsed_numbers-2; i++) {
;;;     for (int j = 1; j < total_parsed_numbers-1; j++) {
;;;         for (int k = 1; k < total_parsed_numbers; k++) {
;;;             if (number_array[i] + number_array[j] + number_array[k] == 2020) {
;;;                 return number_array[i] * number_array[j] * number_array[k];
;;;             }
;;;         }
;;;     }
;;; }
find_sum:
    mov r8, number_array             ; Address of first element
    mov r9, 0                        ; Offset of pointer 1
    mov r10, 1                       ; Offset of pointer 2
    mov r11, 2                       ; Offset of pointer 3

    ;; Max loop value of r9
    mov r12, [total_parsed_numbers]
    sub r12, 2

    ;; Max loop value of r10
    mov r13, [total_parsed_numbers]
    sub r13, 1

    ;; Max loop value of r11
    mov r14, [total_parsed_numbers]

    jmp _find_sum_test
_find_sum_loop:
    mov rdi, [number_array+r9*8]
    add rdi, [number_array+r10*8]
    add rdi, [number_array+r11*8]

    cmp rdi, 2020
    je _find_sum_end

    inc r11
_find_sum_test:
    ;; Check if the first pointer is still in bounds. If not,
    ;; we're done with the entire loop.
    cmp r9, r12
    je _find_sum_end

    ;; Check if the second pointer is still in bounds. If not,
    ;; we need to advance the first pointer and reset the second.
    cmp r10, r13
    je _find_sum_next_outer

    ;; Check if the third pointer is still in bounds. if not,
    ;; we need to advance the second pointer and reset the third.
    cmp r11, r14
    je _find_sum_next_inner

    jmp _find_sum_loop
_find_sum_next_outer:
    ;; Move the outer loop forward by incrementing the first pointer
    ;; and resetting r10. Then fall through the next bit of code to
    ;; eventually jump back into testing and the loop itself.
    inc r9
    mov r10, r9
_find_sum_next_inner:
    ;; Reset the inner loops by incrementing the right offsets.
    inc r10
    mov r11, r10
    inc r11
    jmp _find_sum_test
_find_sum_end:
    ;; Return the result in the rax register.
    mov rax, [number_array+r9*8]
    imul rax, [number_array+r10*8]
    imul rax, [number_array+r11*8]
    ret

section .data
    ;; Filename to read the input from.
    input_file db "input", 0

    ;; File descriptor of the open
    fd dw 0

    parse_invalid db "Parsed number was incorrect", 10, 0

    ;; Error messages for the different problems we can encounter.
    open_err_msg db "Could not open file", 10, 0
    read_err_msg db "Could not read from file descriptor", 10, 0
    buffer_size_err_msg db "Increase the BUFFER_SIZE", 10, 0

section .bss
    input_buffer resb BUFFER_SIZE
    ;; Allocate in chunks of 8 bytes, because we're parsing these numbers
    ;; into 64 bit integers.
    number_array resq MAX_PARSED_NUMBERS

    ;; Total amount of parsed numbers.
    total_parsed_numbers resq 0
