#!/bin/bash

# Script used to prune empty directories and directories with single files

# Before:
# dir1/dir2/file1
# dir1/file2
# dir1/dir3/

# After:
# dir1/file1
# dir1/file2

debug=1

tmp_file="$(mktemp)"

[ $debug -ge 1 ] && echo -n "Creating list of directories... "
find . -depth -type d -not \( -iname ".*" \) > "$tmp_file"
[ $debug -ge 1 ] && echo "done"
[ $debug -ge 1 ] && echo "Total directories found: $(wc -l "$tmp_file" | cut -f1 -d' ')"

num_of_pruned=0

# depth first directory finder
while read dir; do

	[ $debug -ge 2 ] && echo "Checking dir: $dir"

	# check for the number of files in this directory
	num_of_files="$(ls -A "$dir" | wc -l)"

	[ $debug -ge 2 ] && echo "Found (n) files: $num_of_files"

	# if the current directory is empty then delete it
	if [[ "$num_of_files" == "0" ]]; then
		[ $debug -ge 1 ] && echo "Found empty directory.  Deleting: $dir"
		rm -rf "$dir"

		(( num_of_pruned++ ))
	else
		# if only one file in this directory move the file to the parent directory and delete the current directory
		if [[ "$num_of_files" == "1" ]]; then
			[ $debug -ge 1 ] && echo "Found single file directory.  Moving file to parent directory..."

			mv "$dir"/* "$dir"/..

			[ $debug -ge 1 ] && echo "Found empty directory.  Deleting: $dir"
			rm -rf "$dir"

			(( num_of_pruned++ ))
		fi
	fi

done < "$tmp_file"

rm "$tmp_file"
			
[ $debug -ge 1 ] && echo "Total directories pruned: $num_of_pruned"
