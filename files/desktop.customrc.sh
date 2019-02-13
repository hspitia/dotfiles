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
alias vu='nmcli con up id gatech'
alias vd='nmcli con down id gatech'

# ==============================================================================
# Variables
# ==============================================================================

export PATH="$COMMON_PATH_VARS:$PATH"

# Perl
eval `perl -I ~/perl5/lib/perl5 -Mlocal::lib`
export MANPATH=$HOME/perl5/man:$MANPATH

# Lib path Java
export LD_LIBRARY_PATH="/usr/lib/jvm/java-8-oracle/lib/amd64:/usr/lib/jvm/java-8-oracle/jre/lib/amd64/server:$LD_LIBRARY_PATH"

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

