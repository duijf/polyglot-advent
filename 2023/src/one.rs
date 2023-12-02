use std::fs;
use anyhow::{Context, Result};


pub fn puzzle_one() -> Result<u32> {
    let input: String = String::from_utf8_lossy(&fs::read("inputs/one")?).into_owned();

    let mut total: u32 = 0;

    for line in input.lines() {
        // Try to convert all chars into digits, and keep the ones that succeded.
        let digits: Vec<u32> = line.chars().flat_map(|c: char| c.to_digit(10)).collect();

        let first: u32 = *digits.first().context("No first digit found")?;
        let last: u32 = *digits.last().context("No last digit found")?;

        total += (first * 10) + last
    }

    Ok(total)
}

pub fn puzzle_two() -> Result<u32> {
    let input: String = String::from_utf8_lossy(&fs::read("inputs/one")?).into_owned();

    let mut total: u32 = 0;
    let mut digits = Vec::new();

    let mapping = [
        ("one", 1),
        ("two", 2),
        ("three", 3),
        ("four", 4),
        ("five", 5),
        ("six", 6),
        ("seven", 7),
        ("eight", 8),
        ("nine", 9),
    ];

    for (idx, char) in input.chars().enumerate() {
        match char {
            '\n' => {
                let first: u32 = *digits.first().context("No first digit found")?;
                let last: u32 = *digits.last().context("No last digit found")?;
                total += (first * 10) + last;
                digits.clear()
            }
            '1'..='9' => {
                digits.push(char.to_digit(10).unwrap());
            }
            _ => {
                for (name, val) in mapping {
                    if input[idx..].starts_with(name) {
                        digits.push(val);
                    }
                }
            }
        }
    }

    Ok(total)
}
