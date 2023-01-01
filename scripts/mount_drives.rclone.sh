#!/bin/bash 

# Mount remote disks in location at home
# rclone --vfs-cache-mode writes mount box: ~/Box &
# rclone --vfs-cache-mode writes mount dropboxgt: ~/DropboxGatech &
rclone --vfs-cache-mode writes mount drive: ~/drDrive &
rclone --vfs-cache-mode writes mount dropbox: ~/drDropbox &
rclone --vfs-cache-mode writes mount dropboxufl: ~/drDropboxUFL &
rclone --vfs-cache-mode writes mount onedrive: ~/drOneDriveUFL