#![deny(elided_lifetimes_in_paths)]
#![allow(dead_code)]
#![allow(unused)]

use std::fs;
use std::io::BufRead;

use anyhow::{Result, Context};
// use nom::{IResult, Parser};
// use nom::bytes::complete::{tag,take_until, take_while};
// use nom::error::ParseError;
// use nom::character::complete::{u32,space0,space1,newline};
// use nom::multi::{separated_list1};
// use nom::sequence::{tuple, terminated};
// use nom::branch::{alt};
// use nom::combinator::{value, all_consuming};
// use nom::{InputTake, InputLength, Compare};


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

        let mut valid = false;

        for set in rest.split("; ") {
            for item in set.split(", ") {
                println!("{}", item);
                let (amount, color) = item.split_once(" ").context("Invalid format")?;
                let amount: u32 = amount.parse()?;

                if color == "red" {

                }
            }
        }
    }

    todo!()


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
