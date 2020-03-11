#
# ~/.bashrc
#
[[ $- != *i* ]] && return

shopt -s expand_aliases

colors() { local fgc bgc vals seq0 
	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
if [[ -f ~/.dir_colors ]] ; then
	eval $(dircolors -b ~/.dir_colors)
fi

alias ls='ls --color=auto'
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'

PS1='\[\033[01;31m\][\h\[\033[01;36m\] $(pwd)\[\033[01;31m\]]\$\[\033[00m\] '

complete -cf sudo

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

# allow use of aliases in scripts
shopt -s expand_aliases

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

#
# # ex - archive extractor
# # usage: ex <file> <dir>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1 -C $2  ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# My additions

export HISTSIZE=100000
export HISTFILESIZE="$HISTSIZE"
export EDITOR="vim"

function adbprm()
{ 
	adb pull "$1" && \
		adb shell "rm -rf $1/*"
}

alias v="nvim -o -u /home/oxaric/.vimrc"

function xpid()
{
	xprop | grep PID | awk '{print $NF}'
}

alias rclone="/usr/bin/rclone \
	--verbose \
	--progress \
	--retries=1 \
	--fast-list \
	--no-traverse \
	--transfers=1 \
	--checkers=1 \
	--transfers=1 \
	--drive-use-trash=false \
	--drive-acknowledge-abuse"


function rls ()
{
	dir_name="$(dirname $1/-)/"
	/usr/bin/rclone -R --files-only --format="sp" lsf GoogleDrive:"$dir_name" \
			| grep -v -e uploading -e downloading \
			| sort -rn \
			| cut -d';' -f2 \
			| awk -v dir="$dir_name" '{print dir $0}' \
			| sed -e 's/[/][/]/\//g'
}

function rlsd ()
{
	dir_name="$(dirname $1/-)/"
	/usr/bin/rclone -R --dirs-only --format="sp" lsf GoogleDrive:"$dir_name" \
			| grep -v -e uploading -e downloading \
			| sort -rn \
			| cut -d';' -f2 \
			| awk -v dir="$dir_name" '{print dir $0}' \
			| sed -e 's/[/][/]/\//g'
}

function rls_count()
{
	dir_name="$(dirname $1/-)/"
	/usr/bin/rclone -R --files-only --format="sp" lsf GoogleDrive:"$dir_name" \
			| grep -v -e uploading -e downloading \
			| wc -l \
			| awk '{print $1}'
}

function rlsd_count()
{
	dir_name="$(dirname $1/-)/"
	/usr/bin/rclone -R --dirs-only --format="sp" lsf GoogleDrive:"$dir_name" \
			| grep -v -e uploading -e downloading \
			| wc -l \
			| awk '{print $1}'
}

function rput()
{

	echo "$1" | grep -q -e '[/]'
	if [[ "$?" == "0" ]]; then
		dir_name="$2/$(dirname $1/-)/"
	else
		dir_name="$2/"
	fi

	dir_name="$(echo $dir_name | sed -e 's/[/][/]/\//g')"
	
	if [ -e "$1" ]; then
		rclone copy "$1" GoogleDrive:"$dir_name" && \
			rm -rf "$1"
	else
		touch "$1"
		rclone copy "$1" GoogleDrive:"$dir_name"
		rm "$1"
	fi
}

function rputs()
{
	while read file; do
		while true; do
			echo "Trying to upload: $file"
			drive_disk_usage="$(/usr/bin/rclone size GoogleDrive:/ --json | jshon -e bytes)"
			drive_disk_remaining=$(( 15000000000 - $drive_disk_usage ))
			file_size="$(stat --format="%s" "$file")"

			if [[ "$file_size" < "$drive_disk_remaining" ]]; then
				dir_name="$(dirname "$file")"
				rput "$file" "$dir_name" && \ 
					echo -e "Done.\n" && \
					break
			else
				echo -e "Drive full... sleeping..."
				sleep 1m
			fi
		done
	done < <(find "$1" -type f)

	find . -type d -empty -delete
}

function rget()
{
	( 
		i=1
		total_files="$(rls_count "$1")"
		while read file; do
			out_dir_prefix=""

			if [[ ! -z "$2" ]]; then
				out_dir_prefix="$2/"
				echo '1'
			else
				out_dir="$out_dir_prefix$(dirname "$file" | sed -e 's/^\///')"
				echo '2'
			fi

			echo -e "\n[$((i++))/$total_files] Trying to download:\nGoogleDrive:$file\n=>\n$(pwd)/$out_dir/\n"

			rclone copy GoogleDrive:"$file" "$out_dir" && \
				rclone delete GoogleDrive:"$file"
		done < <(rls "$1" | shuf) 
	)
}

function rred()
{
	i=1
	total_dirs="$(rlsd_count)"
	while read dir; do
		echo -e "\n[$((i++))/$total_dirs] Looking at dir:\nGoogleDrive:$dir\n"

		dir_disk_usage="$(/usr/bin/rclone size GoogleDrive:/"$dir" --json | jshon -e bytes)"
		if [[ "$dir_disk_usage" == "0" ]]; then
			echo -e "\n[$i/$total_dirs] Deleting empty dir:\nGoogleDrive:$dir\n"
			rclone purge GoogleDrive:/"$dir"
		else
			echo -e "\n[$i/$total_dirs] Dir not empty:\nGoogleDrive:$dir\n"
		fi

	done < <(rlsd | tac)
}

function ded()
{
	(find . -type d -empty -delete)
}

function temp()
{
	echo "GPU: $(/opt/vc/bin/vcgencmd measure_temp | cut -f2 -d= | cut -f1 -d.)'C"
	echo "CPU: $(( $(cat /sys/class/thermal/thermal_zone0/temp) / 1000 ))'C"
}

alias mtop='top -o PID,%CPU,%MEM,CMDLINE'

if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
    tmux new
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
