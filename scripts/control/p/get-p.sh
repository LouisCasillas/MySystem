#!/bin/bash

num_of_links_to_get="150"

shopt -s expand_aliases

source /root/.bashrc

# trap ctrl-c
trap ctrl_c INT
function ctrl_c()
{
	echo "goodbye..."
	exit 0
}

pip install --upgrade youtube-dl

touch downloading
rclone copy downloading GoogleDrive:/p/
rm downloading

mkdir -p /root/pn/
cd /root/pn/

mkdir -p tmp done

tmp_links="$(mktemp -p /root/pn/)"

head -n "$num_of_links_to_get" links.txt > "$tmp_links"
head -n "$num_of_links_to_get" links.txt >> old-links.txt
tail -n+"$(($num_of_links_to_get + 1))" links.txt > a; mv a links.txt

cd /root/pn/tmp/

yf -a "$tmp_links" --exec 'bash /root/pn/download-finished.sh {}'

cd /root/pn/

rm "$tmp_links"

rclone delete GoogleDrive:/p/downloading
