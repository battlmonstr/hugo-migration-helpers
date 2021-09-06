#!/bin/bash

repo="$1"
version1="$2"
version2="$3"
scriptDir=`dirname "$0"`

function generate_clean {
	rm -rf "$scriptDir/public-$1"
	rm "$repo/hugo"
}

function generate {
	generate_clean $1
	cp $scriptDir/releases/$1/hugo "$repo/hugo"
	out="$scriptDir/public-$1"
	pushd "$repo"
	mkdir public
	./build.sh install public
	popd
	mv "$repo/public" "$out"
	#rm "$repo/hugo"
}

function compare {
	diff -r --ignore-space-change --ignore-all-space --ignore-blank-lines -q "$scriptDir/public-$1" "$scriptDir/public-$2"
}

function gitinit {
	v1=$1
	v2=$2
	repo="$scriptDir/public"
	rm -rf "$repo"
	git init "$repo"

	cp -R "$scriptDir/public-$v1/" "$repo"
	git -C "$repo" add .
	git -C "$repo" commit -m "$v1"

	mv "$repo/.git" "$scriptDir/git1"
	rm -rf "$repo"
	mkdir "$repo"
	mv "$scriptDir/git1" "$repo/.git"
	
	cp -R "$scriptDir/public-$v2/" "$repo"
	git -C "$repo" add .
	git -C "$repo" commit -m "$v2"
}

generate $version1
generate $version2
compare $version1 $version2
gitinit $version1 $version2
