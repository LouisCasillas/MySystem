#
# ~/.bash_profile
#

if [[ -f ~/.xmodmap.conf ]]; then
	xmodmap ~/.xmodmap.conf &> /dev/null
fi

[[ -f ~/.bashrc ]] && . ~/.bashrc


if [[ $(fgconsole 2>/dev/null) == 1 ]]; then
	exec startx &>/dev/null
fi
