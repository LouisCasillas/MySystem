#!/bin/sh -x

crontab -l > temp.cron

sed -e "s/#.*$//g" temp.cron | 
  grep -q -e "keep-iodined-running.sh"
if [ "$?" != "0" ]; then
  cat iodined.cron >> temp.cron

  crontab temp.cron
fi 

rm temp.cron
