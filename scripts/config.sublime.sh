#!/bin/bash

#wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add - &&
#sudo apt install apt-transport-https
#echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
#sudo apt-get update
#sudo apt-get install sublime-text

CONFIG_DIR=$HOME/.dotfiles;
CONF_FILES_DIR=$CONFIG_DIR/files;
CONF_SETTINGS_DIR=$CONFIG_DIR/settings;
CONF_UTILS_DIR=$CONFIG_DIR/utils;
CONF_SCRIPTS_DIR=$CONFIG_DIR/scripts;
CONF_PACKAGES_DIR=$CONFIG_DIR/packages;

# Setup configuration
sublime_conf_dir="${HOME}/.config/sublime-text-3/Packages"
sublime_conf_backup="${CONF_SETTINGS_DIR}/sublime"
sublime_user_dir="${sublime_conf_dir}/User"

ls $sublime_user_dir

if [ -d "$sublime_user_dir" ]; then
	cmd="mv ${sublime_user_dir}" "${sublime_user_dir}.bak";
	echo $cmd;
	eval $cmd;
fi

IFS=$'\n';
for f in $(ls "${sublime_conf_backup}"); do
    cmd="ln -s \"${sublime_conf_backup}/${f}\" \"${sublime_conf_dir}/${f}\"";
    echo $cmd;
    eval $cmd;
done

#1299
