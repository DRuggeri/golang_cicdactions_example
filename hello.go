package main

import (
	"fmt"

	"gopkg.in/alecthomas/kingpin.v2"
)

var Version = "testing"
var Commit = "local"

func main() {
	kingpin.Version(Version)
	kingpin.HelpFlag.Short('h')
	kingpin.Parse()

	fmt.Printf("Hello from '%s' '%s'\n", Version, Commit)
}
