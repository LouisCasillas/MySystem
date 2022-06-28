. utilities.sh

TIME_PER_EXERCISE="25"

TIME_FILE="exercises-for-time.txt"

readarray -t time_exercises < "$TIME_FILE"

beginning_announcement "Time for daily exercises for time!" "Get boxing gloves." 8

SETS="${#time_exercises[@]}"
i=0

# set the for loop to break on newlines instead of spaces
_IFS="$IFS"
IFS="$(echo -e '\n\b')"
for exercise in ${time_exercises[@]}; do
	halfway_encouragement

	print_set

	say_loud "$exercise"
	sleep 0.25
	say_loud "$exercise"

	countdown "$TIME_PER_EXERCISE" "yes" 5

	(( i++ ))
done
IFS="$_IFS"

add_checkmark_to_readme $DAILY_FOR_TIME_README_COLUMN

play_medium "$FINISH_SOUND"
