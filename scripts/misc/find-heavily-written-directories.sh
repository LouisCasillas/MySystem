# Use to see heavily written to files and directories, might be a good chance to make the directory a ramdisk in order to reduce disk I/O
# if trying to watch many files you might need to increase the amount of inotify watches allowed per user via: /proc/sys/fs/inotify/max_user_watches
sudo inotifywait --monitor --recursive /tmp
