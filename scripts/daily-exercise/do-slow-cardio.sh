. utilities.sh

beginning_announcement "Ok time for slow cardio!" "" 8

SETS=15
MID_SET="$(( $SETS / 2 ))"
LAST_SET="$(( $SETS - 1 ))"
SLOW_COUNT=60

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
    
    say "SLOW"
    countdown "$SLOW_COUNT" "yes" 1
done

play_medium "$FINISH_SOUND"
