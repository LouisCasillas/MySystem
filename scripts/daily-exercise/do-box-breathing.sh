. utilities.sh

beginning_announcement "Time for box breathing!" "Stand up." 8

SETS=15
MID_SET="$(( $SETS / 2 ))"
LAST_SET="$(( $SETS - 1 ))"
IN_COUNT=6
HOLD_COUNT=6
OUT_COUNT=6

for ((i=0;i<$SETS;i++))
do
    if [[ "$i" -eq "$MID_SET" ]]; then
      say_medium "$HALFWAY_MESSAGE"
    else
      if [[ "$i" -eq "$LAST_SET" ]]; then
        say_medium "$LAST_SET_MESSAGE"
      fi
    fi

    write "Set: $(( $i + 1 )) / $SETS"

    say_loud "IN"
    countdown "$IN_COUNT"

    say_loud "HOLD"
    countdown "$HOLD_COUNT"

    say_loud "OUT"
    countdown "$IN_COUNT"

    say_loud "HOLD"
    countdown "$HOLD_COUNT"

done

play_medium "$FINISH_SOUND"
