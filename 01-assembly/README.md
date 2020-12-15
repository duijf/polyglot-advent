# Challenge 1

This is a solution to problem one using the NASM assembler.

Requirements to run this:

 - NASM
 - Linux
 - A `x86_64` CPU

This directory contains multiple experiments that I made while
teaching myself enough assembly to complete the final excersise.

## Files

 - `run.sh` - Compile an `.asm` file to a Linux executable and run it.
 - `solution.asm` - Final solution for the challenge.
 - `input` - Input for the challenge.

Experiments and scratch stuff:

 - `linux64.asm` - Utilities for syscalls, printing and exiting
   properly.
 - `hello.asm` - Hello world in NASM.
 - `cat.asm` - File IO demo. A worse of clone of the cat UNIX program.

## Things I learned

 - How syscalls are made / Linux x64 calling conventions.
 - Calling conventions. (Although I didn't adhere to anything specific
   in my code, except when I made syscalls).
 - Two's complement representation of signed numbers.
 - How to express jumps, loops, conditionals and function calls.
 - How memory addressing works.
 - Debugging with GDB.
 - How to not lose your mind in the face of segfaults.

## Resources used

I first followed [this tutorial](https://cs.lmu.edu/~ray/notes/nasmtutorial/)
to get myself going. That taught me how to compile and run code and
how to do syscalls.

I then tried to get going, but found I needed some more principled
knowledge (instead of trying to Google myself out of problems, but not
even knowing the right keywords).

I watched some videos from [this
series](https://www.youtube.com/watch?v=VQAKkuLL31g&list=PLetF-YjXm-sCH6FrTz4AQhfH6INDQvQSn)
to get a better feel for how people write assembly. I could read more
code, but still couldn't produce it myself.

I still needed more background on what is actually going on under the
hood. The lecture notes of [CS301 at
UAF](https://www.cs.uaf.edu/2012/fall/cs301/) were invaluable for this.

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
