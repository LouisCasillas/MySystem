
bin_dir="~/.local/bin"
mkdir -p "$bin_dir"

link_file="$bin_dir/do-daily-routine"
ln -svf "$(pwd)/do-daily-routine.sh" "$link_file"

chmod +x *.sh
chmod +x "$bin_dir"
chmod +x "$link_file"
