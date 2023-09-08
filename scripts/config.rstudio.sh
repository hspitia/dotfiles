#!/bin/bash

CONFIG_DIR=$HOME/.dotfiles
CONF_FILES_DIR=$CONFIG_DIR/files
CONF_SETTINGS_DIR=$CONFIG_DIR/settings
CONF_UTILS_DIR=$CONFIG_DIR/utils
CONF_SCRIPTS_DIR=$CONFIG_DIR/scripts
CONF_PACKAGES_DIR=$CONFIG_DIR/packages

# Setup configuration
app_conf_dir="${HOME}/.config/rstudio"
app_conf_backup="${CONF_SETTINGS_DIR}/rstudio"

IFS=$'\n'
for d in $(ls -d "${app_conf_backup}/"*); do
    dir=$(basename "$d")
    for i in $(ls "${app_conf_backup}/$dir"); do
        conf_file=$dir/$i
        target_file=$app_conf_dir/$dir/$i
        test -f "$target_file" && mv "$target_file" "${target_file}.bak"
        cmd="ln -s \"${app_conf_backup}/${conf_file}\" \"${target_file}\""
        echo $cmd
        eval $cmd
    done
done

# ls -p "${app_conf_backup}/"**/* | grep -v /

# for f in $(find "${app_conf_backup}/" -maxdepth 2 -type f -printf '%f\n'); do
#     echo $f
# done

# for f in $(ls "${app_conf_backup}/"*); do
#     # test -f "$f" && mv "$f ${f}.bak"
#     cmd="ln -s \"${app_conf_backup}/${f}\" \"${app_conf_dir}/${f}\""
#     echo $cmd
#     # eval $cmd
# done

#1299
