#!/bin/bash

# trap ctrl-c
trap ctrl_c INT
function ctrl_c()
{
	echo "goodbye..."
	exit 0
}

file="$1"

file_md5="$(md5sum "$file" | awk '{print $1}')"

grep -q "$file_md5" /root/pn/p-md5.txt
if [[ "$?" == "0" ]]; then
	rm "$file"
	echo "$file_md5" >> /root/pn/p-md5-hits.txt
else
	echo "$file_md5" >> /root/pn/p-md5.txt

	mv "$file" /root/pn/done/
fi

