package main

import "testing"

func TestHello(t *testing.T) {
	got := Hello()
	want := "Hello from 'testing' 'local'"

	if got != want {
		t.Errorf("got %q want %q", got, want)
	}
}
