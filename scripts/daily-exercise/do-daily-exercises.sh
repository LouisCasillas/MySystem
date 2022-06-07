. utilities.sh

TIME_PER_EXERCISE="25"
REPS_PER_EXERCISE="5"

TIME_FILE="exercises-for-time.txt"
REP_FILE="exercises-for-reps.txt"

beginning_announcement "Ok time for daily exercises!" "Get your hand squeezers, yoga blocks, and ab wheel." 8

say "Beginning exercises for time"

SETS="$(wc -l $TIME_FILE | cut -f1 -d' ')"
MID_SET="$(( $SETS / 2 ))"
LAST_SET="$(( $SETS - 1 ))"
i=0
cat "$TIME_FILE" | while read exercise; do
  if [[ "$i" -eq "$MID_SET" ]]; then
    say "$HALFWAY_MESSAGE"
  fi

  write "Set: $(( $i + 1 )) / $SETS"

  say "$exercise"
  countdown "$TIME_PER_EXERCISE" "yes"

  (( i++ ))
done

say "Beginning exercises for reps. Hit any key after completing each exercise."

SETS="$(wc -l $REP_FILE | cut -f1 -d' ')"
MID_SET="$(( $SETS / 2 ))"
LAST_SET="$(( $SETS - 1 ))"
i=0
cat "$REP_FILE" | while read exercise; do
  if [[ "$i" -eq "$MID_SET" ]]; then
    say "$HALFWAY_MESSAGE"
  fi

  write "Set: $(( $i + 1 )) / $SETS"

  say "$exercise"
  countdown "$TIME_PER_EXERCISE" "yes"

  (( i++ ))

  read -n 1 </dev/tty
done

play "$FINISH_SOUND"
