. utilities.sh

beginning_announcement "Ok time for box breathing!" "Sit down." 8

SETS=15
IN_COUNT=6
HOLD_COUNT=10
OUT_COUNT=7

for ((i=0;i<$SETS;i++))
do
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
