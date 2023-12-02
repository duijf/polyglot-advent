#!/usr/bin/env bash

# Provision a PostgreSQL cluster and run a single SQL file.
#
# EXAMPLE
#
#     $ nix-shell
#     $ ./run.sh solution.sql
#
# ENVIRONMENT
#
# Run this from the shell defined by `shell.nix`. E.g. `nix-shell`.
# (Or install the development tools in some other way).

set -eufo pipefail

# The first argument (`$1`) should contain the filename of the assembly
# file to build.
if [ -z ${1+x} ]; then
    echo "usage: $0 SQL_FILE"
    exit 1
else
    SQL_FILE="$1"
fi

POSTGRES_DATA="$(realpath db)"

# Clean up results from the previous run.
rm -rf "$POSTGRES_DATA"

# Create a new PostgreSQL cluster and make it listen on a Unix socket.
initdb $POSTGRES_DATA --locale en_US.UTF-8
cat >> $POSTGRES_DATA/postgresql.conf <<EOF
listen_addresses = ''
unix_socket_directories = '$POSTGRES_DATA'
EOF

# Copy the input file to the Postgres data directory so our solution
# can actually read it with pg_read_file.
cp input "$POSTGRES_DATA"

# Start the cluster in the background and remember the PID so we can
# kill the server later.
echo "Starting Postgres.."
postgres -D "$POSTGRES_DATA" &
POSTGRES_PID="$!"

sleep 2

# Run our solution. Always exit with `true` so we can actually kill
# the server without exiting because of `set -e`
export PGHOST="$POSTGRES_DATA"
export PGDATABASE="postgres"
psql --file="$SQL_FILE" || true

# Send a stop signal and wait for the server to exit.
kill "$POSTGRES_PID"
wait "$POSTGRES_PID"
