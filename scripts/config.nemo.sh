#! /usr/bin/env bash

# adapted from https://forums.linuxmint.com/viewtopic.php?t=311974

accels_dir=~/.gnome2/accels
source_accels_file=$HOME/.dotfiles/settings/nemo/custom_nemo_accelsrc
dest_accels_file=$accels_dir/nemo

test ! -d "$accels_dir" && mkdir -p "$accels_dir"
ln -sf $source_accels_file $dest_accels_file

ls -lh "$accels_dir"