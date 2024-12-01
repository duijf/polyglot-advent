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

	var c1 []int
	var c2 []int

	lines := strings.Split(string(contents), "\n")
	for _, line := range lines {
		stuff := strings.Split(line, "   ")

		if len(stuff) == 2 {
			parsed, _ := strconv.Atoi(stuff[0])
			c1 = append(c1, parsed)
			parsed, _ = strconv.Atoi(stuff[1])
			c2 = append(c2, parsed)
		}
	}

	sort.Ints(c1)
	sort.Ints(c2)

	diff := 0
	for i := 0; i < len(c1); i++ {
		diff += AbsInt(c1[i] - c2[i])
	}

	fmt.Println(diff)
}

func AbsInt(x int) int {
	if x >= 0 {
		return x
	}

	return -x
}
