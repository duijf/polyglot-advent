          global      _start

          section     .text
_start:   mov         rax, 1          ; System call for write.
          mov         rdi, 1          ; File handle 1: stdout.
          mov         rsi, message    ; Address of string to output.
          mov         rdx, 13         ; Number of bytes.
          syscall                     ; Invoke OS.
          mov         rax, 60         ; System call for exit.
          xor         rdi, rdi        ; Exit code 0.
          syscall                     ; Invoke OS.

          section     .data
message:  db          "Hello, world", 10 ; Note the newline at the end
