# Challenge 6 - PL/pgSQL

PL/pgSQL is a procedural programming language that you can use with
the PostgreSQL database.

This solution uses PL/pgSQL to parse the input file and populate a
database. The answers are computed using SQL.

## Running

```
# Get all development tools.
$ nix-shell

# Compute the results. This bootstraps a Postgres DB in the current
# subdirectory, launches it, and runs the solution.sql file. The
# cluster won't listen on any ports (only a Unix domain socket).
# No global state will be mutated.
$ ./run.sh solution.sql
```
