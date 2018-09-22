#!/bin/bash

# CUSTOM CONFIGURATION
################################################################################
# Common configuration (aliases, variables and functions)
source .common.config.sh;

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

