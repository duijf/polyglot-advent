package lib

import "log"

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
