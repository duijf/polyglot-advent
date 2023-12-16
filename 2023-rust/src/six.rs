#![allow(unused)]
use anyhow::{bail, Context, Result};

pub fn puzzle_one() -> Result<u64> {
    let input = std::fs::read_to_string("inputs/six")?;

    let (durations, records) = input.split_once("\n").context("Invalid format")?;
    let durations = parse_all_numbers(durations.trim_start_matches("Time:"));
    let records = parse_all_numbers(records.trim_start_matches("Distance:"));

    let mut result = 1;

    for (time, distance) in durations.iter().zip(records.iter()) {
        result *= calc_num_solutions(*time, *distance);
    }

    Ok(result)
}

pub fn puzzle_two() -> Result<u64> {
    let input = std::fs::read_to_string("inputs/six")?;

    let (duration, record) = input.split_once("\n").context("Invalid format")?;

    let time = duration
        .chars()
        .filter(|c| c.is_digit(10))
        .collect::<String>()
        .parse()?;
    let distance = record
        .chars()
        .filter(|c| c.is_digit(10))
        .collect::<String>()
        .parse()?;

    Ok(calc_num_solutions(time, distance))
}

fn parse_all_numbers(input: &str) -> Vec<f64> {
    input.trim().split(" ").flat_map(|n| n.parse()).collect()
}

fn calc_num_solutions(time: f64, distance: f64) -> u64 {
    // Two equations are relevant here:
    //
    //   speed = time - x
    //   distance = speed * time
    //
    // Sutstituting gives us:
    //
    //   (time - x) * x > distance
    //   -x^2 + x*time > distance
    //   -x^2 + x*time - distance > 0
    //
    // With time = 7 and distance = 9:
    //
    //   -x^2 + 7*x - 9 > 0
    //
    // And can use the ABC formula to solve this:
    let a = -1.0;
    let b = time;
    let c = -distance;

    let discriminant = b * b - 4.0 * a * c;
    let one = (-b + discriminant.sqrt()) / (2.0 * a);
    let two = (-b - discriminant.sqrt()) / (2.0 * a);

    let min = f64::min(one, two);
    let max = f64::max(one, two);

    // Plus 1, because the range of solutions is inclusive.
    let num_solutions = max.floor() - min.ceil() + 1.0;

    num_solutions as u64
}

#[cfg(test)]
mod tests {
    use super::*;
}
