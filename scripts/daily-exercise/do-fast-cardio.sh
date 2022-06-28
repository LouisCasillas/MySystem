. utilities.sh

read -p 'What exercise are you doing for cardio? ' type_of_cardio

beginning_announcement "Time for fast cardio!" "" 8

SETS=3
FAST_COUNT=6
SLOW_COUNT=55

for ((i=0;i<$SETS;i++))
do
	halfway_encouragement
	last_set_message

	print_set

	say_medium "SLOW"
	countdown "$SLOW_COUNT" "yes" 5

	say_super_loud "FAST"
	play_super_loud "$BEEP_SOUND"

	countdown "$FAST_COUNT" "yes"
done

add_checkmark_to_readme $FAST_CARDIO_README_COLUMN "$type_of_cardio"

play_medium "$FINISH_SOUND"
