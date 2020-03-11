#!/bin/bash

query="$1"

if [[ "$query" == "" ]]; then 
	echo "Must pass the search query!"
	echo "$0 <search query>"
	exit 1
fi

function trap_exit()
{
	echo 'goodbye...'
	exit 0
}

trap trap_exit SIGINT

for query in "$@"
do
	echo "Query: $query"
	youtube-dl -f18 -c -i --restrict-filenames --write-description "https://youtube.com/results?search_query=$query"
done
