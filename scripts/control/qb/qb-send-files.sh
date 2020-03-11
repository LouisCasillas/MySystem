drive_disk_space="14"

touch uploading
rclone copy uploading GoogleDrive:/d/
rm uploading

cd /root/Downloads/

mkdir -p done-send

cd done

while read line; do
	mv "$line" "../done-send/"

	dir_size="$(du -hs ../done-send/ | cut -f1 | grep -e G | cut -dG -f1 | cut -d. -f1)"
	if [[ "$dir_size" -gt "$drive_disk_space" ]]; then
		mv ../done-send/"$line" .
		break
	fi

done < <(du -hs * | sort -h | cut -f2-)

cd ..

if [[ ! -z "$(ls -A done-send/)" ]]; then

	rclone copy /root/Downloads/done-send/ GoogleDrive:/d/ && \
		rm -rf /root/Downloads/done-send/*
fi

rclone delete GoogleDrive:/d/uploading
