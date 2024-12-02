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
