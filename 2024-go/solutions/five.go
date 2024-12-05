package main

import (
	"fmt"
	"os"
	"slices"
	"strings"

	"duijf.io/advent/lib"
	set "github.com/deckarep/golang-set/v2"
)

func main() {
	contents, err := os.ReadFile("input/five.txt")
	lib.ExitOnErr("failed to open file: %v", err)

	lessThan, updates := parse(string(contents))

	partOne := 0
	partTwo := 0

	// I wish I came up with this myself. I had a pretty
	// convoluted first implementation, and it turns out
	// we are able to just generalize this problem to a
	// sort.
	cmp := func(a int, b int) int {
		if lessThan[a] == nil {
			return 0
		}

		if lessThan[a].Contains(b) {
			return -1
		}

		return 0
	}

	for _, update := range updates {
		if slices.IsSortedFunc(update, cmp) {
			partOne += update[len(update)/2]
		} else {
			slices.SortStableFunc(update, cmp)
			partTwo += update[len(update)/2]
		}
	}

	fmt.Println("Part 1:", partOne)
	fmt.Println("Part 2:", partTwo)
}

func parse(input string) (map[int]set.Set[int], [][]int) {
	lines := strings.Split(input, "\n")
	first, second := lib.SplitSlice(lines, "")

	lessThan := make(map[int]set.Set[int])

	for _, line := range first {
		split := strings.Split(line, "|")
		smaller := lib.ParseIntOrExit(split[0])
		larger := lib.ParseIntOrExit(split[1])

		if lessThan[smaller] == nil {
			lessThan[smaller] = set.NewSet[int]()
		}
		lessThan[smaller].Add(larger)
	}

	updates := make([][]int, 0)

	for _, line := range second {
		if line == "" {
			continue
		}

		update := make([]int, 0)
		for _, page := range strings.Split(line, ",") {
			update = append(update, lib.ParseIntOrExit(page))
		}
		updates = append(updates, update)
	}

	return lessThan, updates
}
