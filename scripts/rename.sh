#!/bin/bash

start_num="$1"
tmp_file_list="$(mktemp)"

if [[ "$start_num" == "" ]]; then 
	echo "Must pass the starting number!"
	echo "$0 <starting number>"
	exit 1
fi

function trap_exit()
{
	echo 'goodbye...'
	exit 0
}

trap trap_exit SIGINT

find . -type f -print0 | \
	sort --zero-terminated --field-separator='/' --key=2 --numeric-sort > "$tmp_file_list"

xargs -a "$tmp_file_list" -0 -n1 echo | \
	while read old_filename; do 

		extension="$(echo "$old_filename" | awk -F. '{if (NF > 2) {print "."$NF}}')"

		while true; do
			new_filename="$start_num""$extension"

			if [[ (! -f "$new_filename") || ("$old_filename" -ef "$new_filename") ]]; then
				break
			fi

			((start_num++));
		done
		
		mv --no-clobber --verbose -- "$old_filename" "$new_filename"

		((start_num++));
	done

rm "$tmp_file_list"
