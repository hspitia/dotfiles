#!/bin/bash

#wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add - &&
#sudo apt install apt-transport-https
#echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
#sudo apt-get update
#sudo apt-get install sublime-text

# Setup configuration
sublime_conf_dir="${HOME}/.config/sublime-text-3/Packages"
sublime_conf_backup="${HOME}/Dropbox/apps_config/sublime"
#mv "${sublime_conf_dir}/User" "${sublime_conf_dir}/User.bak"

IFS=$'\n';
for f in $(ls "${sublime_conf_backup}"); do
    cmd="ln -s \"${sublime_conf_backup}/${f}\" \"${sublime_conf_dir}/${f}\"";
    echo $cmd;
    # eval $cmd;
done

#1299
