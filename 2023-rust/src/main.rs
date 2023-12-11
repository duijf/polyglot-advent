use anyhow::Result;

mod one;
mod two;
mod three;
mod four;

fn main() -> Result<()> {
    dbg!(one::puzzle_one()?);
    dbg!(one::puzzle_two()?);
    dbg!(two::puzzle_one()?);
    dbg!(two::puzzle_two()?);
    dbg!(three::puzzle_one()?);
    dbg!(three::puzzle_two()?);
    dbg!(four::puzzle_one()?);
    dbg!(four::puzzle_two()?);
    Ok(())
}
