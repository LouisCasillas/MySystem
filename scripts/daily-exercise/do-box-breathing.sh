	utilities.sh

	ginning_announcement "Time for box breathing!" "Stand up." 8

	TS=15
	D_SET="$(( $SETS / 2 ))"
	ST_SET="$(( $SETS - 1 ))"
	_COUNT=6
	LD_COUNT=6
	T_COUNT=6

	r ((i=0;i<$SETS;i++))
	
	halfway_encouragement

	write "Set: $(( $i + 1 )) / $SETS"

	say_loud "IN"
	countdown "$IN_COUNT"

	say_loud "HOLD"
	countdown "$HOLD_COUNT"

	say_loud "OUT"
	countdown "$IN_COUNT"

	say_loud "HOLD"
	countdown "$HOLD_COUNT"
	ne

	ay_medium "$FINISH_SOUND"
