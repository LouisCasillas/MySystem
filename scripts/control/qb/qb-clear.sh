killall qbittorrent-nox
sleep 5s
killall qbittorrent-nox
sleep 5s
killall qbittorrent-nox
sleep 5s
rm -rf ~/.local/share/data/qBittorrent/
rm -rf ~/Downloads/temp/*
find ~/Downloads/done/ -type d -empty -delete
sleep 5s
qbittorrent-nox -d
