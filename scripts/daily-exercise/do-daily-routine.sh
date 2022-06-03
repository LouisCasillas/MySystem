working_dir="$(dirname `readlink $0`)"

(
cd $working_dir
bash do-box-breathing.sh
bash do-imst-breathing.sh
bash do-daily-exercises.sh
bash do-fast-cardio.sh
bash do-slow-cardio.sh
)
