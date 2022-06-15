. utilities.sh

TIME_PER_EXERCISE="25"

TIME_FILE="exercises-for-time.txt"

readarray -t time_exercises < "$TIME_FILE"

beginning_announcement "Time for daily exercises for time!" "Get boxing gloves." 8

SETS="$(wc -l $TIME_FILE | cut -f1 -d' ')"
MID_SET="$(( $SETS / 2 ))"
LAST_SET="$(( $SETS - 1 ))"
i=0

# set the for loop to break on newlines instead of spaces
ORIGINAL_IFS="$IFS"
IFS="$(echo -e '\n\b')"
for exercise in ${time_exercises[@]}; do
	halfway_encouragement

	write "Set: $(( $i + 1 )) / $SETS"

	say_loud "$exercise"
	sleep 0.25
	say_loud "$exercise"

	countdown "$TIME_PER_EXERCISE" "yes" 5

	(( i++ ))
done
IFS="$ORIGINAL_IFS"

play_medium "$FINISH_SOUND"
