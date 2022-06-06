. utilities.sh

TIME_PER_EXERCISE="25"
REPS_PER_EXERCISE="5"

TIME_FILE="exercises-for-time.txt"
REP_FILE="exercises-for-reps.txt"

beginning_announcement "Ok time for daily exercises!" "Get your hand squeezers, yoga blocks, and ab wheel." 8

say "Beginning exercises for time"

cat "$TIME_FILE" | while read exercise; do
  say "$exercise"
  countdown "$TIME_PER_EXERCISE" "yes"
done

say "Beginning exercises for reps. Hit any key after completing each exercise."

cat "$REP_FILE" | while read exercise; do

  write "Set: $(( $i + 1 )) / $SETS"

  say "$exercise"
  countdown "$TIME_PER_EXERCISE" "yes"

  read -n 1
done

play "$FINISH_SOUND"
