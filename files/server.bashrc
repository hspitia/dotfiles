# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

##############################################
# CUSTOM CONFIGURATION
##############################################

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# ===================================================================
# Sources
# ===================================================================
source $HOME/.customrc.sh;

# ===================================================================
# Variables
# ===================================================================
export GIT_EXTRAS=$CONFIG_UTILS_DIR/gitextras;

# ===================================================================
# Prompt
# ===================================================================
export PS1='[\u@\h \[\e[36m\]\w\[\e[38;5;172m\]$(__git_ps1 " (%s)")\[\e[00m\]]\$ ';

source $GIT_EXTRAS/git-prompt.sh;