use anyhow::Result;

mod one;

fn main() -> Result<()> {
    one::puzzle_one()?;
    one::puzzle_two()?;
    Ok(())
}
