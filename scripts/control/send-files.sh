src_dir="/root/you/tmp/"
dest_dir="/Movies/"

touch uploading
rclone copy uploading GoogleDrive:/"$dest_dir"

rclone copy "$src_dir" GoogleDrive:/"$dest_dir" && rm -rf "$src_dir"*

rclone delete GoogleDrive:/"$dest_dir"uploading
rm uploading
