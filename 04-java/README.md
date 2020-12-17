# Challenge 4 - Java

## Impressions

 - Optional is a nice idea, but it's execution leaves to be desired. The fact
   that it can only contain a reference type is annoying (which means
   you get `OptionalInt` and friends). Also, you get the choice between writing
   a lot of plumbing / short circuiting code and extracting stuff out of the
   optional context (since Java does not support something like Haskell's `do`
   or Rusts's `?`). Furthermore, a lot of the standard library doesn't
   use it and is free to return `null`. It's definitely better than not having
   it though.
 - Streams are really nice when you find the right incantations. I'd argue the
   code is really more readable than 1000 different for loops that don't specify
   their intent with a name. Sometimes you can't easily fit your logic into the
   streams API. That's fine: write a normal loop in those cases instead.
 - I first wanted to attempt "Parse, don't validate" in Java for this usecase.
   That turned out a little verbose, so I just did the validation with a bunch
   of booleans. In production code, (where there would be actual consumers of the
   `Passport` type), I would probably deal with the boilerplate of data objects
   and constructors because it brings
   on a lot of type safety.

## Running

```
# Get the development tools.
$ nix-shell

$ ./run.sh solution-04.java
```
