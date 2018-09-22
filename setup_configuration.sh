#!/usr/bin/env zsh

# logger -s hi there

usage() {
  print "usage: $1 -m <MODE> [options]

This script sets up the configuration from .dotfiles repository

OPTIONS:
   -m  MODE    Configuration mode. Valid values are 'd' for desktop, and 's' for server.
   -v          Verbose 
   -h          Show this message
"
  exit 1
}

scriptName=${(%):-%N};

mode=
verbose=
while getopts “m:vh” OPT
do
     case $OPT in
         m)
             mode=$OPTARG
             ;;
         h)
             usage $scriptName
             exit 1
             ;;
         v)
             verbose=1
             ;;
         ?)
             echo 
             usage $scriptName
             exit
             ;;
     esac
done

# =======================================================
# Arguments checking
if [[ $mode == "" ]]; then
    echo "ERROR: option -m is required\n";
    usage $scriptName;
    exit 1;
fi

prefix=
if [[ mode == "d" ]]; then
    prefix="desktop"
elif [[ mode == "s" ]]
    prefix="server"
else
    echo "ERROR: Invalid value for -m.\n";
    usage $scriptName;
    exit 1;
fi

# =======================================================
# Begin of code 


# Variables
CONFIG_DIR=$HOME/.dotfiles;
CONF_FILES_DIR=$CONFIG_DIR/files;
CONF_SETTINGS_DIR=$CONFIG_DIR/settings;
CONF_UTILS_DIR=$CONFIG_DIR/utils;
CONF_SCRIPTS_DIR=$CONFIG_DIR/scripts;
CONF_PACKAGES_DIR=$CONFIG_DIR/packages;

git clone git@github.com:hspitia/dotfiles.git $CONFIG_DIR

FILES=(bashrc condarc customrc.sh gitconfig zprezto zshrc)

# backup files
for f in ${FILES[@]}; do
   if [[ -e "$HOME/.${f}" ]]; then
       cmd="mv $HOME/.${f} $HOME/.${f}.bak";
       echo $cmd;
       eval $cmd;
   fi
done

# ##############################################################################
# Prezto
# ##############################################################################
# install prezto from my own fork
sudo apt -y install zsh git

$CONF_SCRIPTS_DIR/install.prezto.szh

# ##############################################################################
# Custom dotfiles
# ##############################################################################
FILES=(bashrc condarc customrc.sh gitconfig)

for f in $(ls "${CONF_FILES_DIR}"); do
    cmd="ln -s ${CONF_FILES_DIR}/${f} $HOME/.${f}";
    echo $cmd;
    eval $cmd;
done

source .zshrc

# ##############################################################################
# Custom folders
# ##############################################################################
# Scripts
if [[ ! -d "${LOCAL_SOFTWARE}" ]]; then
    mkdir ${LOCAL_SOFTWARE};
fi

git clone https://hspitia@bitbucket.org/hspitia/scripts.git ${LOCAL_SCRIPTS}

# Sounds
ln -s $CONF_SETTINGS_DIR/sounds .sounds

# ##############################################################################
# Packages
# ##############################################################################

# Add repos
$CONF_SCRIPTS_DIR/add_apt_repos.sh ${CONF_PACKAGES_DIR}/repos.list.txt &&
# Install packages
$CONF_SCRIPTS_DIR/install_packages.sh ${CONF_PACKAGES_DIR}/packages.list.txt &&

# ##############################################################################
# Custom configuration
# ##############################################################################
# Gnome terminal configuraton
dconf reset -f /org/gnome/terminal/
dconf load /org/gnome/terminal/ < ${CONF_SETTINGS_DIR}/gnome_terminal.settings.txt
dconf write /org/gnome/shell/extensions/dash-to-dock/show-apps-at-top true

# Nemo file manager configuration
gsettings set org.nemo.extensions.nemo-terminal default-visible false # disable terminal as default
gsettings set org.nemo.preferences start-with-dual-pane true # open dual pane as default

# Fix Nemo icon
cp /usr/share/applications/nemo.desktop $HOME/.local/share/applications
sudo mv /usr/share/applications/nemo.desktop /usr/share/applications/nemo.desktop.bak
sed -i 's/Icon=folder/Icon=nemo/g' $HOME/.local/share/applications/nemo.desktop

# End of code 
=======================================================