use std::fs;
use anyhow::Result;


pub fn puzzle_one() -> Result<u32> {
    let input: String = String::from_utf8_lossy(&fs::read("inputs/two")?).into_owned();
    Ok(0)
}
