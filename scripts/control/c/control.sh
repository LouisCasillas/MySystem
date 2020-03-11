#!/bin/bash

control_files="$(/usr/bin/rclone --retries 1 lsf GoogleDrive:/c/)"

if [ ! -z "$control_files" ]; then
	current_date="`date +%Y%m%d-%H%M%s`"
	
	mkdir -p /root/control/"$current_date"
	cd /root/control/"$current_date"

	/usr/bin/rclone copy GoogleDrive:/c/ . && \
		/usr/bin/rclone purge GoogleDrive:/c/

	for file in *.sh; do
		log_file="$file-$current_date.log"
		> "$log_file"
		(bash -x "$file" &>> "$log_file"; \
			/usr/bin/rclone copy /root/control/ GoogleDrive:/c-logs/; \
			rm "$file" "$log_file") &
	done
fi
