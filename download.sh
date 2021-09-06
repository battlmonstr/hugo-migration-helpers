#!/bin/bash

hugoRepoUrl="https://github.com/gohugoio/hugo"
#git clone "$hugoRepoUrl"

mkdir releases
mkdir downloads
cd downloads

#git -C ../hugo tag | while read tag
for tag in v0.54.0 v0.80.0
do
	tag=${tag:1}
	url="$hugoRepoUrl/releases/download/v${tag}/hugo_${tag}_macOS-64bit.tar.gz"
	archive=$tag.tgz

	if [[ ! -f $archive ]]
	then
		echo "$url"
		curl -L "$url" -o $archive
	fi

	if [[ -f $archive ]]
	then
		dir=../releases/$tag
		if [[ $dir != *.[0-9] ]]
		then
			dir="$dir.0"
		fi

		mkdir $dir
		tar xzf $archive -C $dir/ hugo
	fi
done
