#! /usr/bin/env bash

# logger -s hi there

usage() {
  echo "usage: $1 -m <MODE> [options]

This script sets up the configuration from .dotfiles repository

ARGUMENTS:
   -m  MODE    Configuration mode. Valid values are 'd' for desktop, and 's' for server.

OPTIONS:
   -p FILE     File with the list of ubuntu packages to be installed
   -v          Verbose 
   -h          Show this message
"
  exit 1
}

# scriptName=${(%):-%N};
scriptName=$(basename "$0")

# Variables
# General
CONFIG_DIR="$HOME/.dotfiles";
CONF_FILES_DIR="$CONFIG_DIR/files";
CONF_SETTINGS_DIR="$CONFIG_DIR/settings";
CONF_UTILS_DIR="$CONFIG_DIR/utils";
CONF_SCRIPTS_DIR="$CONFIG_DIR/scripts";
CONF_PACKAGES_DIR="$CONFIG_DIR/packages";
BAK_FILES=(bashrc condarc common.config.sh customrc.sh gitconfig zprezto zshrc)
LINK_FILES=(bashrc condarc common.config.sh customrc.sh gitconfig)

# Options
mode=
verbose=
package_file="${CONF_PACKAGES_DIR}/packages.list.txt"
while getopts “m:p:vh” OPT
do
    case $OPT in
        m)
            mode=$OPTARG
            ;;
        p)
            package_file=$OPTARG
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
if [[ "$mode" == "" ]]; then
    echo "ERROR: option -m is required\n";
    usage $scriptName;
    exit 1;
fi

prefix=
if [[ "$mode" == "d" ]]; then
    prefix="desktop";
elif [[ "$mode" == "s" ]]; then
    prefix="server";
else
    echo "ERROR: Invalid value for -m.\n";
    usage $scriptName;
    exit 1;
fi

# =======================================================
# Begin of code 

if [[ "$prefix" == "desktop" ]]; then
    # Install azsh and git
    test -z $(which git) && sudo apt install git -y;
    test -z $(which zsh) && sudo apt install zsh -y;
    # sudo apt -y install zsh git
fi


# Clone dotfiles
test ! -d "$CONFIG_DIR" && git clone git@github.com:hspitia/dotfiles.git $CONFIG_DIR


# backup files
for f in ${BAK_FILES[@]}; do
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
if [[ "$prefix" == "desktop" ]]; then
    # sudo apt -y install zsh git
    test ! -d "${ZDOTDIR:-$HOME}/.zprezto" && $CONF_SCRIPTS_DIR/install.prezto.zsh
fi


# ##############################################################################
# Custom dotfiles
# ##############################################################################

for f in $(ls "${CONF_FILES_DIR}/${prefix}".*); do
    outName=$(basename $f | sed 's/'${prefix}'//g')
    cmd="ln -s ${f} $HOME/${outName}";
    echo $cmd;
    eval $cmd;
done

source .zshrc

# # ##############################################################################
# # Custom folders
# # ##############################################################################
# # Scripts
# if [[ ! -d "${LOCAL_SOFTWARE}" ]]; then
#     mkdir ${LOCAL_SOFTWARE};
# fi

# # ### git clone https://hspitia@bitbucket.org/hspitia/scripts.git ${LOCAL_SCRIPTS}
# git clone git@github.com:hspitia/scripts.git ${LOCAL_SCRIPTS}

# # # Sounds
# # ln -s $CONF_SETTINGS_DIR/sounds ${HOME}/.sounds

# # # Variety
# # if [ -d "${HOME}/.config/variety" ]; then
# #     mv ${HOME}/.config/variety ${HOME}/.config/variety.bak
# # fi

# # ln -s $CONF_SETTINGS_DIR/variety ${HOME}/.config/variety

# # # # RStudio
# # # if [ -d "${HOME}/.rstudio-desktop" ]; then
# # #     mv ${HOME}/.rstudio-desktop ${HOME}/.rstudio-desktop.bak
# # # fi

# # # ln -s $CONF_SETTINGS_DIR/rstudio-desktop ${HOME}/.rstudio-desktop


# # # ##############################################################################
# # # Packages
# # # ##############################################################################

# # # Add repos
# # $CONF_SCRIPTS_DIR/add_apt_repos.sh ${CONF_PACKAGES_DIR}/repos.list.txt &&
# # # Install packages
# # $CONF_SCRIPTS_DIR/install_packages.sh ${CONF_PACKAGES_DIR}/packages.list.txt &&

# ##############################################################################
# Custom configuration
# ##############################################################################
# Gnome terminal configuraton
dconf reset -f /org/gnome/terminal/
dconf load /org/gnome/terminal/ < ${CONF_SETTINGS_DIR}/gnome_terminal.settings.txt
# dconf write /org/gnome/shell/extensions/dash-to-dock/show-apps-at-top true

# Nemo file manager configuration
gsettings set org.nemo.extensions.nemo-terminal default-visible false # disable terminal as default
gsettings set org.nemo.preferences start-with-dual-pane true # open dual pane as default

# Fix Nemo icon
cp /usr/share/applications/nemo.desktop $HOME/.local/share/applications
sudo mv /usr/share/applications/nemo.desktop /usr/share/applications/nemo.desktop.bak
sed -i 's/Icon=folder/Icon=nemo/g' $HOME/.local/share/applications/nemo.desktop

# End of code =======================================================