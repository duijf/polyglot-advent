package main

import (
	"fmt"
	"os"
	"sort"
	"strconv"
	"strings"
)

func main() {
	contents, err := os.ReadFile("input/one.txt")
	if err != nil {
		fmt.Errorf("failed to read input: %w", err)
	}

	lines := strings.Split(string(contents), "\n")

	var c1 []int
	var c2 []int

	for _, line := range lines {
		stuff := strings.Split(line, "   ")

		if len(stuff) != 2 {
			continue
		}

		parsed, _ := strconv.Atoi(stuff[0])
		c1 = append(c1, parsed)
		parsed, _ = strconv.Atoi(stuff[1])
		c2 = append(c2, parsed)
	}

	sort.Ints(c1)
	sort.Ints(c2)

	diff := 0
	for i := 0; i < len(c1); i++ {
		diff += AbsInt(c1[i] - c2[i])
	}

	fmt.Println("Part 1:", diff)

	frequencies := make(map[int]int)
	for _, i := range c2 {
		frequencies[i] += 1
	}

	similarity := 0
	for _, i := range c1 {
		similarity += i * frequencies[i]
	}

	fmt.Println("Part 2:", similarity)
}

func AbsInt(x int) int {
	if x >= 0 {
		return x
	}

	return -x
}
