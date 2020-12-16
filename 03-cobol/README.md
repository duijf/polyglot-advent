# Challenge 3 - COBOL

## Impressions

At first, I was hating myself for choosing COBOL, but this turned out quite
fine actually. I had none of the segmentation fault problems that I
encountered with assembly.

The language was a bit quirky and verbose, but actually has some nice
utilities for processing files, which surprised me.

It's quite curious to see how much features are put into the language itself,
with regard to processing files and such. In more modern times, you would
expect these things to be in the standard library instead.

It's quite a curious language. Although I wouldn't want this to be my day
to day, it's not all that bad as people make it out to be. (As long as you
don't write huge programs in it. The lack of local variables and type
checking will get old quite fast I imagine.)

## Running

```
# Load development tools.
$ nix-shell

$ ./run.sh solution-3a.cbl
$ ./run.sh solution-3b.cbl
```

## Resources used

I first tried searching for written tutorials or courses, but couldn't find
anything with the right focus (a lot of stuff assumed that you wanted to run
COBOL on an IBM mainframe of some sort).

This is the stuff that did work for me:

 - The [GNU Cobol website][cobol-website]. This was hard to find. For some
   reason, the [SourceForge page][cobol-sourceforge] is ranked higher in
   Google results while containing less useful information.
 - The [GNU Cobol's programmers manual][cobol-manual]. This is too dense
   for learning, but seems like a nice exhaustive reference.
 - This [Youtube video][cobol-youtube] was a nice intro to actually getting
   started with the language from scratch, learning what features it has
   and seeing lots of examples quickly.

[cobol-website]:https://gnucobol.sourceforge.io/
[cobol-sourceforge]:https://sourceforge.net/projects/gnucobol/
[cobol-manual]:https://gnucobol.sourceforge.io/HTML/gnucobpg.html
[cobol-youtube]:https://www.youtube.com/watch?v=TBs7HXI76yU
