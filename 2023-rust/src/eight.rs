#![allow(unused)]
use anyhow::{bail, Context, Result};
use std::collections::HashMap;

pub fn puzzle() -> Result<u64> {
    let input = parse_input("inputs/test")?;
    solve(input)
}

#[derive(Eq, PartialEq)]
enum Direction {
    Left,
    Right,
}

#[derive(Eq, PartialEq, Hash, Clone)]
struct Node<'a>(&'a str);

pub struct Input<'a> {
    directions: Vec<Direction>,
    network: HashMap<Node<'a>, [Node<'a>; 2]>,
}

pub fn parse_input(filename: &str) -> Result<Input> {
    let input = std::fs::read_to_string(filename)?;
    todo!()
}

fn solve(input: Input) -> Result<u64> {
    let term = Node("ZZZ");
    let directions = input.directions.iter().cycle();

    let mut current = Node("AAA");
    let mut steps = 0;
    for direction in directions {
        if current == term {
            break
        };

        let index = if *direction == Direction::Left { 0 } else { 1 };
        // Maybe there is a way to get rid of `clone()` here?
        current = input.network.get(&current).unwrap()[index].clone();
        steps += 1;
    }

    Ok(steps)
}

#[cfg(test)]
mod tests {
    use super::*;
    use assert_matches::assert_matches;

    #[test]
    fn test_example() {
        let basic = Input {
            directions: vec![Direction::Right, Direction::Left],
            network: HashMap::from([
                (Node("AAA"), [Node("BBB"), Node("CCC")]),
                (Node("BBB"), [Node("DDD"), Node("EEE")]),
                (Node("CCC"), [Node("ZZZ"), Node("GGG")]),
                (Node("DDD"), [Node("DDD"), Node("DDD")]),
                (Node("EEE"), [Node("EEE"), Node("EEE")]),
                (Node("GGG"), [Node("GGG"), Node("GGG")]),
                (Node("ZZZ"), [Node("ZZZ"), Node("ZZZ")]),
            ])
        };

        assert_matches!(solve(basic), Ok(2));

        let cycles = Input {
            directions: vec![Direction::Left, Direction::Left, Direction::Right],
            network: HashMap::from([
                (Node("AAA"), [Node("BBB"), Node("BBB")]),
                (Node("BBB"), [Node("AAA"), Node("ZZZ")]),
                (Node("ZZZ"), [Node("ZZZ"), Node("ZZZ")]),
            ])
        };

        assert_matches!(solve(cycles), Ok(6));
    }
}
