#!/bin/bash
##15-gomod.sh: Builds Go projects using Go Modules and Go 1.11+
##@copyright GPL-2.0+
abtryexe go || ablibret

build_gomod_probe(){
	[ -f go.mod ] && [ -f go.sum ]  # go.sum is required for security reasons
}

build_gomod_build(){
	BUILD_START
	export GO111MODULE=on
	abinfo 'Note, this build type only works with Go 1.11+ modules'
	[ -f Makefile ] && abwarn "This project might be using other build tools than Go itself."
	if ! bool "$ABSHADOW"
	then
		abdie 'ABSHADOW must be set to true for this build type!'
	fi

	rm -rf abbuild
	mkdir abbuild || abdie "Failed to create $SRCDIR/abbuild"
	cd abbuild || abdie "Failed to cd $SRCDIR/abbuild"

	abinfo 'Fetching Go modules dependencies...'
	GOPATH="$SRCDIR/abgopath" go get ..
	BUILD_READY
	mkdir -p "$PKGDIR/usr/bin/"
	abinfo 'Compiling the Go module ...'
	if [[ "${CROSS:-$ARCH}" != "loongson3" ]]; then
		GOPATH="$SRCDIR/abgopath" \
			go build -buildmode=pie ${GO_BUILD_AFTER} ..
	else
		GOPATH="$SRCDIR/abgopath" \
			go build ${GO_BUILD_AFTER} ..
	fi
	find . -type f -executable -exec cp -av '{}' "$PKGDIR/usr/bin/" ';'
	BUILD_FINAL
	cd ..
}

ABBUILDS+=' gomod'
