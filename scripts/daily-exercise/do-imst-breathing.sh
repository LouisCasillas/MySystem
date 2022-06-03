. utilities.sh

beginning_announcement "Ok time for I M S T breathing!" "Get your mouth cover and sit down." 8

SETS=50
IN_COUNT=9
OUT_COUNT=3

for ((i=0;i<$SETS;i++))
do
    say "IN"
    countdown "$IN_COUNT"
    say "OUT"
    countdown "$OUT_COUNT"
done

play "$FINISH_SOUND"

