#!/bin/bash

total_days="$1"

if [[ -z "$total_days" ]]; then
	total_days="6"
fi

exercise_count_total_dir="$HOME/.exercise/exercise-counts"

find -L "$exercise_count_total_dir" -type f |
	while read exercise_count_total_file; do
		echo "-> $exercise_count_total_file"
		reps="$(head -n 1 "$exercise_count_total_file")"
		total="$(echo "$reps" | bc)"
		start_date="$(date -d "$total_days days ago" +%Y-%m-%d)"
		end_date="$(date +%Y-%m-%d)"
		total="$start_date to $end_date : $total : $reps"
			
		(echo "0"; echo "$total"; tail -n+2 "$exercise_count_total_file") > "$exercise_count_total_file.tmp"
		mv "$exercise_count_total_file.tmp" "$exercise_count_total_file"

		break
	done
