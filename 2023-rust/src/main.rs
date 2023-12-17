use anyhow::Result;

mod one;
mod two;
mod three;
mod four;
mod five_one;
mod five_two;
mod six;
mod seven_one;
mod seven_two;
mod eight;
mod nine_one;
mod nine_two;

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
    dbg!(seven_one::puzzle()?);
    dbg!(seven_two::puzzle()?);
    dbg!(eight::puzzle_one()?);
    dbg!(eight::puzzle_two()?);
    dbg!(nine_one::puzzle()?);
    dbg!(nine_two::puzzle()?);
    Ok(())
}
