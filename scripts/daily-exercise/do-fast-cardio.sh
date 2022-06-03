. utilities.sh

beginning_announcement "Ok time for fast cardio!" "" 8

SETS=3
LAST_SET="$(( $SETS - 1 ))"
FAST_COUNT=6
SLOW_COUNT=55

for ((i=0;i<$SETS;i++))
do
    if [[ "$i" -eq "$LAST_SET" ]]; then
      say "Last round!"
    fi

    say "SLOW"
    countdown "$SLOW_COUNT" "yes" 5

    say "FAST"
    countdown "$FAST_COUNT" "yes"
done

play "$FINISH_SOUND"

