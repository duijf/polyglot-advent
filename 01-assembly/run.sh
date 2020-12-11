#!/usr/bin/env bash

# Build an assembly file to a 64 bit ELF executable and run it.
#
# EXAMPLE
# 
#     $ ./run.sh hello.asm
#     Hello, world!
#
# ENVIRONMENT
#
# Run this from the shell defined by `shell.nix`. E.g. `nix-shell`

set -eufo pipefail

# The first argument (`$1`) should contain the filename of the assembly
# file to build.
if [ -z ${1+x} ]; then
    echo "usage: $0 ASM_FILE"
    exit 1
else
    ASM_FILE="$1"
    BASENAME="$(basename "$ASM_FILE" .asm)"
    OBJ_FILE="build/$BASENAME.o"
    BIN_FILE="build/$BASENAME"
fi

echo "Building $ASM_FILE to $BIN_FILE"

# Assemble with Netwide assembler. Build a 64-bit ELF file so
# we can run on Linux.
nasm -felf64 "$ASM_FILE" -o "$OBJ_FILE"

# Pass the object file to the linker so we get a binary that we
# can actually execute.
ld -o "$BIN_FILE" "$OBJ_FILE"

# Run it.
"$BIN_FILE"
