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

## Getting output

I kind of cheated here. Instead of writing output to the screen, I
inspected the value of the register containing the result with `gdb`.

If I feel like it, I'll clean this up and write my own routine for
printing integers sometime.

Meanwhile, this is how you can view the results:

```
# NOTE: Ensure you're in the Nix shell or have installed the dependencies
# in some other way.

# Build solution.asm and run it:
$ ./run.sh solution.asm

# You see it returns no output. Let's see how we can change that.
$ gdb build/solution

# Add a breakpoint before the exit call and run the program.
(gdb) break solution.asm:18
(gdb) run

# Now inspect the value of the `rax` register to see the result.
(gdb) info registers
```
