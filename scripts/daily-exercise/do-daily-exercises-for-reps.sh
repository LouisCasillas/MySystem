. utilities.sh

TIME_PER_EXERCISE="15"

REP_FILE="exercises-for-reps.txt"

readarray -t rep_exercises < "$REP_FILE"

beginning_announcement "Time for daily exercises for reps!" "Get your hand squeezers, yoga blocks, and ab wheel." 8

SETS="$(wc -l $REP_FILE | cut -f1 -d' ')"
MID_SET="$(( $SETS / 2 ))"
LAST_SET="$(( $SETS - 1 ))"
i=0

# set the for loop to break on newlines instead of spaces
ORIGINAL_IFS="$IFS"
IFS="$(echo -e '\n\b')"
for exercise in ${rep_exercises[@]}; do
  if [[ "$i" -eq "$MID_SET" ]]; then
    say_medium "$HALFWAY_MESSAGE"
  fi

  write "Set: $(( $i + 1 )) / $SETS"

  say_loud "$exercise"
  sleep 0.25
  say_loud "$exercise"

  countdown "$TIME_PER_EXERCISE" "yes" 5

  (( i++ ))

  say_loud "Press any key"

  read -n 1
done
IFS="$ORIGINAL_IFS"

play_medium "$FINISH_SOUND"
