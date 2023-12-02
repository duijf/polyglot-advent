#!/usr/bin/env python3.8
from __future__ import annotations

from dataclasses import dataclass


@dataclass(frozen=True)
class Policy:
    first_pos: int
    second_pos: int
    character: str
    password: str

    @classmethod
    def parse(cls, line: str) -> Policy:
        """
        Parse a PasswordLine from a single line of the input file.

        This line:

            15-18 r: xrrrbrrrgrpbrprrqrqr

        Should be parsed as:

            PolicyLine(
                first_pos=15,
                second_pos=18,
                character="4",
                password="xrrrbrrrgrpbrprrqrqr"
            )
        """
        policy_field, char_field, password = line.split()

        # Remove the `:` character that is in the input line.
        char = char_field.rstrip(":")

        first_str, second_str = policy_field.split("-")
        first_pos, second_pos = int(first_str) - 1, int(second_str) - 1

        return cls(first_pos, second_pos, char, password)

    def is_valid(self) -> bool:
        """
        Is `self.password` valid according to the rest of the policy?

        In this case, the password is valid when only one of the two
        characters of first and second pos is has the value of character.
        """

        return (
            (self.password[self.first_pos] == self.character) ^
            (self.password[self.second_pos] == self.character)
        )


if __name__ == "__main__":
    with open("input") as f:
        policy_lines = [Policy.parse(line) for line in f.readlines()]

    print(sum([line.is_valid() for line in policy_lines]))
