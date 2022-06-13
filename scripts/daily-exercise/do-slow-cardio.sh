. utilities.sh

beginning_announcement "Time for slow cardio!" "" 8

SETS=15
MID_SET="$(( $SETS / 2 ))"
LAST_SET="$(( $SETS - 1 ))"
SLOW_COUNT=60

for ((i=0;i<$SETS;i++))
do
	halfway_encouragement
	last_rep_message

	write "Set: $(( $i + 1 )) / $SETS"
	
	say "SLOW"
	countdown "$SLOW_COUNT" "yes" 1
done

play_medium "$FINISH_SOUND"
