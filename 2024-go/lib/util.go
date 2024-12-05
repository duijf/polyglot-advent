package lib

import (
	"log"
	"strconv"
)

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

func MapSlice[T any, U any](slice []T, fn func(T) U) []U {
	result := make([]U, len(slice))
	for idx, val := range slice {
		result[idx] = fn(val)
	}
	return result
}

func ParseIntOrExit(val string) int {
	num, err := strconv.Atoi(val)
	ExitOnErr("%v", err)
	return num
}

func SplitSlice[T comparable](slice []T, element T) ([]T, []T) {
	for i, v := range slice {
		if v == element {
			return slice[:i], slice[i+1:]
		}
	}
	return slice, nil
}
