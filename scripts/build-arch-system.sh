#!/bin/bash

# purpose: install my most commonly used packages and setup the system settings I prefer
# prerequisites: expects an Arch system with pacman and bash already installed

#TODO
# 4) go over my-ssh program on git and move the dot file install here
#    - try using yadm and homesick
# 6) make sure all prerequisites are installed for gatsbyjs + react
# 12) optional - tmpfs ram disks for specified directories such as /var/log /tmp
# add: pacman -Ss --asexplicit
# omxplayer
# zathura zathura-cb zathura-djvu zathura-pdf-mupdf zathura-ps
# git lfs install
# pacman -S git-lfs
# 
#test:
#jpegoptim

declare -a pacman_packages=()
declare -a aur_packages=()

aur_packages+=(kiwix-tools arch-wiki-man kpcli tor-browser)

# Groups to install
pacman_packages+=(base base-devel multilib-devel)

# Game packages:
# puzzles

# *** Command-line packages
# Core utility packages
pacman_packages+=(tmux sudo sed man-db man-pages bash-completion findutils file less psmisc fakeroot fakechroot inotify-tools tree busybox lsof gawk bc coreutils which util-linux procps-ng kmod grep cronie)

# Misc utility packages
pacman_packages+=(asciinema ncdu lm_sensors discount hexedit)

# Font packages
pacman_packages+=()

# Arch utility packages
pacman_packages+=()

# Development packages
pacman_packages+=(strace git git-crypt python-pip typescript binutils)

# Backup packages
pacman_packages+=(bleachbit)

# Privacy/Security packages
pacman_packages+=(gnupg openssl)

# Editing packages
pacman_packages+=(vim)

# Monitoring packages
pacman_packages+=(nload iotop powertop htop)

# Speech packages
pacman_packages+=(espeak)

# Archive packages
pacman_packages+=(p7zip tar gzip bzip2 xz zip unzip unrar)

# Web Browsing/Downloading packages
pacman_packages+=(links aria2 wget curl rclone ca-certificates)

# Filesystem/Disk Drive packages
pacman_packages+=(exfat-utils dosfstools dos2unix)

# Multimedia console packages
pacman_packages+=(mencoder mpv ffmpeg alsa-utils minidlna moc)

# AWS tool packages
pacman_packages+=()

# Wifi tool packages
pacman_packages+=(wpa_supplicant wavemon hostapd)

# Networking tool packages
pacman_packages+=(nmap tcpdump mosh openssh rsync iptables dnsmasq bind-tools whois net-tools macchanger ntp)

# Android dev and tool packages
pacman_packages+=(android-tools)

# Graphics dev and tool packages
pacman_packages+=()

# AMD specific packages
#pacman_packages+=(linux-firmware amd-ucode mhwd-amdgpu amdvlk lib32-amdvlk catalyst-server catalyst-utils catalyst-video opencl-catalyst lib32-catalyst-utils lib32-opencl-catalyst)
pacman_packages+=(amd-ucode amdvlk lib32-amdvlk opencl-mesa mesa lib32-mesa xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon lib32-libva-mesa-driver libvdpau-va-gl)

# Virtualization tools
pacman_packages+=(qemu)

# Imaging packages
pacman_packages+=(imagemagick pngcrush scrot)

# My computer device packages
# solaar - for logitech k830 keyboard - logitech unifying receiver
pacman_packages+=(solaar)

# *** Desktop/Visual Packages

# X packages
pacman_packages+=(xorg-xkill xorg-server xorg-xset xorg-xprop xdg-utils xorg-xinit xorg-xrandr xorg-xauth xorg-xmodmap xorg-xgamma xorg-xinput xorg-xlsclients xorg-xrefresh xsel xorg-xmessage)

# Desktop window manager packages
pacman_packages+=(i3-wm unclutter termite)

# Downloading packages
pacman_packages+=()

# Multimedia packages
pacman_packages+=(vlc flashplugin xviewer xpdf mcomix calibre)

# Development packages
pacman_packages+=()

# Dev tool packages
pacman_packages+=()

# Game packages
pacman_packages+=(dgen-sdl mednafen snes9x)

# Imaging packages
pacman_packages+=(gimp gimp-help-en inkscape)

# Browser packages
pacman_packages+=(chromium firefox opera otter-browser brave midori)

# Misc Desktop packages
pacman_packages+=(gparted libreoffice-fresh keepass dia)

# *** install packages

# upgrade the system
pacman -Syu

read -r -p 'Install all packages together? (y/n) ' all_together

if [[ "$all_together" == "y" ]]; then
  pacman -S "${pacman_packages[@]}"
else
  read -r -p 'Go through each package one-by-one? (y/n) ' one_by_one

  if [[ "$one_by_one" == "y" ]]; then
    one_by_one=1
  else
    one_by_one=0
  fi

  # install packages
  for package in "${pacman_packages[@]}"
  do
    echo -e "\t--------------------> Package: $package"
    pacman -S "$package" && echo 'success' || echo 'fail'
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

# upgrade the system
trizen -Syu --aur

if [[ "$all_together" == "y" ]]; then
  trizen -Syu "${aur_packages[@]}"
else
  read -r -p 'Go through each package one-by-one? (y/n) ' one_by_one

  if [[ "$one_by_one" == "y" ]]; then
    one_by_one=1
  else
    one_by_one=0
  fi

  # install packages
  for package in "${aur_packages[@]}"
  do
    echo -e "\t--------------------> Package: $package"
    trizen -Syu "$package" && echo 'success' || echo 'fail'
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

# youtube-dl
curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
chmod +x /usr/local/bin/youtube-dl

# pip install
# npm install
# other?

# System setup
systemctl enable alsa-restore cronie
