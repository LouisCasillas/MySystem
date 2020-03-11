#!/bin/bash
# Author: http://crunchbang.org/forums/viewtopic.php?id=38748#p414992
# m4bronto

#     Chapter #0:0: start 0.000000, end 1290.013333
#       first   _     _     start    _     end

# trap ctrl-c
trap ctrl_c INT

function ctrl_c()
{
	echo "goodbye..."
	exit 0
}

filename="$1"
file_extension="$2"

book_name=$(echo "${filename%%.*}")
ffmpeg -i "$filename" 2> tmp.txt

i=1

while read -r first _ _ start _ end; do
  if [[ $first = Chapter ]]; then
    read  # discard line with Metadata:
    read _ _ chapter_title

    chapter_number=$(printf "%02d" $i)
    ffmpeg -vsync 2 -i "$filename" -ss "${start%?}" -to "$end" -vn "$book_name - $chapter_number - $chapter_title.$file_extension" </dev/null

    i=$(($i + 1))

  fi
done <tmp.txt

rm tmp.txt
