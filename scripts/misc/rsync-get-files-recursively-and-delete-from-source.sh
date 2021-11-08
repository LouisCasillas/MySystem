#!/bin/bash

dir="$1"

if [[ "$dir" == "" ]]; then 
	echo "Must pass the remote directory!"
	echo "$0 <remote directory with files>"
	exit 1
fi

function trap_exit()
{
	echo 'goodbye...'
	exit 0
}

trap trap_exit SIGINT

while true; do 

	# get files from source and delete them from source once copied successfully
	# if you want to make sure all symlinks and execution bits are copied too then look at option -a
	until rsync -P -v -r --remove-source-files root@192.243.108.95:"$dir" .; do
		sleep 5s
	done

	# delete empty directories on source
	ssh root@192.243.108.95:"$dir" "find . -type d -empty -delete
done
