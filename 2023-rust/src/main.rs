use anyhow::Result;

mod one;
mod two;
mod three;
mod four;
mod five_one;
mod five_two;
mod six;

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
    dbg!(six::puzzle_one()?);
    dbg!(six::puzzle_two()?);
    Ok(())
}
