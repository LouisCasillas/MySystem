#!/bin/bash

for cpu_online in /sys/devices/system/cpu/cpu*/online; do
	echo "$cpu_online"
	echo "0" > "$cpu_online"
done
