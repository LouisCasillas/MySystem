count_file=".count"

if [[ -f "$count_file" ]]; then
    rm "$count_file"
fi

cat links.txt | while read url; do 
    #gallery-dl --limit-rate 100k --sleep 1 --abort 100 --no-mtime --no-part --directory ppics/  --exec 'bash count-kill.sh' "$url"
    gallery-dl --http-timeout 5 --no-check-certificate --abort 100 --filesize-max=20M --no-mtime --no-part --directory ppics/ --exec 'bash count-kill.sh' "$url"
    echo "$url" >> done.txt
done
