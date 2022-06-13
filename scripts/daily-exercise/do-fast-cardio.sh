. utilities.sh

beginning_announcement "Time for fast cardio!" "" 8

SETS=3
MID_SET="$(( $SETS / 2 ))"
LAST_SET="$(( $SETS - 1 ))"
FAST_COUNT=6
SLOW_COUNT=55

for ((i=0;i<$SETS;i++))
do
	halfway_encouragement
	last_rep_message

	write "Set: $(( $i + 1 )) / $SETS"

	say_medium "SLOW"
	countdown "$SLOW_COUNT" "yes" 5

	say_super_loud "FAST"
	play_super_loud "$BEEP_SOUND"
	countdown "$FAST_COUNT" "yes"
done

play_medium "$FINISH_SOUND"
