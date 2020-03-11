#!/usr/bin/bash

# trap ctrl-c
trap ctrl_c INT

function ctrl_c()
{
	echo "goodbye..."
	exit 0
}

filename="$1"
file_extension="$2"
minutes_to_split="$3"

book_name=$(echo "${filename%%.*}")
book_duration=$(ffmpeg -i "$filename" 2>&1 | grep 'Duration' | awk 'BEGIN{FS = ","} {print $1}' | awk '{print $2}')
book_duration=$(TZ=utc date -d "1970-01-01 $book_duration" +%s)

seconds_to_split=$(TZ=utc date -d "1970-01-01 00:$minutes_to_split:00" +%s)

i=1

current_start="0"
current_end="$seconds_to_split"

while [[ "$current_end" -lt "$book_duration" ]]; do

	#echo "$i) $current_start -> $current_end"
	chapter_number=$(printf "%02d" $i)
	ffmpeg -vsync 2 -i "$filename" -ss "$current_start" -to "$current_end" -vn "$book_name - $chapter_number.$file_extension" </dev/null

	i=$(($i + 1))
	current_start="$current_end"
	current_end=$(($current_end + $seconds_to_split))
done
