import java.io.*;
import java.nio.*;
import java.nio.charset.*;
import java.nio.file.*;
import java.util.*;

class Solution {
    public static void main(String[] args) throws IOException {
        Path input = FileSystems.getDefault().getPath("input");
        List<String> lines = Files.readAllLines(input, StandardCharsets.UTF_8);

        // We're parsing a file of "passport" information. Each passport is
        // separated by a blank line, but passport information can be spread
        // over multiple lines.
        //
        // Here, we're iterating over the original lines and grouping the strings
        // into a new list of 1 string per password entry. There's bound to be
        // smarter ways of doing this.
        List<String> passportLines = new ArrayList<String>();

        String passport = "";
        for (String line : lines) {
            // Case: we hit an empty line and so our password entry is complete.
            if (line.length() == 0) {
                passportLines.add(passport.strip());
                passport = "";
                continue;
            }

            // Case: we have a nonempty line and can add it to our current entry.
            // Also add an extra space to replace the newline. Strings are immutable
            // in Java (nice), so re-assign to the passport var again.
            passport = passport.concat(line + " ");
        }

        long numValid = passportLines
            .stream()
            .map(Passport::parse)
            .filter(Optional::isPresent)
            .count();

        System.out.println(numValid);
    }
}

class Passport {
    String birthYear;
    String issueYear;
    String expirationYear;
    String height;
    String hairColor;
    String eyeColor;
    String passwordId;
    Optional<String> countryId;

    // Lovely verbosity, but let's just deal with it. I'm quite sure we'll need
    // these fields and I bet you there are a couple of edge cases in
    // the input where one field name is part of another.
    public Passport(
        String birthYear,
        String issueYear,
        String expirationYear,
        String height,
        String hairColor,
        String eyeColor,
        String passwordId,
        Optional<String> countryId
    ) {
        this.birthYear = birthYear;
        this.issueYear = issueYear;
        this.expirationYear = expirationYear;
        this.height = height;
        this.hairColor = hairColor;
        this.eyeColor = eyeColor;
        this.passwordId = passwordId;
        this.countryId = countryId;
    }

    // Parse a Passport from a given String, returning Optional.empty() when
    // parsing failed.
    public static Optional<Passport> parse(String toParse) {
        // TODO: Actually parse something.
        return Optional.empty();
    }
}
