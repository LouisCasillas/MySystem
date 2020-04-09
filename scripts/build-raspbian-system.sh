#!/bin/bash

# purpose: install my most commonly used packages and setup the system settings I prefer
# prerequisites: expects an Arch system with pacman and bash already installed

#TODO
# 4) go over my-ssh program on git and move the dot file install here
#    - try using yadm and homesick
# 6) make sure all prerequisites are installed for gatsbyjs + react
# 12) optional - tmpfs ram disks for specified directories such as /var/log /tmp
# zathura zathura-cb zathura-djvu zathura-pdf-mupdf zathura-ps
# 
#test:
#jpegoptim
# unp
# moc-ffmpeg-plugin
# vulkan*
# gnuit

# find equivalent packages:
# kiwix tor-browser
#apt_packages+=(base base-devel multilib-devel)
# man-pages which procps-ng
# typescript 

declare -a apt_packages=()

# Groups to install

# Game packages:
# puzzles

# *** Command-line packages
# Core utility packages
apt_packages+=(tmux sudo sed man-db bash-completion findutils file less psmisc fakeroot fakechroot inotify-tools tree busybox lsof gawk bc coreutils util-linux kmod grep cron anacron)

# Misc utility packages
apt_packages+=(kpcli asciinema ncdu lm-sensors discount hexedit terminator megadown units)

# Font packages
apt_packages+=()

# Development packages
apt_packages+=(strace git git-crypt git-lfs python-pip python3-pip binutils build-essential g++ gcc)

# Privacy/Security packages
apt_packages+=(gnupg openssl)

# Editing packages
apt_packages+=(vim)

# Monitoring packages
apt_packages+=(nload iotop powertop htop)

# Speech packages
apt_packages+=(espeak)

# Archive packages
apt_packages+=(p7zip-full tar gzip bzip2 xz-utils zip unzip)

# Web Browsing/Downloading packages
apt_packages+=(links aria2 wget curl rclone ca-certificates)

# Filesystem/Disk Drive packages
apt_packages+=(exfat-utils dosfstools dos2unix)

# Multimedia console packages
apt_packages+=(mpv ffmpeg alsa-utils minidlna moc omxplayer)

# AWS tool packages
apt_packages+=()

# Bluetooth tool packages
apt_packages+=(bluez)

# Wifi tool packages
apt_packages+=(wpasupplicant wavemon hostapd)

# Networking tool packages
apt_packages+=(nmap tcpdump mosh openssh rsync iptables dnsmasq whois net-tools macchanger ntp qbittorrent-nox dnsutils)

# Android dev and tool packages
apt_packages+=(adb)

# Graphics dev and tool packages
apt_packages+=()

# Virtualization tools
apt_packages+=(qemu)

# Imaging packages
apt_packages+=(imagemagick pngcrush scrot)

# My computer device packages
# solaar - for logitech k830 keyboard - logitech unifying receiver
apt_packages+=(solaar)

# *** Desktop/Visual Packages

# X packages
apt_packages+=(lightdm xserver-xorg x11-utils x11-server-utils xinit xdg-utils xsel)

# Desktop window manager packages
apt_packages+=(i3-wm unclutter rofi i3blocks i3lock xautolock)

# Downloading packages
apt_packages+=()

# Multimedia viewer packages
apt_packages+=(vlc xpdf mcomix calibre kodi zathura* eom)

# Development packages
apt_packages+=()

# Dev tool packages
apt_packages+=()

# Backup packages
apt_packages+=(bleachbit)

# Game packages
apt_packages+=(retroarch mednafen mednaffe scummvm dosbox fluidsynth)

# Imaging packages
apt_packages+=(gimp gimp-help-en inkscape)

# Browser packages
apt_packages+=(chromium midori)

# Misc Desktop packages
apt_packages+=(gnome-disk-utility libreoffice keepass2 dia)

# *** install packages

# upgrade the system
apt-get update -y && apt-get upgrade -y && apt-get dist-upgrade -y

read -r -p 'Install all packages together? (y/n) ' all_together

if [[ "$all_together" == "y" ]]; then
  apt-get -y install "${apt_packages[@]}"
else
  read -r -p 'Go through each package one-by-one? (y/n) ' one_by_one

  if [[ "$one_by_one" == "y" ]]; then
    one_by_one=1
  else
    one_by_one=0
  fi

  # install packages
  for package in "${apt_packages[@]}"
  do
    echo -e "\t--------------------> Package: $package"
    apt-get -y install "$package" && echo 'success' || echo 'fail'
    echo -e "\t--------------------> Previous Package: $package"
    echo -e "\t--------------------> Ready for the next package?"

    if [ "$one_by_one" ]; then
      read -r -p 'Continue? (y/n) ' should_continue
      if [[ "$should_continue" == "n" ]]; then
        echo 'Exiting...'
        exit 1
      fi
    fi
  done
fi

# manual package installs

mkdir -p tmp
cd tmp
apt-get source -b unrar-nonfree
dpkg -i *.deb
cd ..
rm -rf tmp

# youtube-dl
curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
chmod +x /usr/local/bin/youtube-dl

# pip install
# npm install
# other?

bash setup-system.sh
