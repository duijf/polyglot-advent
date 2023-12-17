#![allow(unused)]
use std::collections::HashMap;

use anyhow::{bail, Context, Result};
use chumsky::prelude::*;

pub fn puzzle() -> Result<u64> {
    let input = std::fs::read_to_string("inputs/eight")?;
    let input = p_input().parse(input).unwrap();
    solve(input)
}

#[derive(Debug, Clone, Eq, PartialEq)]
enum Direction {
    Left,
    Right,
}

#[derive(Debug, Eq, PartialEq, Hash, Clone)]
struct Node(String);

impl Node {
    fn from(val: impl ToString) -> Self {
        Node(val.to_string())
    }
}

#[derive(Debug)]
pub struct Input {
    directions: Vec<Direction>,
    network: HashMap<Node, [Node; 2]>,
}

fn p_directions() -> impl Parser<char, Vec<Direction>, Error = Simple<char>> {
    choice((
        just('L').to(Direction::Left),
        just('R').to(Direction::Right),
    ))
    .repeated()
    .at_least(1)
    .collect()
    .padded()
}

fn p_network() -> impl Parser<char, HashMap<Node, [Node; 2]>, Error = Simple<char>> {
    p_node()
        .then_ignore(just("=").padded())
        .then(
            p_node()
                .separated_by(just(","))
                .exactly(2)
                .delimited_by(just('('), just(')')),
        )
        .map(|(node, dests)| (node, [dests[0].clone(), dests[1].clone()]))
        .separated_by(text::newline())
        .at_least(1)
        .collect()
}

fn p_node() -> impl Parser<char, Node, Error = Simple<char>> {
    one_of("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        .repeated()
        .exactly(3)
        .collect::<String>()
        .map(Node)
        .padded()
}

fn p_input() -> impl Parser<char, Input, Error = Simple<char>> {
    p_directions()
        .then(p_network())
        .map(|(directions, network)| Input {
            directions,
            network,
        })
}

fn solve(input: Input) -> Result<u64> {
    let term = Node("ZZZ".into());
    let directions = input.directions.iter().cycle();

    let mut current = Node("AAA".into());
    let mut steps = 0;
    for direction in directions {
        if current == term {
            break;
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
                (Node::from("AAA"), [Node::from("BBB"), Node::from("CCC")]),
                (Node::from("BBB"), [Node::from("DDD"), Node::from("EEE")]),
                (Node::from("CCC"), [Node::from("ZZZ"), Node::from("GGG")]),
                (Node::from("DDD"), [Node::from("DDD"), Node::from("DDD")]),
                (Node::from("EEE"), [Node::from("EEE"), Node::from("EEE")]),
                (Node::from("GGG"), [Node::from("GGG"), Node::from("GGG")]),
                (Node::from("ZZZ"), [Node::from("ZZZ"), Node::from("ZZZ")]),
            ]),
        };

        assert_matches!(solve(basic), Ok(2));

        let cycles = Input {
            directions: vec![Direction::Left, Direction::Left, Direction::Right],
            network: HashMap::from([
                (Node::from("AAA"), [Node::from("BBB"), Node::from("BBB")]),
                (Node::from("BBB"), [Node::from("AAA"), Node::from("ZZZ")]),
                (Node::from("ZZZ"), [Node::from("ZZZ"), Node::from("ZZZ")]),
            ]),
        };

        assert_matches!(solve(cycles), Ok(6));
    }

    #[test]
    fn test_parser() {
        use Direction::*;

        assert_eq!(
            p_directions().parse("LRLR"),
            Ok(vec![Left, Right, Left, Right])
        );

        assert_eq!(p_node().parse("ABC"), Ok(Node::from("ABC")));

        assert_eq!(
            p_network().parse("AAA = (BBB, CCC)"),
            Ok(HashMap::from([(
                Node::from("AAA"),
                [Node::from("BBB"), Node::from("CCC")]
            )]))
        )
    }
}
