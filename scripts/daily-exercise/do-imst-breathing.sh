. utilities.sh

beginning_announcement "Time for I M S T breathing!" "Get your mouth cover and stand up." 8

SETS=50
MID_SET="$(( $SETS / 2 ))"
LAST_SET="$(( $SETS - 1 ))"
IN_COUNT=9
OUT_COUNT=3

for ((i=0;i<$SETS;i++))
do
	halfway_encouragement

	write "Set: $(( $i + 1 )) / $SETS"

	say_loud "IN"
	countdown "$IN_COUNT"

	say_loud "OUT"
	countdown "$OUT_COUNT"
done

play_medium "$FINISH_SOUND"
