
#![allow(unused)]

use std::collections::HashSet;
use anyhow::{Result, Context};

pub fn puzzle_one() -> Result<u32> {
    let input = std::fs::read_to_string("inputs/four")?;

    let mut total = 0;

    for line in input.lines() {
        let (_, line) = line.split_once(": ").context("Invalid format")?;
        let (winning, drawed) = line.split_once(" | ").context("Invalid format")?;

        let winning: HashSet<usize> = winning
            .split_whitespace().flat_map(|n| n.parse()).collect();

        let drawed: HashSet<usize> = drawed
            .split_whitespace().flat_map(|n| n.parse()).collect();

        let num_winning: u32 = winning.intersection(&drawed).count().try_into()?;
        if num_winning == 0 {
            continue
        }

        total += u32::pow(2, num_winning.saturating_sub(1));
    }

    Ok(total)
}

pub fn puzzle_two() -> Result<u32> {
    let input = std::fs::read_to_string("inputs/four")?;

    let total_cards = input.chars().filter(|c| c == &'\n').count();
    let mut num_cards = vec![1; total_cards];

    for (idx, line) in input.lines().enumerate() {
        let (_, line) = line.split_once(": ").context("Invalid format")?;
        let (winning, drawed) = line.split_once(" | ").context("Invalid format")?;

        let winning: HashSet<usize> = winning
            .split_whitespace().flat_map(|n| n.parse()).collect();

        let drawed: HashSet<usize> = drawed
            .split_whitespace().flat_map(|n| n.parse()).collect();

        let num_winning = winning.intersection(&drawed).count();

        for next in idx+1..=idx+num_winning {
            num_cards[next] += num_cards[idx]
        }
    }

    Ok(num_cards.iter().sum())
}
