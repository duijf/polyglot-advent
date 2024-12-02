package main

import (
	"fmt"
	"os"
	"slices"
	"strings"

	"duijf.io/advent/lib"
)

func main() {
	contents, err := os.ReadFile("input/two.txt")
	lib.ExitOnErr("failed to read file: %v", err)

	lines := strings.Split(string(contents), "\n")

	safe := 0
	safeAfterModification := 0

	for _, line := range lines {
		report := lib.MapSlice(strings.Fields(line), lib.ParseIntOrExit)

		if len(report) == 0 {
			continue
		}

		if isSafe(report) {
			safe++
		} else if canBeMadeSafe(report) {
			safeAfterModification++
		}
	}

	fmt.Println("Part 1:", safe)
	fmt.Println("Part 2:", safe+safeAfterModification)
}

func isSafe(report []int) bool {
	increase := false
	decrease := false

	for i := 1; i < len(report); i++ {
		diff := report[i] - report[i-1]

		if diff > 0 {
			increase = true
		} else if diff < 0 {
			decrease = true
		} else {
			return false
		}

		if lib.AbsInt(diff) > 3 {
			return false
		}
	}

	return increase != decrease
}

func canBeMadeSafe(report []int) (safe bool) {
	for i := 0; i < len(report); i++ {
		tmp := append([]int{}, report...)
		safe = safe || isSafe(slices.Delete(tmp, i, i+1))
	}

	return
}
