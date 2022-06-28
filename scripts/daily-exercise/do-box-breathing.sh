. utilities.sh

beginning_announcement "Time for box breathing!" "Stand up." 8

SETS=15
IN_COUNT=6
HOLD_COUNT=6
OUT_COUNT=6

for ((i=0;i<$SETS;i++))
do
	halfway_encouragement

	print_set

	say_loud "IN"
	countdown "$IN_COUNT"

	say_loud "HOLD"
	countdown "$HOLD_COUNT"

	say_loud "OUT"
	countdown "$IN_COUNT"

	say_loud "HOLD"
	countdown "$HOLD_COUNT"
done

add_checkmark_to_readme $BOX_BREATHING_README_COLUMN

play_medium "$FINISH_SOUND"
