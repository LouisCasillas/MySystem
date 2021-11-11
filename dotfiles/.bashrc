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

PS1='\[\033[01;31m\][\u@\h\[\033[01;36m\] $(pwd)\[\033[01;31m\]]\$\[\033[00m\] '

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

# allow use of aliases in scripts
shopt -s expand_aliases

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

# My additions

export HISTSIZE=100000
export HISTFILESIZE="$HISTSIZE"
export EDITOR="vim"

alias mtop='top -d 1 -o %MEM'
alias ctop='top -d 1 -o %CPU'

alias fd='sudo fdisk -l'
alias m='sudo mount'
alias u='sudo umount'
alias d='sudo du -hs'

alias df='df -h'

# fixes for common typing mistakes
alias cd..='cd ..'
alias vm='mv'
alias sl='ls'

alias rsrm='rsync --remove-source-files --recursive --verbose --ipv4 --progress --partial --checksum --stats --human-readable --append-verify'
alias rs='rsync --recursive --verbose --ipv4 --progress --partial --checksum --stats --human-readable --append-verify'

for file in ~/.bash_functions_*; do
	if [[ -r "$file" ]] ; then
		. "$file"
	fi
done

# if there is a key map modifier file then execute it
if [[ -r ~/.xmodmap.conf ]]; then
	xmodmap ~/.xmodmap.conf &> /dev/null
fi

# if tmux is installed, start a tmux session if not already in one
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
    tmux new
fi
