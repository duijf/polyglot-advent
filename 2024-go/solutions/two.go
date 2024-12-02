package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"

	"duijf.io/advent/lib"
)

type CandidateType int

const (
	ORIGINAL CandidateType = iota
	DERIVED
)

type Candidate struct {
	Type CandidateType
	Line int
	Nums []int
}

func main() {
	contents, err := os.ReadFile("input/two.txt")
	lib.ExitOnErr("failed to read file: %v", err)

	lines := strings.Split(string(contents), "\n")

	safeCount := 0
	candidates := make([]Candidate, 0)
	safeLines := make(map[int]bool)

	for idx, line := range lines {
		nums := lib.MapSlice(strings.Fields(line), func(val string) int {
			num, err := strconv.Atoi(val)
			lib.ExitOnErr("%v", err)
			return num
		})

		if len(nums) == 0 {
			continue
		}

		candidates = append(candidates, Candidate{Type: ORIGINAL, Line: idx, Nums: nums})
	}

	for true {
		if len(candidates) == 0 {
			break
		}

		var c Candidate
		c, candidates = candidates[0], candidates[1:]

		firstDiff := c.Nums[1] - c.Nums[0]

		safe := true

		// The validation in the loop also validates that
		// the first diff is safe.
		for i := 1; i < len(c.Nums); i++ {
			diff := c.Nums[i] - c.Nums[i-1]

			if (firstDiff >= 0) != (diff >= 0) {
				safe = false
			}

			diff = lib.AbsInt(diff)

			if (diff < 1) || (3 < diff) {
				safe = false
			}
		}

		if !safe && c.Type == DERIVED {
			continue
		}

		if !safe && c.Type == ORIGINAL {
			// Create variations to also check.
			for i := 0; i < len(c.Nums); i++ {
				// Needs to be two lines, otherwise go re-uses some pointers
				// and we get some
				nums := append([]int{}, c.Nums[:i]...)
				nums = append(nums, c.Nums[i+1:]...)

				candidates = append(candidates, Candidate{Type: DERIVED, Nums: nums, Line: c.Line})
			}
			continue
		}

		if c.Type == ORIGINAL {
			safeCount++
		}

		safeLines[c.Line] = true
	}

	fmt.Println("Part 1:", safeCount)
	fmt.Println("Part 2:", len(safeLines))
}
