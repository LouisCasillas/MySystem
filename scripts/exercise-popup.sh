#!/bin/bash

if [ ! -f "$HOME/.exercise/stop" ]; then

	popup_program="/usr/bin/zenity"

	play_sound=1
	sound_program="/usr/bin/mpv --really-quiet"
	sound_file="$HOME/.system-sounds/gong.mp3"

	exercise_list="$HOME/.exercise/exercise-list.txt"
	exercise="burpee"

	if [ -f "$exercise_list" ]; then
		exercise="$(sed -e 's/#.*$//g' -e 's/^\s*$//g' "$exercise_list" | sed '/^$/d' | shuf | head -n1)"
	fi

	exercise_min_count=3
	exercise_max_count=8

	if [ -f "$HOME/.exercise/min" ]; then
		exercise_min_count="$(cat "$HOME/.exercise/min")"
	fi

	if [ -f "$HOME/.exercise/max" ]; then
		exercise_max_count="$(cat "$HOME/.exercise/max")"
	fi

	exercise_delta_count=$(( $exercise_max_count - $exercise_min_count ))

	exercise_count=$(( ($RANDOM % $exercise_delta_count) + $exercise_min_count ))
	exercise_count_total_dir="$HOME/.exercise/exercise-counts"
	exercise_count_total_file="$exercise_count_total_dir/$(echo "$exercise" | sed -e 's/ /-/g')-total.txt"

	if [ ! -d "$exercise_count_total_dir" ]; then
		mkdir -p "$exercise_count_total_dir"
	fi

	if [[ $play_sound -eq 1 && ! -f "$HOME/.exercise/quiet" ]]; then
		$sound_program "$sound_file"
	fi

	$popup_program --no-wrap --info --title="Exercise!" --text="Time to exercise!" --display=:0.0 &>/dev/null

	echo "Do $exercise_count $exercise!"

	$popup_program --no-wrap --question --ok-label "Did them!" --title="Exercise!" --text="Do $exercise_count $exercise!" --display=:0.0 &>/dev/null

	if [ $? -eq 0 ]; then
		if [ -f "$exercise_count_total_file" ]; then
			total="$(head -n 1 "$exercise_count_total_file")+"
		else
			total=""
		fi

		(echo "$total""$exercise_count"; tail -n+2 "$exercise_count_total_file" 2>/dev/null) > "$exercise_count_total_file.tmp"
		mv "$exercise_count_total_file.tmp" "$exercise_count_total_file"
	fi
fi
