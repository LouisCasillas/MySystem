working_dir="$(dirname `readlink $0` &>/dev/null)"
(
  if [[ ! -z "$working_dir" ]]; then
    cd $working_dir
  fi

  bash do-box-breathing.sh
  bash do-imst-breathing.sh
  bash do-daily-exercises-for-time.sh
  bash do-daily-exercises-for-reps.sh
  bash do-fast-cardio.sh
  bash do-slow-cardio.sh
)
