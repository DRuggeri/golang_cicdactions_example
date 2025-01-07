package main

import (
	"fmt"

	"github.com/alecthomas/kingpin"
)

var Version = "testing"
var Commit = "local"

func main() {
	kingpin.Version(Version)
	kingpin.HelpFlag.Short('h')
	kingpin.Parse()

	fmt.Printf("Hello from '%s' '%s'\n", Version, Commit)
}

func Hello() string {
	return fmt.Sprintf("Hello from '%s' '%s'", Version, Commit)
}
