. utilities.sh

beginning_announcement "Ok time for I M S T breathing!" "Get your mouth cover and sit down." 8

SETS=50
MID_SET="$(( $SETS / 2 ))"
LAST_SET="$(( $SETS - 1 ))"
IN_COUNT=9
OUT_COUNT=3

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
    say "OUT"
    countdown "$OUT_COUNT"
done

play "$FINISH_SOUND"

