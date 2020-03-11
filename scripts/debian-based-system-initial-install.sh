#!/bin/bash

add_repos=0

if [[ "$add_repos" == "1" ]]; then
	# needed for TimeShift - Take snapshots of the system and restore 
	add-apt-repository -y ppa:teejee2008/ppa

	# needed for touchpad-indicator - turn touchpad off while typing and mouse is plugged in
	add-apt-repository ppa:atareao/atareao

	# needed for apt-fast - Download package files in parallel
	add-apt-repository ppa:apt-fast/stable

	# needed for Chrome - Google web browser
	wget -q -O - 'https://dl-ssl.google.com/linux/linux_signing_key.pub' | sudo apt-key add -
	add-apt-repository 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main'

	# needed for Opera - Apple web browser
	wget -q -O - 'https://deb.opera.com/archive.key' | sudo apt-key add -
	add-apt-repository "deb [arch=amd64] https://deb.opera.com/opera-stable/ stable non-free"

	# needed for Visual Studio Code - Microsoft IDE
	wget -q -O - 'https://packages.microsoft.com/keys/microsoft.asc' | sudo apt-key add -
	add-apt-repository 'deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main'
	
	# needed for SublimeText - Freeware IDE
	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
	add-apt-repository "deb https://download.sublimetext.com/ apt/stable/"

fi

# update repository info
apt-get update -y

# always add a trailing space when adding package strings to this variable
all_packages=''

# Misc dev packages
all_packages+='build-essential gcc g++ ccache nasm git git-man git-doc git-extras git-gui subversion nodejs nginx docker docker-compose docker-doc docker-registry docker.io mapnik-utils build-essential dkms linux-headers-generic gcc-multilib flex bison '

# Android dev and tool packages
#all_packages+='adb google-android-ndk-installer google-android-build-tools-installer google-android-sdk-docs-installer android-sdk android-sdk-build-tools androidsdk-ddms android-tools-adb android-tools-fastboot android-tools-fsutils android-tools-mkbootimg  '

# Command-line packages
all_packages+='apt-transport-https apt-build aptitude alien docker vim youtube-dl lynx iotop powertop axel aria2 p7zip-full p7zip-rar unrar rar tor deborphan xinput psmisc bleachbit caffeine tmux tldr yadm asciinema ctop pngcrush xbindkeys net-tools xsel tree xdotool screen wavemon rename parted dosfstools mtools dos2unix flip recode fondu hwinfo imagemagick figlet vbindiff whois hostapd dnsmasq wpa_supplicant linux-tools-common linux-tools-generic ncdu pv '

# Music tool packages
all_packages+='ardour hydrogen qtractor yoshimi musescore guitarix sooperlooper calf-plugins calf-ladspa rosegarden qmidiarp zynaddsubfx fluidsynth tk707 '

# Multimedia packages
all_packages+='vlc mplayer ffmpeg '

# Imaging packages
all_packages+='gimp inkscape krita pinta '

# Security tool packages
all_packages+='nmap wireshark aircrack-ng reaver goldeneye mdk3 mz pcapfix '

# Misc Desktop packages
all_packages+='code sublime-text gparted synaptic libreoffice evince keepass2 gpaste torbrowser-launcher calibre shutter uget okular virtualbox virtualbox-guest-additions-iso kazam touchpad-indicator seahorse octave handbrake clonezilla bluefish dia florence dosbox xonix baobab '

# Desktop web browser packages
# TODO: IE EDGE SAFARI
#all_packages+='firefox google-chrome-beta google-chrome-stable '

# *** install packages

# first install apt-fast so that all packages can be downloaded in parallel greatly increasing download speeds
# replace with direct script download from github
apt-get install -y apt-fast

# upgrade the system
apt-fast upgrade -y

# install packages
apt-fast install -y $all_packages

# *** optimize system settings

# Turn off scrolling with laptop touchpad because it easily gets hit while typing
# Update to be permanent, need to re-apply during each startup
synclient VertTwoFingerScroll=0 VertEdgeScroll=0 

# block ad IPs using dnsmasq hosts file
all_ad_ip_lists=''
all_ad_ip_lists+='https://pgl.yoyo.org/adservers/serverlist.php?showintro=0;useip=&mimetype=plaintext'

# all Pi-Hole blocklists
#all_ad_ip_lists+='https://dnsbl.karelvanhecke.com/adg-ad.txt '
#all_ad_ip_lists+='https://dnsbl.karelvanhecke.com/adg-mobile.txt '
#all_ad_ip_lists+='https://dnsbl.karelvanhecke.com/adg-spyware.txt '
#all_ad_ip_lists+='https://dnsbl.karelvanhecke.com/airelle-ads.txt '
#all_ad_ip_lists+='https://dnsbl.karelvanhecke.com/airelle-mal.txt '
#all_ad_ip_lists+='https://dnsbl.karelvanhecke.com/airelle-trc.txt '
#all_ad_ip_lists+='https://dnsbl.karelvanhecke.com/c2.txt '
#all_ad_ip_lists+='https://dnsbl.karelvanhecke.com/dga.txt '
#all_ad_ip_lists+='https://dnsbl.karelvanhecke.com/easylist.txt '
#all_ad_ip_lists+='https://dnsbl.karelvanhecke.com/easyprivacy.txt '
#all_ad_ip_lists+='https://dnsbl.karelvanhecke.com/mwpatrol.txt '
#all_ad_ip_lists+='https://dnsbl.karelvanhecke.com/openphish.txt '
#all_ad_ip_lists+='https://dnsbl.karelvanhecke.com/openphish_30d.txt '
#all_ad_ip_lists+='https://dnsbl.karelvanhecke.com/otx.txt '
#all_ad_ip_lists+='https://dnsbl.karelvanhecke.com/phishtank.txt '
#all_ad_ip_lists+='https://dnsbl.karelvanhecke.com/shalla-adv.txt '
#all_ad_ip_lists+='https://dnsbl.karelvanhecke.com/shalla-spyware.txt '
#all_ad_ip_lists+='https://dnsbl.karelvanhecke.com/shalla-tracker.txt '
#all_ad_ip_lists+='https://dnsbl.karelvanhecke.com/ut1-ads.txt '
#all_ad_ip_lists+='https://dnsbl.karelvanhecke.com/ut1-mal.txt '
#all_ad_ip_lists+='https://dnsbl.karelvanhecke.com/ut1-phi.txt '
#all_ad_ip_lists+='https://dnsbl.karelvanhecke.com/urlhaus.txt '

host_block_file='/etc/dnsmasq.d/ad-block.hosts'

> "$host_block_file"
for ip_list in $all_ad_ip_lists; do
        wget -q -O- "$ip_list" >> "$host_block_file"
done

# address=/example.com/127.0.0.1
# remove leading and trailing spaces, delete all comments, remove empty lines
# sort and remove duplicate addresses
# point addresses to black hole 127.0.0.1
sed -e 's/^\s*//g' -e 's/\s*$//g' -e '/^#/d' -e '/^$/d' "$host_block_file" | \
  sort -u | \
  sed 's/^\(.*\)$/address=\/\1\/127.0.0.1/g' > "$host_block_file.tmp"
mv "$host_block_file.tmp" "$host_block_file"

systemctl restart dnsmasq

# *** remove packasges I don't like or use

# Remove NetworkManager from the system
# I do not like NetworkManager as I often find it conflicts with other packages I like such as dnsmasq or hostapd
apt-get purge network-manager* -y
