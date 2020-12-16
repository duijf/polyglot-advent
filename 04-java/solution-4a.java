import java.io.*;
import java.nio.*;
import java.nio.charset.*;
import java.nio.file.*;
import java.util.*;
import java.util.stream.*;

class Solution {
    public static void main(String[] args) throws IOException {
        Path input = FileSystems.getDefault().getPath("input");
        var lines = Files.readAllLines(input, StandardCharsets.UTF_8);

        // We're parsing a file of "passport" information. Each passport is
        // separated by a blank line, but passport information can be spread
        // over multiple lines.
        //
        // Here, we're iterating over the original lines and grouping the strings
        // into a new list of 1 string per password entry. There's bound to be
        // smarter ways of doing this.
        var passportLines = new ArrayList<String>();

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

        // Add the final line as well instead of forgetting it because there might
        // not be two newlines after the final line of the file.
        if (passport != "") {
            passportLines.add(passport);
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
        var map = parseMap(toParse);

        var requiredKeys = new String[] {"byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"};
        if (!Util.containsKeys(map, requiredKeys)) {
            return Optional.empty();
        }

        var birthYear = map.get("byr");
        var issueYear = map.get("iyr");
        var expirationYear = map.get("eyr");
        var height = map.get("hgt");
        var hairColor = map.get("hcl");
        var eyeColor = map.get("ecl");
        var passportId = map.get("pid");
        var countryId = Optional.ofNullable(map.get("cid"));

        return Optional.of(new Passport(
            birthYear,
            issueYear,
            expirationYear,
            height,
            hairColor,
            eyeColor,
            passportId,
            countryId
        ));
    }

    // Parse a line like:
    //
    //     iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884 hcl:#cfa07d byr:1929`
    //
    // into a
    //
    //     Map.of("iyr", "2013", "ecl", "amb", ...)
    static HashMap<String, String> parseMap(String toParse) {
        return Stream.of(toParse.split(" "))
            .map(Passport::parseKvp)
            .collect(Collectors.toMap(
                AbstractMap.SimpleEntry::getKey,
                AbstractMap.SimpleEntry::getValue,
                (prev, next) -> next,
                HashMap::new
            ));
    }

    // Parse "iyr:2013" into "iyr".
    static AbstractMap.SimpleEntry<String, String> parseKvp(String toParse) {
        var split = toParse.split(":");
        assert split.length == 2;
        return new AbstractMap.SimpleEntry(split[0], split[1]);
    }
}

class Util {
    public static <K, V> boolean containsKeys(Map<K, V> map, K[] keys) {
        boolean result = true;
        var missing = new ArrayList<K>();
        for (K key : keys) {
            result = result && map.containsKey(key);
            if (!map.containsKey(key)) {
                missing.add(key);
            }
        }
        return result;
    }
}
