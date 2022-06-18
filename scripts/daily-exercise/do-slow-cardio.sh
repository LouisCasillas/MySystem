. utilities.sh

beginning_announcement "Time for slow cardio!" "" 8

SETS=15
SLOW_COUNT=60

for ((i=0;i<$SETS;i++))
do
	halfway_encouragement
	last_set_message

	write "Set: $(( $i + 1 )) / $SETS"
	
	say "SLOW"
	countdown "$SLOW_COUNT" "yes" 5
done

add_checkmark_to_readme $SLOW_CARDIO_COLUMN

play_medium "$FINISH_SOUND"
