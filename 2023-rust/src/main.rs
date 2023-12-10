use anyhow::Result;

mod one;
mod two;

fn main() -> Result<()> {
    dbg!(one::puzzle_one()?);
    dbg!(one::puzzle_two()?);
    dbg!(two::puzzle_one()?);
    dbg!(two::puzzle_two()?);
    Ok(())
}
