sudo ln -f -s /usr/share/zoneinfo/US/Hawaii /etc/localtime

echo 'US/Hawaii' | sudo tee /etc/timezone

echo 'WindowsP3249P' | sudo tee /etc/hostname
echo '127.0.0.1 WindowsP3249P' | sudo tee /etc/hostname

ln -s "$(pwd)/../system-sounds" "$HOME"

sudo cp "$(pwd)/../system-conf-files/var/spool/cron/crontabs/oxaric" /var/spool/cron/crontabs/
sudo chown -h oxaric:crontab /var/spool/cron/crontabs/oxaric

ln -s "$(pwd)/exercises/exercise_list.txt" "$HOME/.exercise_list.txt"

sudo ln -s "$(pwd)/exercise-popup.sh" /usr/local/bin/
