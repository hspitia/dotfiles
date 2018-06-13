#!/bin/bash

package_list_file=$1; # package list file 
repo_list_file=$2; # package list file 

dist=$(lsb_release -sc);

# Install Keys
# sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9 # R language
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -

# Add repos
# ./apt_repos.sh $repo_list_file

sudo apt-get update
sudo apt-get dist-upgrade

# Packages without dependencies
sudo apt-get -y install lyx --no-install-recommends
sudo apt-get -y install tikzit --no-install-recommends
sudo apt-get -y install texstudio --no-install-recommends

# Format and remove duplicated packages from list file
sed 's/ /\n/g' ${package_list_file} | sort -V | uniq > tmp && rm ${package_list_file} && mv tmp ${package_list_file}

# Install packages
sudo apt-get -y install $(grep -vE "^\s*#" ${package_list_file}  | tr "\n" " ")

# Custom configuration
# Nemo file manager configuration
gsettings set org.nemo.extensions.nemo-terminal default-visible false # disable terminal as default
gsettings set org.nemo.preferences start-with-dual-pane true # open dual pane as default

# Fix Nemo icon
cp /usr/share/applications/nemo.desktop $HOME/.local/share/applications
sudo mv /usr/share/applications/nemo.desktop /usr/share/applications/nemo.desktop.bak
sed -i 's/Icon=folder/Icon=nemo/g' $HOME/.local/share/applications/nemo.desktop