sudo ln -f -s "$(pwd)/var/spool/cron/crontabs/oxaric" /var/spool/cron/crontabs/

sudo chown -h oxaric:crontab /var/spool/cron/crontabs/oxaric

sudo ln -f -s /usr/share/zoneinfo/US/Hawaii /etc/localtime

echo 'US/Hawaii' | sudo tee /etc/timezone
