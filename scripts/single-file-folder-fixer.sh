#!/bin/bash

find . -depth -type d > list-of-dirs.txt

# depth first directory finder
while read dir; do

	#echo "---Checking dir: $dir"

	# check for the number of files in this directory
	num_of_files="$(ls "$dir" | wc -l)"

	#echo "Found (n) files: $num_of_files"

	# if the current directory is empty then delete it
	if [[ "$num_of_files" == "0" ]]; then
		echo "--- Found empty directory"
		rm -rf "$dir"
	else
		# if only one file in this directory move the file to the parent directory and delete the current directory
		if [[ "$num_of_files" == "1" ]]; then
			echo "--- Found single file directory"

			mv "$dir"/* "$dir"/..

			rm -rf "$dir"

		fi
	fi


done < list-of-dirs.txt


rm list-of-dirs.txt
