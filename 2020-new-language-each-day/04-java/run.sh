#!/usr/bin/env bash

# Run a single Java file as an executable.
#
# EXAMPLE
#
#     $ nix-shell
#     $ ./run.sh solution.java
#
# ENVIRONMENT
#
# Run this from the shell defined by `shell.nix`. E.g. `nix-shell`.
# (Or install the development tools in some other way).

set -eufo pipefail

# The first argument (`$1`) should contain the filename of the assembly
# file to build.
if [ -z ${1+x} ]; then
    echo "usage: $0 JAVA_FILE"
    exit 1
else
    JAVA_FILE="$1"
    BASENAME="$(basename "$JAVA_FILE" .java)"
fi

# Run it.
java "$JAVA_FILE"
