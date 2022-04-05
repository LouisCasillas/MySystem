count_file=".count"
total=0
max=100

if [[ -r "$count_file" ]]; then
    total="$(head -1 "$count_file")"
fi

if [[ "$total" -gt "$max" ]]; then
    killall -q gallery-dl
    rm "$count_file"
else
    (( total++ ))
    echo "$total" > "$count_file"
fi
