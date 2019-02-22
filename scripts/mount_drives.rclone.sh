#!/bin/bash 

# Mount remote disks in location at home
rclone --vfs-cache-mode writes mount box: ~/Box &
rclone --vfs-cache-mode writes mount drive: ~/Drive &
rclone --vfs-cache-mode writes mount dropbox: ~/DropboxPersonal &
rclone --vfs-cache-mode writes mount onedrive: ~/OneDrive &