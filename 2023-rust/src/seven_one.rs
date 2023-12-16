#![allow(unused)]
use anyhow::{bail, Context, Result};
use std::collections::HashMap;

pub fn puzzle() -> Result<u128> {
    let input = std::fs::read_to_string("inputs/seven")?;

    let mut hands = Vec::new();

    for line in input.lines() {
        let (cards, bid) = line.split_once(" ").context("Invalid format")?;
        let cards: Vec<_> = cards.chars().flat_map(|c| Card::from(c)).collect();
        let bid = bid.parse()?;
        hands.push(Hand { cards, bid })
    }

    hands.sort();

    let mut result = 0;

    for (idx, hand) in hands.iter().enumerate() {
        result += hand.bid * (idx as u128 + 1);
    }

    Ok(result)
}

#[derive(Debug, PartialEq, Eq)]
struct Hand {
    cards: Vec<Card>,
    bid: u128,
}

impl PartialOrd for Hand {
    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
        Some(self.cmp(other))
    }
}

impl Ord for Hand {
    // Compare on cards, not bids
    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
        let us = classify(&self.cards);
        let them = classify(&other.cards);

        if us < them {
            std::cmp::Ordering::Less
        } else if us > them {
            std::cmp::Ordering::Greater
        } else {
            // Compare vectors on the first card that differs
            self.cards.cmp(&other.cards)
        }
    }
}

#[derive(Eq, Hash, PartialEq, PartialOrd, Ord, Debug)]
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

#[derive(Debug, PartialEq, PartialOrd)]
enum Classification {
    HighCard,
    OnePair,
    TwoPair,
    ThreeOfAKind,
    FullHouse,
    FourOfAKind,
    FiveOfAKind,
}

fn classify(hand: &[Card]) -> Classification {
    assert!(hand.len() == 5);

    let mut cards_by_amount = HashMap::new();

    for card in hand {
        *cards_by_amount.entry(card).or_insert(0) += 1
    }

    let mut amounts: Vec<_> = cards_by_amount.values().collect();
    amounts.sort();

    match &amounts[..] {
        &[5] => Classification::FiveOfAKind,
        &[1, 4] => Classification::FourOfAKind,
        &[2, 3] => Classification::FullHouse,
        &[1, 1, 3] => Classification::ThreeOfAKind,
        &[1, 2, 2] => Classification::TwoPair,
        &[1, 1, 1, 2] => Classification::OnePair,
        &[1, 1, 1, 1, 1] => Classification::HighCard,
        rest => unreachable!(),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn ordering() {
        assert!(Card::Ten > Card::Nine);
        assert!(Card::Ace > Card::Two);
    }

    #[test]
    fn classification() {
        use Card::*;
        use Classification::*;

        assert_eq!(classify(&[Ace, Ace, Ace, Ace, Ace]), FiveOfAKind);
        assert_eq!(classify(&[Ace, Ace, Ace, Ace, King]), FourOfAKind);
        assert_eq!(classify(&[Ace, Ace, Ace, King, King]), FullHouse);
        assert_eq!(classify(&[Ace, Ace, Ace, King, Queen]), ThreeOfAKind);
        assert_eq!(classify(&[Ace, Ace, King, King, Queen]), TwoPair);
        assert_eq!(classify(&[Ace, Ace, King, Joker, Queen]), OnePair);
        assert_eq!(classify(&[Ace, Two, King, Joker, Queen]), HighCard);

        assert_eq!(classify(&[Ace, Two, Three, Ace, Four]), OnePair);
        assert_eq!(classify(&[Two, Three, Four, Three, Two]), TwoPair);
    }

    #[test]
    fn comparison() {
        use std::cmp::Ordering::*;
        use Card::*;

        assert_ordering(
            vec![Ace, Ace, Ace, Ace, Ace],
            vec![King, King, King, King, King],
            Greater,
        );

        assert_ordering(
            vec![King, King, King, King, King],
            vec![Ace, Ace, Ace, Ace, Ace],
            Less,
        );

        assert_ordering(
            vec![Three, Three, Three, Three, Two],
            vec![Two, Ace, Ace, Ace, Ace],
            Greater,
        );

        assert_ordering(
            vec![Seven, Seven, Eight, Eight, Eight],
            vec![Seven, Seven, Seven, Eight, Eight],
            Greater,
        );

        assert_ordering(
            vec![Ace, Joker, Ace, Ace, Ace],
            vec![Ace, Ace, Queen, Two, Ace],
            Greater,
        );
    }

    fn assert_ordering(left: Vec<Card>, right: Vec<Card>, ordering: std::cmp::Ordering) {
        let left = Hand {
            cards: left,
            bid: 0,
        };
        let right = Hand {
            cards: right,
            bid: 0,
        };

        assert_eq!(left.cmp(&right), ordering)
    }
}
