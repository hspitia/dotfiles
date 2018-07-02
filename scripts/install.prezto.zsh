#!/usr/bin/env zsh

git clone --recursive https://github.com/hspitia/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

# create symbolic links
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
 ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

# update repo and submodules
cd $ZPREZTODIR
git pull
git submodule update --init --recursiv