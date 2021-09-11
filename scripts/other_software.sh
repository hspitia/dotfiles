#!/usr/bin/env bash

# R language
sudo apt install dirmngr gnupg apt-transport-https ca-certificates software-properties-common -y
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
sudo add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/'
sudo apt install r-base -y

# Google chrome
wget -O google-chrome-stable_current_amd64.deb "https://www.google.com/chrome/thank-you.html?installdataindex=empty&statcb=0&defaultbrowser=0#"

sudo gdebi --non-interactive google-chrome-stable_current_amd64.deb

# AnyDesk
wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add -
echo "deb http://deb.anydesk.com/ all main" | sudo tee /etc/apt/sources.list.d/anydesk-stable.list
sudo apt update
sudo apt install anydesk -y


# Visual Studio Code
wget -O code_stable.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" &&
sudo gdebi --non-interactive code_stable.deb &&
rm -fr code_stable.deb 

# Sublime Text 3
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo apt-get install apt-transport-https -y
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update
sudo apt-get install sublime-text -y

