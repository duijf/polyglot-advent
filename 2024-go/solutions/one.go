package main

import (
	"fmt"
	"log"
	"os"
	"sort"
	"strconv"
	"strings"
)

func main() {
	contents, err := os.ReadFile("input/one.txt")
	ExitOnErr("failed to read input: %v", err)

	lines := strings.Split(string(contents), "\n")

	var c1, c2 []int

	for _, line := range lines {
		parts := strings.Fields(line)

		if len(parts) != 2 {
			continue
		}

		val1, err1 := strconv.Atoi(parts[0])
		val2, err2 := strconv.Atoi(parts[1])

		ExitOnErr("could not parse int: %v", err1)
		ExitOnErr("could not parse int: %v", err2)

		c1 = append(c1, val1)
		c2 = append(c2, val2)
	}

	sort.Ints(c1)
	sort.Ints(c2)

	diff := 0
	for i := range c1 {
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

func ExitOnErr(format string, err error) {
	if err != nil {
		log.Fatalf(format, err)
	}
}

func AbsInt(x int) int {
	if x >= 0 {
		return x
	}

	return -x
}
