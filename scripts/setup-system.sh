# System setup

grep -v -q -e '^en_US.UTF-8 UTF-8$' /etc/locale.gen
if [ $? -eq 0 ]; then
	echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
fi

echo 'LANG=en_US.UTF-8' > /etc/default/locale

cat << EOF /etc/default/keyboard
# KEYBOARD CONFIGURATION FILE

# Consult the keyboard(5) manual page.

XKBMODEL="pc104"
XKBLAYOUT="us"
XKBVARIANT=""
XKBOPTIONS=""

BACKSPACE="guess"
EOF

setupcon --force
locale-gen

# tmpfs for /tmp and /var/log

grep -v -q -e 'tmpfs /tmp' /etc/fstab
if [ $? -eq 0 ]; then
	echo 'tmpfs /tmp tmpfs defaults,noatime 0 0' >> /etc/fstab
fi
grep -v -q -e 'tmpfs /var/log' /etc/fstab
if [ $? -eq 0 ]; then
	echo 'tmpfs /tmp tmpfs defaults,noatime 0 0' >> /etc/fstab
	echo 'tmpfs /var/log tmpfs defaults,noatime 0 0' >> /etc/fstab
fi

dpkg-reconfigure locales

ldconfig
ln -f -s /usr/share/zoneinfo/US/Hawaii /etc/localtime

echo 'US/Hawaii' > /etc/timezone

echo 'WindowsP3249P' > /etc/hostname
echo '127.0.0.1 WindowsP3249P' > /etc/hosts

ln -f -s "$(pwd)/../system-sounds/" "$HOME/.system-sounds"

cp "$(pwd)/../system-conf-files/var/spool/cron/crontabs/oxaric" /var/spool/cron/crontabs/
chown -h oxaric:crontab /var/spool/cron/crontabs/oxaric

ln -f -s "$(pwd)/../system-conf-files/etc/dnsmasq.conf" /etc/

mkdir -p "$HOME/.exercise/"

ln -f -s "$(pwd)/exercises/exercise-list.txt" "$HOME/.exercise/exercise-list.txt"

ln -f -s "$(pwd)/exercises/exercise-counts/" "$HOME/.exercise/exercise-counts"

chmod +x exercise-popup.sh
chmod +x exercise-reset-total.sh
ln -f -s "$(pwd)/exercise-popup.sh" /usr/local/bin/exercise-popup
ln -f -s "$(pwd)/exercise-reset-total.sh" /usr/local/bin/exercise-reset-total

#alsa-restore 
declare -a services_to_enable=(cron hciuart bluetooth)
declare -a services_to_disable=(avahi-daemon lvm2-monitor lm-sensors udisks2 rpi-eeprom-update ModemManager raspi-config sysstat keyboard-setup)

for service in "${services_to_enable[@]}"
do
	systemctl enable "$service"
done

for service in "${services_to_disable[@]}"
do
	systemctl disable "$service"
done
