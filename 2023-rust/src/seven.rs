#![allow(unused)]
use anyhow::{bail, Context, Result};

#[derive(PartialEq, PartialOrd)]
enum Card {
    Two,
    Three,
    Four,
    Five,
    Six,
    Seven,
    Eight,
    Nine,
    Ten,
    Joker,
    Queen,
    King,
    Ace,
}

impl Card {
    fn from(c: char) -> Result<Self> {
        let card = match c {
            'A' => Card::Ace,
            'K' => Card::King,
            'Q' => Card::Queen,
            'J' => Card::Joker,
            'T' => Card::Ten,
            '9' => Card::Nine,
            '8' => Card::Eight,
            '7' => Card::Seven,
            '6' => Card::Six,
            '5' => Card::Five,
            '4' => Card::Four,
            '3' => Card::Three,
            '2' => Card::Two,
            _ => bail!("Unexpected val {}", c),
        };

        Ok(card)
    }
}

pub fn puzzle_one() -> Result<u64> {
    let input = std::fs::read_to_string("inputs/test")?;

    for line in input.lines() {
        let (hand, bid) = input.split_once(" ").context("Invalid format")?;
        let hand: Vec<_> = hand.chars().flat_map(|c| Card::from(c)).collect();
    }
    todo!()
}


#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn ordering() {
        assert!(Card::Ten > Card::Nine);
        assert!(Card::Ace > Card::Two);
    }
}
