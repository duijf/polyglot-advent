package main

import (
	"fmt"
	"os"
	"strings"

	"duijf.io/advent/lib"
)

func main() {
	contents, err := os.ReadFile("input/four.txt")
	lib.ExitOnErr("failed to open file: %v", err)

	lines := strings.Split(string(contents), "\n")
	chars := make([][]rune, len(lines)-1)

	for y, line := range lines {
		for _, char := range line {
			if char == '\n' {
				continue
			}
			chars[y] = append(chars[y], char)
		}
	}

	occurrences := 0
	partTwo := 0

	for y := 0; y < len(chars); y++ {
		for x := 0; x < len(chars[y]); x++ {
			if chars[y][x] == 'X' {
				occurrences += findXMAS(chars, y, x)
			}
			if chars[y][x] == 'A' && findTwo(chars, y, x) {
				partTwo++
			}
		}
	}

	fmt.Println("Part 1:", occurrences)
	fmt.Println("Part 2:", partTwo)
}

func findXMAS(chars [][]rune, y int, x int) (occurrences int) {
	for dy := -1; dy <= 1; dy++ {
		for dx := -1; dx <= 1; dx++ {
			if get(chars, y+dy, x+dx) == 'M' &&
				get(chars, y+dy*2, x+dx*2) == 'A' &&
				get(chars, y+dy*3, x+dx*3) == 'S' {
				occurrences++
			}
		}
	}
	return
}

func findTwo(chars [][]rune, y int, x int) bool {
	return isMas(
		get(chars, y-1, x-1),
		get(chars, y+1, x+1),
	) && isMas(
		get(chars, y-1, x+1),
		get(chars, y+1, x-1),
	)
}

func isMas(a rune, b rune) bool {
	return (((a == 'M') || (a == 'S')) &&
		((b == 'M') || (b == 'S')) &&
		a != b)
}

func get(chars [][]rune, y int, x int) rune {
	if y < 0 || y >= len(chars) {
		return rune(0)
	}
	if x < 0 || x >= len(chars[y]) {
		return rune(0)
	}

	return chars[y][x]
}
