BEEP_SOUND="beep.wav"
FINISH_SOUND="applause.wav"

# TODO:
# move encouragement messages into utilities
# streamline other files to remove duplicate code for loops and others if possible
# check if a key has already been buffered and don't play press any key message 
# add extra exercise script
# bug: if I ctrl-z it starts counting out loud no matter the time 

# 0=silence, 100=no change, 200=doubled volume
_VOLUME="25"
VOLUME="25"
MEDIUM_VOLUME="50"
LOUD_VOLUME="100"
SUPER_LOUD_VOLUME="150"

# speech in words per minute
_SPEECH_SPEED="225"
SPEECH_SPEED="225"
SLOW_SPEECH_SPEED="175"

README_FILENAME="Readme.md"
BOX_BREATHING_COLUMN=2
IMST_BREATHING_COLUMN=3
FAST_CARDIO_COLUMN=4
SLOW_CARDIO_COLUMN=5
DAILY_FOR_TIME_COLUMN=6
DAILY_FOR_REPS_COLUMN=7
OTHER_EXERCISE_COLUMN=8

HALFWAY_MESSAGE="Halfway there! Keep going!"
LAST_SET_MESSAGE="Last round!"

function setVolume()
{
	VOLUME="$1"
}

function resetVolume()
{
	VOLUME="$_VOLUME"
}

function setSpeechSpeed()
{
	SPEECH_SPEED="$1"
}

function resetSpeechSpeed()
{
	SPEECH_SPEED="$_SPEECH_SPEED"
}

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
	espeak -a "$VOLUME" -z -p 0.4 -s "$SPEECH_SPEED" -g 11 -v en-us "$1" &>/dev/null
}

function say()
{
	write "$1"
	speak "$1"
}

function say_medium()
{
	setVolume "$MEDIUM_VOLUME"
	setSpeechSpeed "$SLOW_SPEECH_SPEED"
	write "$1"
	speak "$1"
	resetVolume
	resetSpeechSpeed
}

function say_loud()
{
	setVolume "$LOUD_VOLUME"
	setSpeechSpeed "$SLOW_SPEECH_SPEED"
	write "$1"
	speak "$1"
	resetVolume
	resetSpeechSpeed
}

function say_super_loud()
{
	setVolume "$SUPER_LOUD_VOLUME"
	setSpeechSpeed "$SLOW_SPEECH_SPEED"
	write "$1"
	speak "$1"
	resetVolume
	resetSpeechSpeed
}

function play()
{
	if [[ "$(which mpv 2>/dev/null)" != "" ]]; then
		mpv --volume="$VOLUME" "$1" &>/dev/null
	else
		if [[ "$(which aplay 2>/dev/null)" != "" ]]; then
			aplay "$1" &>/dev/null
		fi
	fi
}

function play_medium()
{
	setVolume "$MEDIUM_VOLUME"
	play "$1"
	resetVolume
}

function play_loud()
{
	setVolume "$LOUD_VOLUME"
	play "$1"
	resetVolume
}

function play_super_loud()
{
	setVolume "$SUPER_LOUD_VOLUME"
	play "$1"
	resetVolume
}

function countdown()
{
	# trap ctrl-c so the user can immediately end the countdown
	trap go_to_next_exercise INT
	function go_to_next_exercise()
	{
		_i=0
		want_beep=""
	}

	total_time="$1"
	want_beep="$2"
	halfway_time="$(( $total_time / 2))"

	# only start speaking the countdown numbers once this number is reached
	speaking_time="$3"
	
	if [[ "$speaking_time" == "" ]]; then
		seconds_of_speaking="0"
	else
		seconds_of_speaking="$((1000 * ($total_time - $speaking_time)))"
	fi

	initial_start_time=$(date +%s.%3N)

	for ((_i=$total_time;_i>0;_i--))
	do
		start_time=$(date +%s.%3N)

		total_end_time=$(date +%s.%3N)
		total_elapsed="$(echo "1000 * ($total_end_time - $initial_start_time)" | bc | cut -f1 -d.)"

		if [[ "$want_beep" == "yes" ]]; then
			if [[ "$_i" -eq "$halfway_time" ]]; then
					setVolume "$MEDIUM_VOLUME"
					play "$BEEP_SOUND"
					resetVolume
			fi
		fi

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

	if [[ "$want_beep" == "yes" ]]; then
		setVolume "$LOUD_VOLUME"
		play "$BEEP_SOUND"
		resetVolume
	fi

	trap - INT
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

	setVolume "$LOUD_VOLUME"
	setSpeechSpeed "$SLOW_SPEECH_SPEED"
	say "$exercise_announcement"
	say "$needed_equipment"
	resetVolume
	resetSpeechSpeed

	countdown "$3"
}

function halfway_encouragement()
{
	if [[ "$i" -eq "$MID_SET" ]]; then
		say_medium "$HALFWAY_MESSAGE"
	fi
}

function last_rep_message()
{
	if [[ "$i" -eq "$LAST_SET" ]]; then
		say_medium "$LAST_SET_MESSAGE"
	fi
}

function add_checkmark_to_readme()
{
	column="$1"

	current_date="$(date +"%B %d, %Y")"
	today_row="$(grep --line-number --max-count=1 --no-messages -- "$current_date" "$README_FILENAME")"

	readme_line_number=""
	readme_line=""

	if [[ -z "$today_row" ]]; then
		readme_line_number="$(grep --line-number --max-count=1 --no-messages -- '---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |' "$README_FILENAME" | cut -d: -f1)"

		sed -i -e "$readme_line_number p" "$README_FILENAME"
		(( readme_line_number++ ))

		readme_line="$current_date | ---- | ---- | ---- | ---- | ---- | ---- | ---- |"
	else
		readme_line_number="$(echo "$today_row" | cut -d: -f1)"
		readme_line="$(echo "$today_row" | cut -d: -f2-)"
	fi

	new_line="$(echo -n $readme_line | tr '|' '\n' | sed "$column c \ &check; " | tr '\n' '|')"

	sed -i -e "$readme_line_number c $new_line" "$README_FILENAME"
}
