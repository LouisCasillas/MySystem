#!/bin/bash

which youtube-dl &>/dev/null

if [[ "$?" == "1" ]]; then
	echo 'youtube-dl not found so installing...' && \

	sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl && \
	sudo chmod a+rx /usr/local/bin/youtube-dl && \

	echo 'youtube-dl now installed'

	which youtube-dl &>/dev/null

	if [[ "$?" == "1" ]]; then
		echo 'Something failed and youtube-dl does not appear to have been installed.  Cannot continue.'
		exit 1
	fi
else
	echo 'youtube-dl found...'
fi

which ffmpeg &>/dev/null

if [[ "$?" == "1" ]]; then
	echo 'ffmpeg not found so installing...' && \
	apt-get install ffmpeg -y && \
	echo 'ffmpeg now installed'
else
	echo 'ffmpeg found...'
fi

sudo -u nobody -g users mkdir -p /share/completed/videos/

echo 'Listening...'

i=0
while true; do
	url="$((echo -e 'HTTP/1.1 200 OK\n'; ls) | netcat -n -W 1 -l 8081 | grep GET | sed -e 's/^GET\s*[/]\(.*\)\s*HTTP[/].[.]./\1/g')"

	echo "Received link: $url"

	echo "$url" | grep -q "favicon.ico"
	if [[ "$?" == "0" ]]; then
		echo 'skipping...'
		continue
	fi

	((i++))

	if [[ $((i % 5)) == 0 ]]; then
		echo 'Updating youtube-dl...'
		nohup youtube-dl -U &>/dev/null &
		
		if [[ -f "nohup.out" && ! $(pgrep youtube-dl) ]]; then
			echo 'Removing old nohup.out...'
			rm nohup.out
		fi

		i=0
	fi

	echo "$url" | grep -q '[.]'
	if [[ "$?" == "0" ]]; then
		sudo -u nobody -g users nohup sudo -u nobody -g users youtube-dl -c -i "$url" --exec 'mv {} /share/completed/videos/' &
	else
		echo 'skipping...'
	fi
done
