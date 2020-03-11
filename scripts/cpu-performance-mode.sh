#!/bin/bash

max_freq="$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies | awk '{print $1}')"

for cpu_online in /sys/devices/system/cpu/cpu*/online; do
	echo "$cpu_online"
	echo "1" > "$cpu_online"
done

for cpu_max_freq in /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq; do
	echo "$max_freq" > "$cpu_max_freq"
done

for cpu_min_freq in /sys/devices/system/cpu/cpu*/cpufreq/scaling_min_freq; do
	echo "$max_freq" > "$cpu_min_freq"
done

for cpu_scaling_governor in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
	echo "performance" > "$cpu_scaling_governor"
done
