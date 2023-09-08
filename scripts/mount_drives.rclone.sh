#!/bin/bash 

# Mount remote disks in location at home
# rclone --vfs-cache-mode writes mount box: ~/Box &
# rclone --vfs-cache-mode writes mount dropboxgt: ~/DropboxGatech &
for i in drDrive drDropbox drDropboxUFL drOneDriveUFL; do
    dr_dir=$HOME/${i}
    cmd="test ! -d \"$dr_dir\" && mkdir -p \"$dr_dir\" && rclone --vfs-cache-mode writes mount ${i}: $dr_dir"
    echo $cmd
done


# rclone --vfs-cache-mode writes mount drDrive: ~/drDrive &
# rclone --vfs-cache-mode writes mount drDropbox: ~/drDropbox &
# rclone --vfs-cache-mode writes mount drDropboxUFL: ~/drDropboxUFL &
# rclone --vfs-cache-mode writes mount drOneDriveUFL: ~/drOneDriveUFL