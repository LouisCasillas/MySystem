#!/bin/bash

current_dir="$(pwd)"

find . -type f \( -not -name "*.md" -and -not -name "*.sh" -and -not -name ".gitconfig" \) |
	sed -e 's@^./@@g' |
	while read file; do
		base_dir="$(dirname "$file")"
		mkdir -p "~/$base_dir"

		ln -s -n -f "$current_dir/$file" ~/$file
	done
