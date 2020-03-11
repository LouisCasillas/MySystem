#!/bin/bash -x

onboard_wifi="wlan1"
dongle_wifi="wlan0"

{
	# forward traffic from local to internet
	# assign IP address to "$dongle_wifi"
	# connect "$onboard_wifi" to network and reqest IP address
	# start dnsmasq for "$dongle_wifi" DHCP and DNS cache
	# create AP on "$dongle_wifi"
	# start sshd on "$dongle_wifi"
	# setup initial hot cacheA
	# setup system time
	# start minidlna
	# pick random apt mirrors

	# wait until the module for "$dongle_wifi" (usb wifi dongle) has been fully loaded and the interface is live
	for ((i=0;i<10;i++)); do
		ifconfig "$dongle_wifi" &>/dev/null
		if [ "$?" -eq "0" ]; then
			break
		fi
		sleep 2
	done

	# pass all traffic from "$onboard_wifi" (local AP) to "$dongle_wifi" (interface with internet connection)
	iptables -t nat -A POSTROUTING --out-interface "$dongle_wifi" -j MASQUERADE 
	iptables -A FORWARD --in-interface "$onboard_wifi" -j ACCEPT

	# set IP of "$onboard_wifi" network - 10.0.0.{25..50}
	ip addr change 10.0.0.25/24 dev "$onboard_wifi"

	# change wifi interfaces to random MAC addresses
	macchanger -A "$onboard_wifi"
	macchanger -A "$dongle_wifi"

	# start looking for a wifi connection on "$dongle_wifi"
	/sbin/wpa_supplicant -P /var/run/wpa_supplicant.pid -B -i "$dongle_wifi" -f /var/log/wpa_supplicant.log -D nl80211 -c /etc/wpa_supplicant/wpa_supplicant.conf

	# ask the wifi connection for an IP address
	/sbin/dhclient -nw -cf /etc/dhclient.conf -pf /var/run/dhclient.pid "$dongle_wifi" &>/var/log/dhclient.log

	# start the DNS cache and DHCP for "$onboard_wifi"
	/usr/sbin/dnsmasq --pid-file=/var/run/dnsmasq.pid --dhcp-range=10.0.0.25,10.0.0.50,"$onboard_wifi" --clear-on-reload --local-ttl=3600 --neg-ttl=3600 --dhcp-ttl=3600 --auth-ttl=3600 --max-ttl=3600 --min-cache-ttl=3600 --max-cache-ttl=3600 --log-queries --log-facility=/var/log/dnsmasq.log -C /etc/dnsmasq.conf

	# start the local wifi AP on "$onboard_wifi"
	/usr/sbin/hostapd -P /var/run/hostapd.pid -B -i "$onboard_wifi" -f /var/log/hostapd.log /etc/hostapd/hostapd.conf

	# startup SSH server daemon
	mkdir -p /run/sshd/
	/usr/sbin/sshd -E /var/log/sshd.log

	# once we have internet we can setup the DNS hot cache
	for ((i=0;i<10;i++)); do
		ping -q -c 1 1.1.1.1 &>/dev/null
		if [ "$?" -eq "0" ]; then
			nohup /root/my-scripts/keep-dns-hot/keep-dns-hot.sh &>/dev/null &
			break
		fi
		sleep 2
	done

	# connect to NTP servers and get the correct time
	nohup /usr/sbin/ntpdate -u 0.debian.pool.ntp.org 1.debian.pool.ntp.org 2.debian.pool.ntp.org 3.debian.pool.ntp.org 0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org &>/var/log/ntpdate.log &

	# sometimes the usb drives take a little while to properly load so wait a few seconds
	sleep 5

	# try to mount all defined drives as specified in: /etc/automount/usb.cfg
	/root/my-scripts/automount-usb.sh

	# give a few seconds for any special mounting systems to run
	sleep 5

	# start the DLNA media server
	minidlnad -P /var/run/minidlnad.pid

} &> /var/log/startup.log

exit 0
