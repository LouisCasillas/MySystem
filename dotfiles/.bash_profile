#
# ~/.bash_profile
#

if [[ -f ~/.xmodmap.conf ]]; then
	xmodmap ~/.xmodmap.conf &> /dev/null
fi

if [[ -f ~/.bashrc ]]; then
	. ~/.bashrc
fi

#if [[ $(fgconsole 2>/dev/null) == 1 ]]; then
#	exec startx &>/dev/null
#fi
