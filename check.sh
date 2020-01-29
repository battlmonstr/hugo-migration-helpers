#!/bin/bash

repo="$1"
version1="$2"
version2="$3"

function generate_clean {
	rm -rf "public-$1"
	rm "$repo/hugo"
}

function generate {
	generate_clean $1
	pushd "$repo"
	ln -s ../releases/$1/hugo hugo
	out="../public-$1"
	mkdir "$out"
	./build.sh install "$out"
	popd
}

function compare {
	diff -r --ignore-space-change --ignore-all-space --ignore-blank-lines -q "public-$1" "public-$2"
}

generate $version1
generate $version2
compare $version1 $version2
