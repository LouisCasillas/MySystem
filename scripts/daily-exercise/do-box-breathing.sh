. utilities.sh

beginning_announcement "Ok time for box breathing!" "Sit down." 8

SETS=15
MID_SET="$(( $SETS / 2 ))"
LAST_SET="$(( $SETS - 1 ))"
IN_COUNT=6
HOLD_COUNT=10
OUT_COUNT=7

for ((i=0;i<$SETS;i++))
do
    if [[ "$i" -eq "$MID_SET" ]]; then
      say "Halfway there!  Keep going!"
    else
      if [[ "$i" -eq "$LAST_SET" ]]; then
        say "Last round!"
      fi
    fi

    write "Set: $(( $i + 1 )) / $SETS"

    say "IN"
    countdown "$IN_COUNT"
    say "HOLD"
    countdown "$HOLD_COUNT"
    say "OUT"
    countdown "$IN_COUNT"
    say "HOLD"
    countdown "$HOLD_COUNT"
done

play "$FINISH_SOUND"
