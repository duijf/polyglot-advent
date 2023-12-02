#!/usr/bin/env bash

# Build a C file and run it
#
# EXAMPLE
#
#     $ ./run.sh solution.c
#
# ENVIRONMENT
#
# Run this from the shell defined by `shell.nix`. E.g. `nix-shell`

set -eufo pipefail

# The first argument (`$1`) should contain the filename to build.
if [ -z ${1+x} ]; then
    echo "usage: $0 C_FILE"
    exit 1
else
    C_FILE="$1"
    BASENAME="$(basename "$C_FILE" .asm)"
    BIN_FILE="build/$BASENAME"
fi

# Compile
gcc -o "$BIN_FILE" "$C_FILE"

# Run
"$BIN_FILE"
