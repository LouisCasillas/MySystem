#
# ~/.bash_profile
#

# if there is a key map modifier file then execute it
if [[ -f ~/.xmodmap.conf ]]; then
	xmodmap ~/.xmodmap.conf &> /dev/null
fi

if [[ -f ~/.bashrc ]]; then
	. ~/.bashrc
fi
