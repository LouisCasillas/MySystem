
function write()
{
  banner -C -c '%' -w "$COLUMNS" "$1"
}

function speak()
{
  write "$1"
  espeak -z -p 0.4 -s 150 -g 11 -v en-us "$1" --stdout | aplay -c 2 &>/dev/null
}

function play()
{
  aplay "$1" &>/dev/null
}

function countdown()
{
  for ((i=$1;i > 0; i--))
  {
    start_time=$(date +%s.%3N)
    speak "$i"

    while (true)
    do
      end_time=$(date +%s.%3N)
      elapsed="$(echo "1000 * ($end_time - $start_time)" | bc | cut -f1 -d.)"

      if [[ "$elapsed" -ge "1000" ]]; then
        break
      fi
    done
  }

  play "$BEEP_SOUND"
}

function warmup_speakers()
{
  echo "1" | aplay -c 2 -t raw &>/dev/null
  sleep 1
}

BEEP_SOUND="apert.wav"
FINISH_SOUND="applause.wav"

TIME_PER_EXERCISE="25"
REPS_PER_EXERCISE="5"

TIME_FILE="exercises-for-time.txt"
REP_FILE="exercises-for-reps.txt"

warmup_speakers
speak "Ok let's get ready to exercise!"
speak "Get your hand squeezers, yoga blocks, and ab wheel."
countdown "8"

cat "$TIME_FILE" | while read exercise; do
  speak "$exercise"
  sleep 1
  countdown "$TIME_PER_EXERCISE"
done

cat "$REP_FILE" | while read exercise; do
  speak "$exercise"
  sleep 1
  countdown "$TIME_PER_EXERCISE"

  read -n 1
done

play "$FINISH_SOUND"
