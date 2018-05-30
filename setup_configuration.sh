#!/usr/bin/env zsh

CONFIG_DIR=$HOME/.dotfiles;
FILES_DIR=$CONFIG_DIR/files;
SETTINGS_DIR=$CONFIG_DIR/settings;
UTILS_DIR=$CONFIG_DIR/utils;

#git clone git@github.com:hspitia/dotfiles.git $CONFIG_DIR

# FILES=(bashrc condarc customrc.sh gitconfig zprezto zshrc)
FILES=(bashrc condarc customrc.sh gitconfig zprezto zshrc)

## backup files
#for f in ${FILES[@]}; do
#    if [[ -e "$HOME/.${f}" ]]; then
#        cmd="mv $HOME/.${f} $HOME/.${f}.bak";
#        echo $cmd;
#        eval $cmd;
#    fi
#done

## ##############################################################################
## Prezto
## ##############################################################################
## install prezto from my own fork
#sudo apt -y install zsh git
#zsh
#git clone --recursive https://github.com/hspitia/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

## create symbolic links
#setopt EXTENDED_GLOB
#for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
#  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
#done

## update repo and submodules
#cd $ZPREZTODIR
#git pull
#git submodule update --init --recursiv

# ##############################################################################
# Custom dotfiles
# ##############################################################################
FILES=(bashrc condarc customrc.sh gitconfig)

for f in $(ls "${FILES_DIR}"); do
    cmd="ln -s ${FILES_DIR}/${f} $HOME/.${f}";
    echo $cmd;
    eval $cmd;
done

# gnome terminal configuraton
dconf reset -f /org/gnome/terminal/
dconf load /org/gnome/terminal/ < ${SETTINGS_DIR}/gnome_terminal.settings.txt
dconf write /org/gnome/shell/extensions/dash-to-dock/show-apps-at-top true
