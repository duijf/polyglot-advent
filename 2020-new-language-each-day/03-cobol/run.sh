#!/usr/bin/env bash

# Build a COBOL file to an executable and run it.
#
# EXAMPLE
#
#     $ ./run.sh hello.cbl
#     Hello, world!
#
# ENVIRONMENT
#
# Run this from the shell defined by `shell.nix`. E.g. `nix-shell`

set -eufo pipefail

# The first argument (`$1`) should contain the filename of the assembly
# file to build.
if [ -z ${1+x} ]; then
    echo "usage: $0 COBOL_FILE"
    exit 1
else
    COBOL_FILE="$1"
    BASENAME="$(basename "$COBOL_FILE" .cbl)"
    BIN_FILE="build/$BASENAME"
fi

echo "Building $COBOL_FILE to $BIN_FILE"

# Build the executable.
# `-x` - Create an executable.
# `-o` - Build to the given output file.
cobc -x -o "$BIN_FILE" "$COBOL_FILE"

# Run it.
"$BIN_FILE"
