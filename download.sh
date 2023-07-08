#!/bin/bash

# download all hugo binaries
# $1 - version filter regex

set -e

tagFilterRegex="$1"
hugoRepoUrl="https://github.com/gohugoio/hugo"

if [[ ! -d hugo ]]
then
	git clone "$hugoRepoUrl"
fi

mkdir -p releases
mkdir -p downloads
cd downloads

git -C ../hugo tag | grep "$tagFilterRegex" | while read tag
do
	tag=${tag:1}
	archive=$tag.tgz

	# until v0.101.0 except v0.89.0
	# platform=macOS-64bit
	# v0.89.0
	# platform=macOS-all
	# from v0.102.0 to v0.102.3
	# platform=macOS-universal
	# from v0.103.0
	platform=darwin-universal

	url="$hugoRepoUrl/releases/download/v${tag}/hugo_${tag}_${platform}.tar.gz"

	if [[ ! -f $archive ]]
	then
		echo "$url"
		curl -L "$url" -o $archive
	fi

	dir=../releases/$tag
	if [[ $dir != *.[0-9] ]]
	then
		dir="$dir.0"
	fi

	if [[ -f $archive ]] && [[ ! -d $dir ]]
	then

		mkdir $dir
		tar xzf $archive -C $dir/ hugo
	fi
done
