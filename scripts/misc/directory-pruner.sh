#!/bin/bash

# Script used to prune empty directories and directories with single files

# Before:
# dir1/dir2/file1
# dir1/file2
# dir1/dir3/

# After:
# dir1/file1
# dir1/file2

tmp_file="$(mktemp)"
find . -depth -type d > "$tmp_file"

# depth first directory finder
while read dir; do

	#echo "---Checking dir: $dir"

	# check for the number of files in this directory
	num_of_files="$(ls -A "$dir" | wc -l)"

	#echo "Found (n) files: $num_of_files"

	# if the current directory is empty then delete it
	if [[ "$num_of_files" == "0" ]]; then
		echo "--- Found empty directory.  Deleting..."
		rm -rf "$dir"
	else
		# if only one file in this directory move the file to the parent directory and delete the current directory
		if [[ "$num_of_files" == "1" ]]; then
			echo "--- Found single file directory.  Moving file to parent directory..."

			mv "$dir"/* "$dir"/..

			echo "--- Directory is now empty.  Deleting..."
			rm -rf "$dir"
		fi
	fi


done < "$tmp_file"

rm "$tmp_file"
