package main

import (
	"fmt"
	"os"
	"regexp"

	"duijf.io/advent/lib"
)

func main() {
	bytes, err := os.ReadFile("input/three.txt")
	lib.ExitOnErr("failed to read file: %v", err)

	// Either `mul(a,b)`, `do()`, or `don't()`. Note
	// the capture groups around the parameters to mul.
	r := regexp.MustCompile("mul\\((\\d+),(\\d+)\\)|do\\(\\)|don't\\(\\)")

	matches := r.FindAllStringSubmatch(string(bytes), -1)

	result := 0
	resultWithSkips := 0

	execute := true

	for _, match := range matches {
		if match[0] == "do()" {
			execute = true
			continue
		}
		if match[0] == "don't()" {
			execute = false
			continue
		}

		a := lib.ParseIntOrExit(match[1])
		b := lib.ParseIntOrExit(match[2])
		result += a * b

		if execute {
			resultWithSkips += a * b
		}
	}

	fmt.Println("Part 1:", result)
	fmt.Println("Part 2:", resultWithSkips)
}
