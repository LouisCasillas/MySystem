#!/bin/bash
drive_disk_space="14"

# trap ctrl-c
trap ctrl_c INT
function ctrl_c()
{
	echo "goodbye..."
	exit 0
}

touch uploading
rclone copy uploading GoogleDrive:/p/
rm uploading

cd /root/pn/done

mkdir -p tmp

while read file; do
	mv "$file" tmp/

	dir_size="$(du -hs tmp/ | cut -f1 | grep -e G | cut -dG -f1 | cut -d. -f1)"
	if [[ "$dir_size" -gt "$drive_disk_space" ]]; then
		mv tmp/"$file" .
		break
	fi
done < <(ls *.mp4 | shuf)

rclone copy tmp/ GoogleDrive:/p && \
	rm -rf tmp/*
	
rclone delete GoogleDrive:/p/uploading
