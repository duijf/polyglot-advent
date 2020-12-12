%include "linux64.asm"

%define BUFFER_SIZE 1024

global _start

;;; Syscall arguments: rdi, rsi, rdx, r10, r8, r9.

section .text
_start:
    call open_input
    call read_input

    ;; Test case for parse_ascii_int
    mov rax, test_number
    call parse_ascii_int

    cmp rdi, 1334
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

;;; Parse ASCII characters into an integer until hitting
;;; a non-numeric character.
;;;
;;; Parameters:
;;; `rax` - Start address of the ASCII string.
;;;
;;; Returns:
;;; `rax` - Address one past last ASCII digit.
;;; `rdi` - The parsed integer.
;;; `rsi` - The character the parsing ended on.
;;;
;;; This routine raises an error if it
parse_ascii_int:
    mov rdi, 0                  ; Running total.
    mov rsi, 0                  ; Current char we're parsing.
_parse_ascii_int_loop:
    ;; Read a byte from the `resb` into the `rsi` register (which
    ;; is 64 bits), and zero extend the byte until it fits the
    ;; register.
    movzx rsi, byte [rax]

    ;; If it's less than 48 (`0` in ASCII), we're not parsing digits
    ;; anymore and we're done.
    cmp rsi, 48
    jl _parse_ascii_int_end

    ;; Same if greater than 57 (`9` in ASCII).
    cmp rsi, 57
    jg _parse_ascii_int_end

    ;; Here, we have a valid digit.
    ;;
    ;;  - Subtract 48 to convert ASCII to a numeric digit.
    ;;  - Multiply the running total with 10.
    ;;  - Add the parsed digit to the running total.
    sub rsi, 48
    imul rdi, 10
    add rdi, rsi

    ;; Move our pointer another byte and loop again.
    inc rax
    jmp _parse_ascii_int_loop
_parse_ascii_int_end:
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
    number_array resb BUFFER_SIZE
