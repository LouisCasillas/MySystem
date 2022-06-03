
function write()
{
  if [[ "$(which banner 2>/dev/null)" != "" ]]; then
    banner -C -c '%' -w "$COLUMNS" "$1"
  else
    if [[ "$(which figlet 2>/dev/null)" != "" ]]; then
      figlet -w "$COLUMNS" -c "$1"
    else
      echo "$1"
    fi
  fi
}

function speak()
{
  #espeak -z -p 0.4 -s 150 -g 11 -v en-us "$1" --stdout | aplay -c 2 &>/dev/null
  espeak -z -p 0.4 -s 150 -g 11 -v en-us "$1"
}

function say()
{
  write "$1"
  speak "$1"
}


function play()
{
  if [[ "$(which aplay 2>/dev/null)" != "" ]]; then
    aplay "$1" &>/dev/null
  else
    if [[ "$(which mpv 2>/dev/null)" != "" ]]; then
      mpv "$1" &>/dev/null
    fi
  fi
}

function countdown()
{
  for ((i=$1;i>0;i--))
  {
    start_time=$(date +%s.%3N)
    say "$i"

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
  play "$BEEP_SOUND"
  sleep 1
}

BEEP_SOUND="apert.wav"
FINISH_SOUND="applause.wav"

TIME_PER_EXERCISE="25"
REPS_PER_EXERCISE="5"

TIME_FILE="exercises-for-time.txt"
REP_FILE="exercises-for-reps.txt"

warmup_speakers
say "Ok let's get ready to exercise!"
say "Get your hand squeezers, yoga blocks, and ab wheel."
countdown "8"

cat "$TIME_FILE" | while read exercise; do
  say "$exercise"
  sleep 1
  countdown "$TIME_PER_EXERCISE"
done

cat "$REP_FILE" | while read exercise; do
  say "$exercise"
  sleep 1
  countdown "$TIME_PER_EXERCISE"

  read -n 1
done

play "$FINISH_SOUND"
