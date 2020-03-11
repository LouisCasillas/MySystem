#!/bin/bash

INIT_SCRIPT="/etc/init.d/iodined"
FILE_PID=/var/run/iodined.pid
FILE_LAST_CHECK="checked-on-iodined"
FILE_INIT_STATUS="last-status"
FILE_LAST_RESTART="had-to-restart-iodined"
FILE_CONSECUTIVE_RESTARTS="number-of-consecutive-restarts"
FILE_TOTAL_RESTARTS="number-of-total-restarts"
RESTARTS_BEFORE_LOOP="10"
RESTART_LOOP_COMMAND="reboot"

touch "$FILE_LAST_CHECK"
  
$INIT_SCRIPT status &> "$FILE_INIT_STATUS"

pgrep --pidfile "$FILE_PID" &>/dev/null
if [ "$?" != "0" ]; then
  echo "iodined died..."

  touch "$FILE_LAST_RESTART"

  num_of_consecutive_restarts="1"
  num_of_total_restarts="1"

  num_of_consecutive_restarts="$(cat $FILE_CONSECUTIVE_RESTARTS)"

  num_of_total_restarts="$(cat $FILE_TOTAL_RESTARTS)"
  num_of_total_restarts=$(($num_of_total_restarts + 1))
  echo "$num_of_total_restarts" > "$FILE_TOTAL_RESTARTS"

  if [[ -n "$num_of_consecutive_restarts" && "$num_of_consecutive_restarts" -eq "$RESTARTS_BEFORE_LOOP" ]]; then
    echo "0" > "$FILE_CONSECUTIVE_RESTARTS"
    $RESTART_LOOP_COMMAND
  else
    num_of_consecutive_restarts=$(($num_of_consecutive_restarts + 1))
    echo "$num_of_consecutive_restarts" > "$FILE_CONSECUTIVE_RESTARTS"

    $INIT_SCRIPT restart
  fi
else
  echo "0" > "$FILE_CONSECUTIVE_RESTARTS"
fi
