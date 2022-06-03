#!/bin/bash

# show the commands being run
set -x
# exit on any error
set -e

# purpose: install my most commonly used packages for a dev machine and set the settings I prefer
# prerequisites: expects an Arch system with pacman and bash already installed

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

user="$1"

# UID = 0 = root
if [[ "$UID" != '0' ]]; then
	echo 'You must be root to run this script.  Retry with sudo.'

	exit 1
fi

if [[ -z "$user" ]]; then
	echo "Specify the non-sudo user"
	exit 1
fi

[ ! -f "/etc/sudoers.d/dont-prompt-$user" ] && echo "$user ALL=(ALL:ALL) NOPASSWD: ALL" | tee "/etc/sudoers.d/dont-prompt-$user"

declare -a pacman_packages=()
declare -a aur_packages=()
declare -a snap_packages=()

# manual package installs

# download my repos
if [[ 0 == 1 ]]; then
(
  mkdir -p ~/repos && \
    cd ~/repos/ && \
    git clone git@github.com:LouisCasillas/MySystem.git && \
    git clone git@github.com:LouisCasillas/MyNotes.git && \
    git clone git@github.com:LouisCasillas/Python-Misc.git && \
    git clone git@github.com:LouisCasillas/ProjectEuler-Python.git && \
    git clone git@github.com:LouisCasillas/LeetCode-Python.git && \
    git clone git@github.com:LouisCasillas/ProjectEuler-BASH.git && \
    git clone git@github.com:LouisCasillas/HackerRank-Python.git && \
    git clone git@github.com:LouisCasillas/MyPythonPortfolio.git && \
    git clone git@github.com:LouisCasillas/SimpleAndroidApps.git
)
fi

# Groups to install
pacman_packages+=(base base-devel multilib-devel)

# Game packages:
# puzzles

# *** Command-line packages
# Core utility packages
pacman_packages+=(tmux sudo sed man-db man-pages bash-completion findutils file less psmisc fakeroot fakechroot inotify-tools tree busybox lsof gawk bc coreutils which util-linux procps-ng kmod grep cronie)

# Misc utility packages
pacman_packages+=(asciinema ncdu lm_sensors discount hexedit ffmpeg calibre lftp pandoc banner)

# Font packages
#pacman_packages+=()

# Development packages
pacman_packages+=(strace git git-crypt python-pip typescript binutils dart nodejs npm jdk8-openjdk python python3)

# Backup packages
#pacman_packages+=()

# Privacy/Security packages
pacman_packages+=(gnupg openssl)

# Text Editing packages
pacman_packages+=(vim notepadqq)

# Monitoring packages
pacman_packages+=(nload iotop powertop htop)

# Speech packages
pacman_packages+=(espeak-ng)

# Archive packages
pacman_packages+=(p7zip tar gzip bzip2 xz zip unzip unrar lrzip)

# Web Browsing/Downloading packages
pacman_packages+=(links aria2 wget curl rclone rsync ca-certificates)

# Filesystem/Disk Drive packages
pacman_packages+=(exfat-utils dosfstools dos2unix)

# Multimedia console packages
pacman_packages+=(mencoder mpv ffmpeg alsa-utils minidlna moc)

# AWS tool packages
#pacman_packages+=()

# Wifi tool packages
#pacman_packages+=(wpa_supplicant wavemon hostapd)

# Networking tool packages
pacman_packages+=(nmap tcpdump mosh openssh iptables dnsmasq bind-tools whois net-tools macchanger ntp)

# Android dev and tool packages
pacman_packages+=(android-tools)
# android-sdk-build-tools android-sdk-platform-tools android-platform)
# unknown:android-support-repository  
snap_packages+=(android-studio)

# Graphics dev and tool packages
#pacman_packages+=()

# AMD specific packages
#pacman_packages+=(linux-firmware amd-ucode mhwd-amdgpu amdvlk lib32-amdvlk catalyst-server catalyst-utils catalyst-video opencl-catalyst lib32-catalyst-utils lib32-opencl-catalyst)
#pacman_packages+=(amd-ucode amdvlk lib32-amdvlk opencl-mesa mesa lib32-mesa xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon lib32-libva-mesa-driver libvdpau-va-gl)

# NVIDIA specific packages
pacman_packages+=(mhwd-nvidia nvidia-utils)

# Virtualization tools
pacman_packages+=(qemu)

# Imaging packages
pacman_packages+=(imagemagick pngcrush scrot)

# *** Desktop/Visual Packages

# X packages
pacman_packages+=(xorg-xkill xorg-server xorg-xset xorg-xprop xdg-utils xorg-xinit xorg-xrandr xorg-xauth xorg-xmodmap xorg-xgamma xorg-xinput xorg-xlsclients xorg-xrefresh xsel xorg-xmessage xorg-xev)

# i3 Desktop window manager packages
#pacman_packages+=(i3-wm unclutter rofi)

# Downloading packages
#pacman_packages+=()

# Multimedia packages
pacman_packages+=(vlc xpdf atril calibre)

# Development packages
#pacman_packages+=()

# Dev tool packages
#pacman_packages+=()

# Game packages
#pacman_packages+=(dgen-sdl mednafen snes9x)

# Imaging packages
pacman_packages+=(gimp gimp-help-en inkscape)

# Browser packages
# TODO: add chrome
pacman_packages+=(chromium firefox opera otter-browser midori)
#unknown: brave 
# Misc Desktop packages
pacman_packages+=(gparted libreoffice-fresh keepassxc dia)

# *** install packages

# upgrade the system
pacman -Syu

read -n 1 -r -p 'Install all packages together? [y/N] ' all_together
	
if [[ "$all_together" == 'Y' ]]; then
	all_together='y'
fi

if [[ "$all_together" == 'y' ]]; then
	# install packages all at once
	pamac install --as-explicit --no-confirm "${pacman_packages[@]}"
else
	read -n 1 -r -p 'Go through each package one-by-one? [y/N] ' one_by_one

	if [[ "$one_by_one" == 'Y' ]]; then
		one_by_one='y'
	fi

	# install packages one by one
	for package in "${pacman_packages[@]}"
	do
		if [[ "$one_by_one" == 'y' ]]; then
			read -n 1 -r -p "About to install package: $package -- Continue? [Y/n] " should_continue

			if [[ ("$should_continue" == 'n') || ("$should_continue" == 'N') ]]; then
				echo 'Exiting...'
				exit 1
			fi
		fi

		pamac install --as-explicit --no-confirm "$package" && echo "Package successfully installed: $package" || echo "Package not installed: $package"
	done
fi

# youtube-dl
(
  mkdir -p ~/repos/other/ && \
    cd ~/repos/other/ && \
    git clone https://github.com/ytdl-org/youtube-dl.git && \
    cd youtube-dl && \
    make && \
    python3 setup.py install
)

# install yay
(
  cd ~/repos/ && \
    git clone https://aur.archlinux.org/yay.git && \
    cd yay && \
    makepkg -si
)

echo "All packages installed."

device_number="$(xinput list | grep -i touchpad | sed -e 's/^.*id=\([0-9]*\).*$/\1/g')"
xinput list-props "$device_number" | grep -i Tapping
xinput set-prop "$device_number" 318(above) 1
xinput set-prop "$device_number" 326 1
