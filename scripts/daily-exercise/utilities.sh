BEEP_SOUND="beep.wav"
FINISH_SOUND="applause.wav"

function write()
{
  if [[ "$(which banner 2>/dev/null)" != "" ]]; then
    banner -C -c '%' -w "$COLUMNS" "$1" 2>/dev/null
  else
    if [[ "$(which figlet 2>/dev/null)" != "" ]]; then
      figlet -w "$COLUMNS" -c "$1" 2>/dev/null
    else
      echo "$1"
    fi
  fi
}

function speak()
{
  #espeak -z -p 0.4 -s 150 -g 11 -v en-us "$1" --stdout | aplay -c 2 &>/dev/null
  espeak -z -p 0.4 -s 150 -g 11 -v en-us "$1" &>/dev/null
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
  total_time="$1"
  want_beep="$2"
  speaking_time="$3"
  
  if [[ "$speaking_time" == "" ]]; then
    seconds_of_speaking="0"
  else
    seconds_of_speaking="$((1000 * ($total_time - $speaking_time - 1)))"
  fi
    
  initial_start_time=$(date +%s.%3N)

  for ((_i=$total_time;_i>0;_i--))
  do
    start_time=$(date +%s.%3N)
    
    total_end_time=$(date +%s.%3N)
    total_elapsed="$(echo "1000 * ($total_end_time - $initial_start_time)" | bc | cut -f1 -d.)"

    if [[ "$total_elapsed" -ge "$seconds_of_speaking" ]]; then
      say "$_i"
    else
      write "$_i"
    fi

    while (true)
    do
      end_time=$(date +%s.%3N)
      elapsed="$(echo "1000 * ($end_time - $start_time)" | bc | cut -f1 -d.)"

      if [[ "$elapsed" -ge "1000" ]]; then
        break
      fi
    done
  done

  if [[ "$want_beep" ]]; then
    play "$BEEP_SOUND"
  fi
}

function warmup_speakers()
{
  play "$BEEP_SOUND"
  sleep 1
}

function beginning_announcement()
{
  exercise_announcement="$1"
  needed_equipment="$2"
  warmup_speakers
  say "$exercise_announcement"
  say "$needed_equipment"
  countdown "$3"
}
