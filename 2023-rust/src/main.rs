use anyhow::Result;

mod five_one;
mod five_two;
mod four;
mod one;
mod three;
mod two;

fn main() -> Result<()> {
    dbg!(one::puzzle_one()?);
    dbg!(one::puzzle_two()?);
    dbg!(two::puzzle_one()?);
    dbg!(two::puzzle_two()?);
    dbg!(three::puzzle_one()?);
    dbg!(three::puzzle_two()?);
    dbg!(four::puzzle_one()?);
    dbg!(four::puzzle_two()?);
    dbg!(five_one::puzzle()?);
    dbg!(five_two::puzzle()?);
    Ok(())
}
