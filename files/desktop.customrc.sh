#!/bin/bash

# CUSTOM CONFIGURATION
################################################################################
# Common configuration (aliases, variables and functions)
source $HOME/.common.config.sh;

# ==============================================================================
# Aliases
# ==============================================================================
alias ec='expressvpn connect smart'
alias ed='expressvpn disconnect'
alias prettyjson='python -m json.tool'
# ==============================================================================
# Variables
# ==============================================================================

export PATH="$COMMON_PATH_VARS:$PATH"

export JULIA="$LOCAL_SOFTWARE/julia-1.1.0/bin"
export PATH="$JULIA:$PATH"
# # Perl
# eval `perl -I ~/perl5/lib/perl5 -Mlocal::lib`
# export MANPATH=$HOME/perl5/man:$MANPATH

# Lib path Java
export LD_LIBRARY_PATH="/usr/lib/jvm/java-8-oracle/lib/amd64:/usr/lib/jvm/java-8-oracle/jre/lib/amd64/server:$LD_LIBRARY_PATH"
# export JAVA_LD_LIBRARY_PATH="/usr/lib/jvm/java-8-oracle/lib/amd64/server:$JAVA_LD_LIBRARY_PATH"

# ==============================================================================
# Functions
# ==============================================================================


# # ====================================================================
# # Sources
# # ====================================================================

# # source $GIT_EXTRAS/git-prompt.sh;
# # source $HOME/projects/nthi/scripts/load_path_variables.sh;

# ## Tilix
# #if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
# #        source /etc/profile.d/vte.sh
# #fi


# # >>> conda initialize >>>
# # !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/home/hspitia/.software/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/home/hspitia/.software/anaconda3/etc/profile.d/conda.sh" ]; then
#         . "/home/hspitia/.software/anaconda3/etc/profile.d/conda.sh"
#     else
#         export PATH="/home/hspitia/.software/anaconda3/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# # <<< conda initialize <<<
# export HOST=$(hostname)

