use anyhow::{Result, Context};


pub fn puzzle_one() -> Result<u32> {
    let input: String = std::fs::read_to_string("inputs/two")?;

    let max_red = 12;
    let max_green = 13;
    let max_blue = 14;

    let mut total = 0;

    for line in input.lines() {
        let rest = line.strip_prefix("Game ").context("No prefix")?;
        let (id, rest) = rest.split_once(": ").context("No ID found")?;
        let id: u32 = id.parse()?;

        let mut valid = true;

        for set in rest.split("; ") {
            for item in set.split(", ") {
                let (amount, color) = item.split_once(" ").context("Invalid format")?;
                let amount: u32 = amount.parse()?;

                if color == "red" {
                    valid &= amount <= max_red;
                }
                if color == "blue" {
                    valid &= amount <= max_blue;
                }
                if color == "green" {
                    valid &= amount <= max_green;
                }
            }
        }

        if valid {
            total += id;
        }
    }

    Ok(total)
}


pub fn puzzle_two() -> Result<u32> {
    let input: String = std::fs::read_to_string("inputs/two")?;

    let mut total = 0;

    for line in input.lines() {
        let mut max_red = 0;
        let mut max_green = 0;
        let mut max_blue = 0;

        let rest = line.strip_prefix("Game ").context("No prefix")?;
        let (_id, rest) = rest.split_once(": ").context("No ID found")?;

        for set in rest.split("; ") {
            for item in set.split(", ") {
                let (amount, color) = item.split_once(" ").context("Invalid format")?;
                let amount: u32 = amount.parse()?;

                if color == "red" {
                    max_red = std::cmp::max(max_red, amount);
                }
                if color == "blue" {
                    max_blue = std::cmp::max(max_blue, amount);
                }
                if color == "green" {
                    max_green = std::cmp::max(max_green, amount);
                }
            }
        }

        total += max_red * max_green * max_blue;
    }

    Ok(total)
}

// fn p_games(input: &str) -> IResult<&str, Vec<Game>> {
//     all_consuming(separated_list1(newline, p_game))(&input)
// }
//
// fn p_game(input: &str) -> IResult<&str, Game> {
//     tuple((
//         terminated(tag("Game"), space1),
//         u32,
//         terminated(tag(":"), space1),
//         separated_list1(terminated(tag(";"), space1), p_set)
//     ))
//     .map(|(_, id, _, sets)| {
//         Game{id, sets}
//     })
//     .parse(input)
// }
//
// fn p_set(input: &str) -> IResult<&str, Set> {
//     separated_list1(terminated(tag(","), space1), p_quantity)(input)
// }
//
// fn p_quantity(input: &str) -> IResult<&str, (u32, Color)> {
//     tuple((
//         terminated(u32, space1),
//         alt((
//             value(Color::Red, tag("red")),
//             value(Color::Green, tag("green")),
//             value(Color::Blue, tag("blue")),
//         ))
//     ))(input)
// }