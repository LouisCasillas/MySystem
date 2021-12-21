pkg install -y apt aria2 bash bzip2 ca-certificates command-not-found coreutils curl dash debianutils dialog diffutils dos2unix dpkg ed ffmpeg findutils gawk git gpgv grep gzip inetutils less libandroid-glob libandroid-support libbz2 libc++ libcrypt libcurl libgcrypt libgmp libgpg-error libiconv liblzma libmpfr libnghttp2 libssh2 libtirpc lsof man nano ncurses net-tools openssh openssl p7zip patch pcre procps psmisc python readline sed tar termux-am termux-exec termux-keyring termux-licenses termux-tools tmux unzip util-linux vim xz-utils zip zlib 

(cd ../dotfiles/; bash create-symlinks.sh;) 

curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /data/data/com.termux/files/usr/bin/youtube-dl
chmod +x /data/data/com.termux/files/usr/bin/youtube-dl

echo 'cd /storage/emulated/0/' >> ~/.bashrc
