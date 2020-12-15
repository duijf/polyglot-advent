#!/usr/bin/env python3.8
from __future__ import annotations

from dataclasses import dataclass


@dataclass(frozen=True)
class Policy:
    min_occurs: int
    max_occurs: int
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
                min-occurs=15,
                max_occurs=18,
                character="4",
                password="xrrrbrrrgrpbrprrqrqr"
            )
        """
        policy_field, char_field, password = line.split()

        # Remove the `:` character that is in the input line.
        char = char_field.rstrip(":")

        min_str, max_str = policy_field.split("-")
        min_occurs, max_occurs = int(min_str), int(max_str)

        return cls(min_occurs, max_occurs, char, password)

    def is_valid(self) -> bool:
        """
        Is `self.password` valid according to the rest of the policy?
        """
        return (
            self.password.count(self.character) >= self.min_occurs
            and self.password.count(self.character) <= self.max_occurs
        )


if __name__ == "__main__":
    with open("input") as f:
        policy_lines = [Policy.parse(line) for line in f.readlines()]

    print(sum([line.is_valid() for line in policy_lines]))
