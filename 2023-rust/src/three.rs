use anyhow::Result;

pub fn puzzle_one() -> Result<u32> {
    let input: String = std::fs::read_to_string("inputs/three")?;

    let mut total = 0;

    let mut schematic: Vec<Vec<char>> = Vec::new();
    let mut seen = Vec::new();

    for (idx, line) in input.lines().enumerate() {
        schematic.push(line.chars().collect());
        seen.push(vec![false; schematic[idx].len()]);
    }

    for (y, line) in schematic.iter().enumerate() {
        for (x, char) in line.iter().enumerate() {
            if char.is_digit(10) || char == &'.' {
                continue;
            }

            // We have a symbol now, so we need to look in a circle
            // around the current x, y position. If we find a digit
            // that we haven't seen before, it's a subset of a new
            // part number. We then need to find the full part number
            // and add it to our total.
            let coords_to_search = [
                (y - 1, x - 1),
                (y - 1, x),
                (y - 1, x + 1),
                (y, x - 1),
                (y, x),
                (y, x + 1),
                (y + 1, x - 1),
                (y + 1, x),
                (y + 1, x + 1),
            ];

            for (y, x) in coords_to_search {
                if seen[y][x] {
                    continue;
                }

                if schematic[y][x].is_digit(10) {
                    // Find start, dealing with underflow
                    let mut start = x;
                    while let Some(candidate) = start.checked_sub(1) {
                        if !schematic[y][candidate].is_digit(10) {
                            break;
                        }
                        start = candidate;
                    }

                    // Find end. We don't need to care about overflow
                    // in our example input.
                    let mut end = x;
                    while end + 1 < schematic[y].len() {
                        if !schematic[y][end + 1].is_digit(10) {
                            break;
                        }
                        end += 1;
                    }

                    let mut number = 0;
                    for i in start..=end {
                        number *= 10;
                        number += schematic[y][i].to_digit(10).unwrap();

                        // Mark everything as seen
                        seen[y][i] = true;
                    }

                    total += number;
                }
            }
        }
    }

    Ok(total)
}

pub fn puzzle_two() -> Result<u32> {
    let input: String = std::fs::read_to_string("inputs/three")?;

    let mut total = 0;

    let mut schematic: Vec<Vec<char>> = Vec::new();
    let mut seen = Vec::new();

    for (idx, line) in input.lines().enumerate() {
        schematic.push(line.chars().collect());
        seen.push(vec![false; schematic[idx].len()]);
    }

    for (y, line) in schematic.iter().enumerate() {
        for (x, char) in line.iter().enumerate() {
            if char != &'*' {
                continue;
            }

            // We have a symbol now, so we need to look in a circle
            // around the current x, y position. If we find a digit
            // that we haven't seen before, it's a subset of a new
            // part number. We then need to find the full part number
            // and add it to the part number we have found.
            let mut found = Vec::new();

            let coords_to_search = [
                (y - 1, x - 1),
                (y - 1, x),
                (y - 1, x + 1),
                (y, x - 1),
                (y, x),
                (y, x + 1),
                (y + 1, x - 1),
                (y + 1, x),
                (y + 1, x + 1),
            ];

            for (y, x) in coords_to_search {
                if seen[y][x] {
                    continue;
                }

                if schematic[y][x].is_digit(10) {
                    // Find start, dealing with underflow
                    let mut start = x;
                    while let Some(candidate) = start.checked_sub(1) {
                        if !schematic[y][candidate].is_digit(10) {
                            break;
                        }
                        start = candidate;
                    }

                    // Find end. We don't need to care about overflow
                    // in our example input.
                    let mut end = x;
                    while end + 1 < schematic[y].len() {
                        if !schematic[y][end + 1].is_digit(10) {
                            break;
                        }
                        end += 1;
                    }

                    let mut number = 0;
                    for i in start..=end {
                        number *= 10;
                        number += schematic[y][i].to_digit(10).unwrap();

                        // Mark everything as seen
                        seen[y][i] = true;
                    }

                    found.push(number);
                }
            }

            if found.len() == 2 {
                total += found[0] * found[1];
            }
        }
    }

    Ok(total)
}
