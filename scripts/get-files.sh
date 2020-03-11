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
	until rsync -P -r -v --remove-source-files root@192.243.108.95:"$dir" .; do
		sleep 5s
	done
done
