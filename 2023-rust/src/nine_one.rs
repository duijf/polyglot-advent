#![allow(unused)]
use std::collections::HashMap;

use anyhow::{bail, Context, Result};
use chumsky::prelude::*;

pub fn puzzle() -> Result<i64> {
    let input = std::fs::read_to_string("inputs/nine")?;
    Ok(input.lines().map(predict).sum())
}

fn predict(line: &str) -> i64 {
    let mut layers: Vec<Vec<i64>> = vec![line.split(" ").flat_map(|c| c.parse()).collect()];

    loop {
        let last_layer = layers.last().unwrap();
        let mut diffs_were_zero = true;
        let mut current_layer = Vec::with_capacity(last_layer.len() - 1);

        for pairs in last_layer.windows(2) {
            let &[a, b] = pairs else { panic!() };
            current_layer.push(b - a);
            diffs_were_zero = diffs_were_zero && (b - a) == 0;
        }

        layers.push(current_layer);

        if diffs_were_zero {
            break;
        };
    }

    let mut i = layers.len() - 1;
    while i > 0 {
        let a = layers[i].last().unwrap().clone();
        let b = layers[i-1].last().unwrap().clone();
        layers[i-1].push(a+b);
        i -= 1;
    }

    *layers[0].last().unwrap()
}

#[cfg(test)]
mod tests {
    use super::*;
    use assert_matches::assert_matches;

    #[test]
    fn test_examples() {
        assert_eq!(predict("0 3 6 9 12 15"), 18);
        assert_eq!(predict("1 3 6 10 15 21"), 28);
        assert_eq!(predict("10 13 16 21 30 45"), 68);
    }
}
