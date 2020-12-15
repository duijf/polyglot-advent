## Debugging

By default, you don't see where segfaults are coming from in these files.
You can find out using `gdb`:

```
$ ./run.sh solution.asm
$ gdb ./build/solution
(gdb) run
Starting program: /home/duijf/repos/duijf/polyglot-advent/01-assembly/build/solution

Program received signal SIGSEGV, Segmentation fault.
_next () at solution.asm:110
110         movzx rsi, byte [rdi]
```

## Cheatsheet

### Linux calling conventions

 - **Syscall number:** `rax`.
 - **Arguments**: `rdi`, `rsi`, `rdx`, `r10`, `r8`, `r9`.
