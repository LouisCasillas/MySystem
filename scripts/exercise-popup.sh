#!/bin/bash

popup_program="/usr/bin/zenity"

play_sound=0
sound_program="/usr/bin/mpv --really-quiet"
sound_file="$HOME/system-sounds/gong.mp3"

exercise_list="$HOME/.exercise_list.txt"
exercise="burpee"

if [ -f "$exercise_list" ]; then
	exercise="$(shuf "$exercise_list" | head -n1)"
fi

exercise_max_count=6
exercise_min_count=1
exercise_count=$(( ($RANDOM % $exercise_max_count) + $exercise_min_count ))
exercise_count_total_dir="$HOME/.exercise_counts"
exercise_count_total_file="$exercise_count_total_dir/$exercise-total.txt"


if [ ! -d "$exercise_count_total_dir" ]; then
	mkdir -p "$exercise_count_total_dir"
fi

if [ $play_sound -eq 1 ]; then
	$sound_program "$sound_file"
fi

if [ -f "$exercise_count_total_file" ]; then
	total="$(cat "$exercise_count_total_file")"
else
	total=0
fi

$popup_program --no-wrap --question --ok-label "Did them!" --title="Exercise!" --text="Do $exercise_count $exercise!\nTotal: $total" --display=:0.0

if [ $? -eq 0 ]; then
	total=$(( total + $exercise_count ))
	echo "$total" > "$exercise_count_total_file"
fi
