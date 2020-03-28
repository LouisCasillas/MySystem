#!/bin/bash

current_dir="$(pwd)"

find . -type f \( -not -name "*.md" -and -not -name "*.sh" \) |
	sed -e 's@^./@@g' |
	while read file; do
		base_dir="$(dirname "$file")"
		if [[ "$base_dir" != "." ]]; then
			mkdir -p ~/$base_dir
		fi

		ln -s -n -f "$current_dir/$file" ~/$file
	done
