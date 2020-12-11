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

;; Write bytes to stdout.
;;
;; `rax` - Pointer to the bytes to write to stdout. This routine
;; starts a search at `[rax]` until it finds a NUL byte. It then
;; prints all data until that NUL byte.
print:
    push rax
    mov rbx, 0
;; Loop until finding a NUL byte.
printLoop:
    inc rax
    inc rbx
    ;; Move the lower byte of the value at `[rax]`
    mov cl, [rax]
    cmp cl, 0
    jne printLoop

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    pop rsi
    mov rdx, rbx
    syscall
    ret
