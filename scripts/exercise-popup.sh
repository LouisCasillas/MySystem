#!/bin/bash

popup_program="/usr/bin/zenity"
popup_timeout="30"

play_sound=1
sound_program="/usr/bin/mpv --really-quiet"
sound_file="$HOME/.system-sounds/gong.mp3"

exercise_list="$HOME/.exercise/exercise-list.txt"
exercise="burpee"

if [ -f "$exercise_list" ]; then
	exercise="$(shuf "$exercise_list" | head -n1)"
fi

exercise_max_count=8
exercise_min_count=3
exercise_count=$(( ($RANDOM % $exercise_max_count) + $exercise_min_count ))
exercise_count_total_dir="$HOME/.exercise/exercise-counts"
exercise_count_total_file="$exercise_count_total_dir/$(echo "$exercise" | sed -e 's/ /-/g')-total.txt"

if [ ! -d "$exercise_count_total_dir" ]; then
	mkdir -p "$exercise_count_total_dir"
fi

if [ $play_sound -eq 1 ]; then
	$sound_program "$sound_file"
fi

$popup_program --no-wrap --info --title="Exercise!" --text="Time to exercise!" --display=:0.0

echo "Do $exercise_count $exercise!"

$popup_program --no-wrap --timeout="$popup_timeout" --question --ok-label "Did them!" --title="Exercise!" --text="Do $exercise_count $exercise!" --display=:0.0

if [ $? -eq 0 ]; then
	if [ -f "$exercise_count_total_file" ]; then
		total="$(head -n 1 "$exercise_count_total_file")+"
	else
		total=""
	fi

	(echo "$total""$exercise_count"; tail -n+2 "$exercise_count_total_file" 2>/dev/null) > "$exercise_count_total_file.tmp"
	mv "$exercise_count_total_file.tmp" "$exercise_count_total_file"
fi
