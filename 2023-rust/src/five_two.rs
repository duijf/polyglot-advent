#![allow(unused)]

use anyhow::{bail, Context, Result};
use core::ops::Range;

#[derive(Debug)]
struct Transform {
    range: Range<u64>,
    offset: i64,
}

pub fn puzzle() -> Result<u64> {
    let input = std::fs::read_to_string("inputs/five")?;

    let (ranges_unparsed, input) = input.split_once("\n\n").context("Invalid format")?;

    let mut ranges = Vec::new();
    for range in parse_all_numbers(ranges_unparsed).chunks(2) {
        let &[start, len] = range else {
            bail!("Unbalanced ranges in input")
        };
        ranges.push(start..start + len)
    }

    let mut maps: Vec<Vec<Transform>> = std::iter::repeat_with(|| Vec::new()).take(7).collect();

    let mut current_map_idx = 0;
    for line in input.lines() {
        if line == "" {
            current_map_idx += 1;
            continue;
        }
        if line.ends_with("map:") {
            continue;
        }

        // Ugly syntax / logic. I just want to unpack into a tuple.
        // Split, parse, collect into a Vec, then slice it and match
        // on the three fields we expect.
        let t = match &parse_all_numbers(line)[..] {
            &[to, from, l] => {
                let offset = to as i64 - from as i64;
                Transform {
                    range: from..(from + l),
                    offset,
                }
            }
            unexpected => bail!("Invalid split format: {:?}", unexpected),
        };

        maps[current_map_idx].push(t);
    }

    let mut keep: Vec<Range<u64>> = Vec::new();
    let mut transformed: Vec<Range<u64>> = Vec::new();

    for map in maps {
        for transform in map {
            while let Some(range) = ranges.pop() {
                let overlap = find_overlap(&range, &transform.range);

                if let Some(overlap) = overlap.overlap {
                    let start = overlap.start.checked_add_signed(transform.offset).unwrap();
                    let end = overlap.end.checked_add_signed(transform.offset).unwrap();
                    transformed.push(start..end);
                }

                keep.extend(overlap.remaining);
            }

            std::mem::swap(&mut ranges, &mut keep);
        }

        ranges.extend(transformed.drain(0..));
    }

    ranges
        .iter()
        .map(|r| r.start)
        .min()
        .context("No minimum element found")
}


fn parse_all_numbers(input: &str) -> Vec<u64> {
    input.split(" ").flat_map(|n| n.parse()).collect()
}

#[derive(Debug, PartialEq)]
struct Overlap {
    overlap: Option<Range<u64>>,
    remaining: Vec<Range<u64>>,
}

/// Find the overlap of two ranges, if it exists. Return the
/// overlap, plus any left-over ranges from `a` that weren't
/// in the overlap.
fn find_overlap(a: &Range<u64>, b: &Range<u64>) -> Overlap {
    let start = std::cmp::max(a.start, b.start);
    let end = std::cmp::min(a.end, b.end);

    if start < end {
        let overlap = start..end;

        let mut remaining = Vec::new();

        if a.start < overlap.start {
            remaining.push(a.start..overlap.start)
        };

        if overlap.end < a.end {
            remaining.push(overlap.end..a.end)
        };

        Overlap {
            overlap: Some(overlap),
            remaining,
        }
    } else {
        Overlap {
            overlap: None,
            remaining: vec![a.clone()],
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn assert_overlap(
        a: Range<u64>,
        b: Range<u64>,
        overlap: Option<Range<u64>>,
        remaining: Vec<Range<u64>>,
    ) {
        assert_eq!(find_overlap(&a, &b), Overlap { overlap, remaining });
    }

    #[test]
    fn overlap() {
        assert_overlap(0..5, 0..10, Some(0..5), vec![]);
        assert_overlap(0..10, 0..5, Some(0..5), vec![5..10]);
        assert_overlap(1..5, 0..10, Some(1..5), vec![]);
        assert_overlap(0..10, 1..5, Some(1..5), vec![0..1, 5..10]);
        assert_overlap(0..5, 3..10, Some(3..5), vec![0..3]);
        assert_overlap(3..10, 0..5, Some(3..5), vec![5..10]);
        assert_overlap(0..5, 5..10, None, vec![0..5]);
        assert_overlap(5..10, 0..5, None, vec![5..10]);
    }
}
