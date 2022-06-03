
bin_dir=""

for path in `echo $PATH | tr ':' '\n' | grep 'bin$'`; do
  if [ ! -d "$path" ]; then
    mkdir -p "$path" &>/dev/null
  fi

  if [ -w $path ]; then
    bin_dir="$path"
    break
  fi
done

if [[ "$bin_dir" == "" ]]; then
  bin_dir="~"
fi

link_file="$bin_dir/do-daily-routine"
ln -svf "$(pwd)/do-daily-routine.sh" "$link_file"

chmod +x *.sh
chmod +x "$link_file"
