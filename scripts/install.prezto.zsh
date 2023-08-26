#!/usr/bin/env zsh

if [[ -d "${ZDOTDIR:-$HOME}/.zprezto" ]]; then
    cmd="mv "${ZDOTDIR:-$HOME}/.zprezto" "${ZDOTDIR:-$HOME}/zprezto.old
    echo $cmd;
    eval $cmd
fi

cmd="git clone --recursive https://github.com/hspitia/prezto.git "${ZDOTDIR:-$HOME}/.zprezto;
echo $cmd;
eval $cmd;

# create symbolic links
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
    cmd="ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}
    echo $cmd;
    # eval $cmd;
done

# update repo and submodules
echo ${ZDOTDIR:-$HOME}/.zprezto
cd ${ZDOTDIR:-$HOME}/.zprezto
git pull
git submodule update --init --recursive