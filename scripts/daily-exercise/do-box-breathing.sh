. utilities.sh

beginning_announcement "Ok time for box breathing!" "Sit down." 8

SETS=15
MID_SET="$(( $SETS / 2 ))"
LAST_SET="$(( $SETS - 1 ))"
IN_COUNT=6
HOLD_COUNT=8
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

    say "IN"
    countdown "$IN_COUNT" "yes" 0

    say "HOLD"
    countdown "$HOLD_COUNT" "yes" 0

    say "OUT"
    countdown "$IN_COUNT" "yes" 0

    say "HOLD"
    countdown "$HOLD_COUNT" "yes" 0

done

play_medium "$FINISH_SOUND"
