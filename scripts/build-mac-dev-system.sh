#!/bin/bash

# show the commands being run
set -x
# exit on any error
set -e

# purpose: install my most commonly used packages for a dev machine and set the settings I prefer
# prerequisites: expects a Mac system with bash already installed

### TODO
# - make sure all prerequisites are installed for gatsbyjs + react
# - optional - tmpfs ram disks for specified directories such as /var/log /tmp
# - install standard npm and pip packages
#
# test:
#  jpegoptim
#
###

function trap_exit()
{
	echo 'goodbye...'
	exit 0
}

trap trap_exit SIGINT

user="$(whoami)"

[[ ! -f "/etc/sudoers.d/dont-prompt-$user" ]] && (echo "$user ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee "/etc/sudoers.d/dont-prompt-$user")
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

read -p 'Install python2.7...'

declare -a brew_packages=()

# Groups to install
brew_packages+=(base)

# Game packages:
# puzzles

# *** Command-line packages
# Core utility packages
brew_packages+=(tmux man-db bash-completion findutils file less tree gawk bc coreutils util-linux grep)

# Misc utility packages
brew_packages+=(asciinema ncdu discount hexedit lftp pandoc)

# Font packages
#brew_packages+=()

# Development packages
brew_packages+=(git git-crypt typescript binutils python3)

# Backup packages
#brew_packages+=()

# Privacy/Security packages
brew_packages+=(gnupg openssl)

# Editing packages
brew_packages+=(vim)

# Monitoring packages
brew_packages+=(nload htop)

# Speech packages
brew_packages+=(espeak)

# Archive packages
brew_packages+=(p7zip gzip bzip2 xz zip unzip)

# Web Browsing/Downloading packages
brew_packages+=(links aria2 wget curl rclone rsync)

# Filesystem/Disk Drive packages
brew_packages+=(dosfstools dos2unix)

# Multimedia console packages
brew_packages+=(mpv ffmpeg moc)

# AWS tool packages
#brew_packages+=()

# Wifi tool packages
#brew_packages+=(wpa_supplicant wavemon hostapd)

# Networking tool packages
brew_packages+=(nmap tcpdump mosh openssh dnsmasq whois ntp)

# Android dev and tool packages
brew_packages+=(android-studio android-platform-tools android-file-transfer android-commandlinetools kotlin)

# Graphics dev and tool packages
#brew_packages+=()

# Virtualization tools
#brew_packages+=(qemu)

# Imaging packages
brew_packages+=(imagemagick pngcrush)

# *** Desktop/Visual Packages

# X packages
#brew_packages+=(xorg-xkill xorg-server xorg-xset xorg-xprop xdg-utils xorg-xinit xorg-xrandr xorg-xauth xorg-xmodmap xorg-xgamma xorg-xinput xorg-xlsclients xorg-xrefresh xsel xorg-xmessage xorg-xev)

# i3 Desktop window manager packages
#brew_packages+=(i3-wm unclutter rofi)

# Downloading packages
#brew_packages+=()

# Multimedia packages
brew_packages+=(vlc xpdf calibre)

# Development packages
#brew_packages+=()

# Dev tool packages
#brew_packages+=()

# Game packages
#brew_packages+=(dgen-sdl mednafen snes9x)

# Imaging packages
#brew_packages+=(gimp gimp-help-en inkscape)

# Browser packages
#brew_packages+=(chromium firefox opera otter-browser brave midori)

# Misc Desktop packages
brew_packages+=(libreoffice keepassxc dia)

# *** install packages

# upgrade brew
brew update

read -n 1 -r -p 'Install all packages together? [y/N] ' all_together
	
if [[ "$all_together" == 'Y' ]]; then
	all_together='y'
fi

if [[ "$all_together" == 'y' ]]; then
	# install packages all at once
	brew install "${brew_packages[@]}"
else
	read -n 1 -r -p 'Go through each package one-by-one? [y/N] ' one_by_one

	if [[ "$one_by_one" == 'Y' ]]; then
		one_by_one='y'
	fi

	# install packages one by one
	for package in "${brew_packages[@]}"
	do
		if [[ "$one_by_one" == 'y' ]]; then
			read -n 1 -r -p "About to install package: $package -- Continue? [Y/n] " should_continue

			if [[ ("$should_continue" == 'n') || ("$should_continue" == 'N') ]]; then
				echo 'Exiting...'
				exit 1
			fi
		fi

		brew install "$package" && echo "Package successfully installed: $package" || echo "Package not installed: $package"
	done
fi

echo "All packages installed."

# setting up PATH variable to include brew installed packages
find /usr/local/Cellar/ -type d -iname "*bin*" | sort -u | tr '\n' ':' | sed -e 's/^\(.*\)$/PATH="\1\$PATH"\nexport PATH/' >> ~/.bash_profile

# manual package installs

# youtube-dl
(
  mkdir -p ~/repos/other/ && \
    cd ~/repos/other/ && \
    git clone 'git@github.com:ytdl-org/youtube-dl.git' && \
    cd youtube-dl && \
    make && \
    python3 setup.py install
)
