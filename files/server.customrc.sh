#!/bin/bash

# CUSTOM CONFIGURATION
################################################################################
# Common configuration (aliases, variables and functions)
source .common.config.sh;

# ==============================================================================
# Aliases
# ==============================================================================

# ==============================================================================
# Variables
# ==============================================================================

# ==============================================================================
# Aliases
# ==============================================================================

# ==============================================================================
# Functions
# ==============================================================================

# alias column="column -s'	' -t ";
# alias conserver='ssh -X hfen3@thebeast.biology.gatech.edu'
# alias consting='ssh hfen3@sting.biosci.gatech.edu'
# alias convann='ssh -X hfen3@gpuvannberg.biology.gatech.edu'
# alias concomp='ssh -X hfen3@compgenome2016.biology.gatech.edu'
# alias conbrow='ssh -X hfen3@gbrowse2016.biology.gatech.edu'
# alias ec='expressvpn connect smart'
# alias ed='expressvpn disconnect'
# # alias gatk='java -jar /home/hspitia/.software/gatk/GenomeAnalysisTK.jar'
# alias grep='grep --color=always'
# alias gst="git status";
# # alias l='ls -lhA';
# alias lh='ls -lh';
# alias lstmplts='ls $LOCAL_SCRIPTS/templates';
# alias prettyjson='python -m json.tool'
# alias vu='nmcli con up id gatech'
# alias vd='nmcli con down id gatech'
# alias xtermcolors='ruby -e "$(curl -fsSL https://raw.githubusercontent.com/gawin/bash-colors-256/master/colors)"'
# # ===================================================================
# # Variables
# # ===================================================================
# # PATH
# export LOCAL_SOFTWARE=$HOME/.software;
# export LOCAL_BIN=$LOCAL_SOFTWARE/bin;
# export LOCAL_SCRIPTS=$LOCAL_SOFTWARE/scripts;
# export LOCAL_DIR=$HOME/.local;
# export CONDA=$LOCAL_SOFTWARE/anaconda3;

# export CONFIG_DIR=$HOME/.dotfiles;
# export CONF_FILES_DIR=$CONFIG_DIR/files;
# export CONF_SETTINGS_DIR=$CONFIG_DIR/settings;
# export CONF_UTILS_DIR=$CONFIG_DIR/utils;
# export CONF_SCRIPTS_DIR=$CONFIG_DIR/scripts;
# export CONF_PACKAGES_DIR=$CONFIG_DIR/packages;

# export TEMPLATES_DIR=$LOCAL_SCRIPTS/templates;
# export BRC=$HOME/.bashrc;
# export HRC=$HOME/.customrc.sh;
# export ZRC=$HOME/.zshrc;
# export ZPREZTORC=$HOME/.zprestorc;

# export ANACONDA=$LOCAL_SOFTWARE/anaconda3/bin;
# #export MINICONDA=$LOCAL_SOFTWARE/miniconda3/bin;

# export PATH=$LOCAL_SOFTWARE:$LOCAL_BIN:$ANACONDA:$LOCAL_SCRIPTS:$TEMPLATES_DIR:$LOCAL_DIR/bin:$PATH;


# # Perl
# eval `perl -I ~/perl5/lib/perl5 -Mlocal::lib`
# export MANPATH=$HOME/perl5/man:$MANPATH

# # ====================================================================
# # Functions
# # ====================================================================
# # Clone a git repository located at thebeast server (gatech)
# function clonerepotb {
#   git clone ssh://hfen3@thebeast.biology.gatech.edu:/data/home/hfen3/git_repos/$1
# }

# # copy a script template
# function cptemplate {
#   command="cp ${TEMPLATES_DIR}/$1 $2";
#   echo $command;
#   eval $command;
# }

# function vfile {
#   column -s'	' -t $1 | less -SN
# }

# function reheader {
#     cat $2 $1 > tmp;
#     rm -fr $1;
#     mv tmp $1;
# }

# # ====================================================================
# # Sources
# # ====================================================================

# # source $GIT_EXTRAS/git-prompt.sh;
# # source $HOME/projects/nthi/scripts/load_path_variables.sh;

# ## Tilix
# #if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
# #        source /etc/profile.d/vte.sh
# #fi

