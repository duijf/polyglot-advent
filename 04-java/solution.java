import java.io.*;
import java.nio.*;
import java.nio.charset.*;
import java.nio.file.*;
import java.util.*;
import java.util.function.*;
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
            .map(Passport::validate)
            .filter(valid -> valid)
            .count();

        System.out.println(numValid);
    }
}

class Passport {
    // Parse validate a Passport String, returning `false` if any of the validation
    // rules failed.
    //
    // Normally, I'd go for the "Parse, don't validate" [1] approach by parsing into
    // and returning a structured data object. However, that's quite verbose in Java
    // and we won't actually use the parsed object here. Therefore, just parse
    // everything into a map and do the validation right away.
    //
    // [1]: https://lexi-lambda.github.io/blog/2019/11/05/parse-don-t-validate/
    public static boolean validate(String passport) {
        var map = parseMap(passport);

        // First check if all the keys we expect are in the map. (Doing optional
        // handling of `map.get` is quite verbose in Java without Haskell's `do`
        // or Rusts's `?`, so I'd rather do things this way).
        var requiredKeys = Arrays.asList("byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid");
        if (!Util.containsKeys(map, requiredKeys))
            return false;

        int birthYear = Util.parseInt(map.get("byr")).orElse(0);
        boolean birthYearValid = (1920 <= birthYear) && (birthYear <= 2002);

        int issueYear = Util.parseInt(map.get("iyr")).orElse(0);
        boolean issueYearValid = (2010 <= issueYear) && (issueYear <= 2020);

        int expirationYear = Util.parseInt(map.get("eyr")).orElse(0);
        boolean expirationYearValid = (2020 <= expirationYear) && (expirationYear <= 2030);

        var heightStr = map.get("hgt");
        boolean heightValid = false;
        int height = Util.parseInt(heightStr.substring(0, heightStr.length() - 2)).orElse(0);
        var units = heightStr.substring(heightStr.length() - 2, heightStr.length());

        if (units.equals("cm")) {
            heightValid = (150 <= height) && (height <= 193);
        }
        else if (units.equals("in")) {
            heightValid = (59 <= height) && (height <= 76);
        }

        boolean hairColorValid = map.get("hcl").matches("#[a-f0-9]{6}");

        var validEyeColors = Arrays.asList("amb", "blu", "brn", "gry", "grn", "hzl", "oth");
        boolean eyeColorValid = validEyeColors.contains(map.get("ecl"));

        boolean passportIdValid = map.get("pid").matches("[0-9]{9}");

        return birthYearValid && issueYearValid && expirationYearValid &&
               heightValid && hairColorValid && eyeColorValid && passportIdValid;
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

    // Parse "iyr:2013" into SimpleEntry("iyr", "2013").
    static AbstractMap.SimpleEntry<String, String> parseKvp(String toParse) {
        var split = toParse.split(":");
        assert split.length == 2;
        return new AbstractMap.SimpleEntry(split[0], split[1]);
    }
}

class Util {
    public static <K, V> boolean containsKeys(Map<K, V> map, List<K> keys) {
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

    public static OptionalInt parseInt(String toParse) {
        try {
            return OptionalInt.of(Integer.parseInt(toParse));
        }
        catch (NumberFormatException e) {
            return OptionalInt.empty();
        }
    }

    public static String removeSuffix(String str, String suffix) {
        if (str.endsWith(suffix)) {
            return str.substring(0, str.length() - suffix.length());
        }
        return str;
    }
}
