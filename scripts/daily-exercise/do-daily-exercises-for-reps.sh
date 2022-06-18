. utilities.sh

TIME_PER_EXERCISE="15"

REP_FILE="exercises-for-reps.txt"

readarray -t rep_exercises < "$REP_FILE"

beginning_announcement "Time for daily exercises for reps!" "Get your hand squeezers, yoga blocks, and ab wheel." 8

SETS="${#rep_exercises[@]}"
i=0

# set the for loop to break on newlines instead of spaces
_IFS="$IFS"
IFS="$(echo -e '\n\b')"
for exercise in ${rep_exercises[@]}; do
	encouragement

	write "Set: $(( $i + 1 )) / $SETS"

	say_loud "$exercise"
	sleep 0.25
	say_loud "$exercise"

	countdown "$TIME_PER_EXERCISE" "yes" 5

	(( i++ ))

	if [[ "$i" -lt "$SETS" ]]; then
		say_loud "Press any key"
		read -n 1
	fi
done
IFS="$_IFS"

add_checkmark_to_readme $DAILY_FOR_REPS_COLUMN

play_medium "$FINISH_SOUND"
