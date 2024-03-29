BEEP_SOUND="beep.wav"
FINISH_SOUND="applause.wav"

# TODO:
# check if a key has already been buffered and don't play press any key message 
# add extra exercise script
# bug: if I ctrl-z it starts counting out loud no matter the time, also when using earbuds on phone and change volume

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
EXERCISE_CHECK_STRING="&check;"
EXERCISE_EMPTY_STRING="----"

BOX_BREATHING_README_COLUMN=2
IMST_BREATHING_README_COLUMN=3
FAST_CARDIO_README_COLUMN=4
SLOW_CARDIO_README_COLUMN=5
DAILY_FOR_TIME_README_COLUMN=6
DAILY_FOR_REPS_README_COLUMN=7
EXTRA_EXERCISE_README_COLUMN=8
BICYCLE_MILEAGE_README_COLUMN=9

BOX_BREATHING_SCRIPT="do-box-breathing.sh"
IMST_BREATHING_SCRIPT="do-imst-breathing.sh"
FAST_CARDIO_SCRIPT="do-fast-cardio.sh"
SLOW_CARDIO_SCRIPT="do-slow-cardio.sh"
DAILY_FOR_TIME_SCRIPT="do-daily-exercises-for-time.sh"
DAILY_FOR_REPS_SCRIPT="do-daily-exercises-for-reps.sh"
EXTRA_EXERCISE_SCRIPT="do-extra-exercise.sh"
BICYCLE_MILEAGE_SCRIPT="add-bicycle-mileage.sh"

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
	# TODO:
	# split want_beep into want_halfway_beep and want_ending_beep
	want_beep="$2"
	halfway_time="$(( $total_time / 2 ))"

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
	MID_SET="$(( $SETS / 2 ))"
	if [[ "$i" -eq "$MID_SET" ]]; then
		say_medium "$HALFWAY_MESSAGE"
	fi
}

function last_set_message()
{
	LAST_SET="$(( $SETS - 1 ))"
	if [[ "$i" -eq "$LAST_SET" ]]; then
		say_medium "$LAST_SET_MESSAGE"
	fi
}

function get_current_date_row()
{
	current_date="$(date +"%B %d, %Y")"
	today_row="$(grep --line-number --max-count=1 --no-messages -- "$current_date" "$README_FILENAME")"

	if [[ -z "$today_row" ]]; then
		readme_line_number="$(grep --line-number --max-count=1 --no-messages -- '---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |' "$README_FILENAME" | cut -d: -f1)"

		if [[ -z "$readme_line_number" ]]; then
			readme_line_number="$(wc -l "$README_FILENAME" | cut -d' ' -f1)"
		fi

		sed -i -e "$readme_line_number""a \n" "$README_FILENAME"

		(( readme_line_number++ ))

		readme_line="$current_date | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |"
		sed -i -e "$readme_line_number c $readme_line" "$README_FILENAME"
	else
		readme_line_number="$(echo "$today_row" | cut -d: -f1)"
		readme_line="$(echo "$today_row" | cut -d: -f2-)"
	fi
}

function add_checkmark_to_readme()
{
	# TODO: Make sure that an empty line with only ---- is added for the table to work

	column="$1"
	message="$2"

	readme_line_number=""
	readme_line=""

	get_current_date_row

	if [[ ! -z "$message" ]]; then
		new_line="$(echo -n $readme_line | tr '|' '\n' | sed "$column c \ $EXERCISE_CHECK_STRING - $message " | tr '\n' '|')"
	else
		new_line="$(echo -n $readme_line | tr '|' '\n' | sed "$column c \ $EXERCISE_CHECK_STRING " | tr '\n' '|')"
	fi

	sed -i -e "$readme_line_number c $new_line" "$README_FILENAME"
}

function get_remaining_exercise_groups()
{
	readme_line=""
	get_current_date_row

	read -ra remaining_exercise_groups < <(echo $readme_line | tr '|' '\n' | grep -n -e "$EXERCISE_EMPTY_STRING" | cut -d: -f1 | tr '\n' ' ');
}

function start_random_exercise_script()
{
	remaining_exercise_groups=()
	get_remaining_exercise_groups
	num_of_exercise_groups="${#remaining_exercise_groups[@]}"

	random_choice="$(( $RANDOM % $num_of_exercise_groups ))"
	random_exercise_group="${remaining_exercise_groups[$random_choice]}"
	random_exercise_group_script=""

	case "$random_exercise_group" in
		$BOX_BREATHING_README_COLUMN)
			random_exercise_group_script="$BOX_BREATHING_SCRIPT"
			;;
		$IMST_BREATHING_README_COLUMN)
			random_exercise_group_script="$IMST_BREATHING_SCRIPT"
			;;
		$FAST_CARDIO_README_COLUMN)
			random_exercise_group_script="$FAST_CARDIO_SCRIPT"
			;;
		$SLOW_CARDIO_README_COLUMN)
			random_exercise_group_script="$SLOW_CARDIO_SCRIPT"
			;;
		$DAILY_FOR_TIME_README_COLUMN)
			random_exercise_group_script="$DAILY_FOR_TIME_SCRIPT"
			;;
		$DAILY_FOR_REPS_README_COLUMN)
			random_exercise_group_script="$DAILY_FOR_REPS_SCRIPT"
			;;
		$EXTRA_EXERCISE_README_COLUMN)
			random_exercise_group_script="$EXTRA_EXERCISE_SCRIPT"
			;;
	esac

	bash "$random_exercise_group_script"
}

function print_set()
{
	write "Set: $(( $i + 1 )) / $SETS"
}
