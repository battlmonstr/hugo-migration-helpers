#!/bin/bash

# build the site content with 2 hugo versions
# and show files that differ

set -e

repo="$1"
version1="$2"
version2="$3"

scriptDir=$(realpath $(dirname "${BASH_SOURCE[0]}"))
siteName=$(basename "$repo")
siteOutDir="$scriptDir/public/$siteName"

function generate {
	version=$1
	pushd "$repo"
	rm -f hugo
	ln -s "$scriptDir/releases/$version/hugo" hugo
    out="$siteOutDir/$version"
    mkdir -p "$out"
	./build.sh install "$out"
	popd
}

function compare {
	diff -r --ignore-space-change --ignore-all-space --ignore-blank-lines -q "$1" "$2"
}

generate $version1
generate $version2
compare "$siteOutDir/$version1" "$siteOutDir/$version2"
