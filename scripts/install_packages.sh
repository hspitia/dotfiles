#!/bin/bash

package_list_file=$1; # package list file 
# repo_list_file=$2; # package list file 

dist=$(lsb_release -sc);

# Install Keys
# sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9 # R language
# wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -

# R key
# sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9


# # Add repos
# ./add_apt_repos.sh $repo_list_file

sudo apt-get update
sudo apt-get dist-upgrade

# Packages without dependencies
# sudo apt-get -y install lyx --no-install-recommends
# sudo apt-get -y install tikzit --no-install-recommends
# sudo apt-get -y install texstudio --no-install-recommends

# Format and remove duplicated packages from list file
sed 's/ /\n/g' ${package_list_file} | sort -V | uniq > tmp && rm ${package_list_file} && mv tmp ${package_list_file}

# Install packages
sudo apt-get -y install $(grep -vE "^\s*#" ${package_list_file}  | tr "\n" " ")
