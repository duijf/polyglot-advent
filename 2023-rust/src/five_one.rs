#![allow(unused)]

use anyhow::{bail, Context, Result};
use core::ops::Range;
use std::collections::HashSet;

#[derive(Debug)]
struct Transform {
    source_start: u64,
    dest_start: u64,
    length: u64,
}

impl Transform {
    fn source_contains(&self, num: u64) -> bool {
        (self.source_start..self.source_start + self.length).contains(&num)
    }
}

pub fn puzzle() -> Result<u64> {
    let input = std::fs::read_to_string("inputs/five")?;

    let (seeds, input) = input.split_once("\n\n").context("Invalid format")?;
    let seeds = seeds.split(" ").flat_map(|n| n.parse::<u64>());

    let mut maps: Vec<_> = std::iter::repeat_with(|| Vec::new()).take(7).collect();

    let mut current_map_idx = 0;
    for line in input.lines() {
        if line == "" {
            current_map_idx += 1;
            continue;
        }
        if line.ends_with("map:") {
            continue;
        }

        // Geez, this is ugly syntax. Split, collect into a Vec, then slice
        // it and match on the three fields we expect.
        let transform = match &line.split(" ").collect::<Vec<_>>()[..] {
            &[dst, src, l] => maps[current_map_idx].push(Transform {
                source_start: src.parse()?,
                dest_start: dst.parse()?,
                length: l.parse()?,
            }),
            unexpected => bail!("Invalid split format: {:?}", unexpected),
        };
    }

    seeds
        .map(|s| transform_num(s, &maps))
        .min()
        .context("No minimum found")
}

fn transform_num(num: u64, maps: &Vec<Vec<Transform>>) -> u64 {
    let mut num = num;

    for (idx, map) in maps.iter().enumerate() {
        for transform in map {
            if transform.source_contains(num) {
                num = transform.dest_start + num - transform.source_start;
                break;
            }
        }
    }
    num
}
