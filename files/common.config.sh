# ===================================================================
# Aliases
# ====================================================================
alias ba="byobu a -t";
alias column="column -s'	' -t ";
alias conserver='ssh -X hfen3@thebeast.biology.gatech.edu'
alias consting='ssh hfen3@sting.biosci.gatech.edu'
alias convann='ssh -X hfen3@gpuvannberg.biology.gatech.edu'
alias concomp='ssh -X hfen3@compgenome2016.biology.gatech.edu'
alias conbrow='ssh -X hfen3@gbrowse2016.biology.gatech.edu'
alias grep='grep --color=always'
alias gst="git status";
# alias l='ls -lhA';
alias lh='ls -lh';
alias lstmplts='ls $LOCAL_SCRIPTS/templates';
alias xtermcolors='ruby -e "$(curl -fsSL https://raw.githubusercontent.com/gawin/bash-colors-256/master/colors)"'

# ===================================================================
# Variables
# ===================================================================
# PATH
export LOCAL_SOFTWARE=$HOME/.software;
export LOCAL_BIN=$LOCAL_SOFTWARE/bin;
export LOCAL_SCRIPTS=$LOCAL_SOFTWARE/scripts;
export LOCAL_DIR=$HOME/.local;
export ANACONDA=$LOCAL_SOFTWARE/anaconda3;
export ANACONDA_BIN=$LOCAL_SOFTWARE/anaconda3/bin;

export CONFIG_DIR=$HOME/.dotfiles;
export CONFIG_FILES_DIR=$CONFIG_DIR/files;
export CONFIG_SETTINGS_DIR=$CONFIG_DIR/settings;
export CONFIG_UTILS_DIR=$CONFIG_DIR/utils;
export CONFIG_SCRIPTS_DIR=$CONFIG_DIR/scripts;
export CONFIG_PACKAGES_DIR=$CONFIG_DIR/packages;

export TEMPLATES_DIR=$LOCAL_SCRIPTS/templates;
export BRC=$HOME/.bashrc;
export HRC=$HOME/.customrc.sh;
export ZRC=$HOME/.zshrc;
export ZPREZTORC=$HOME/.zprestorc;

export COMMON_PATH_VARS=$LOCAL_SOFTWARE:$LOCAL_BIN:$ANACONDA_BIN:$LOCAL_SCRIPTS:$TEMPLATES_DIR:$LOCAL_DIR/bin;

# ===================================================================
# Aliases
# ====================================================================
alias ba="byobu a -t";
alias column="column -s'	' -t ";
alias conserver='ssh -X hfen3@thebeast.biology.gatech.edu'
# alias conjupyter='ssh -L 8000:localhost:8888 hfen3@thebeast.biology.gatech.edu'
alias consting='ssh hfen3@sting.biosci.gatech.edu'
alias convann='ssh -X hfen3@gpuvannberg.biology.gatech.edu'
alias concomp='ssh -X hfen3@compgenome2016.biology.gatech.edu'
alias conbrow='ssh -X hfen3@gbrowse2016.biology.gatech.edu'
alias grep='grep --color=always'
alias gst="git status";
# alias l='ls -lhA';
alias lh='ls -lh';
alias lstmplts='ls $LOCAL_SCRIPTS/templates';
alias xtermcolors='ruby -e "$(curl -fsSL https://raw.githubusercontent.com/gawin/bash-colors-256/master/colors)"'

# ====================================================================
# Functions
# ====================================================================
function conjupyter {
    ssh -L 8000:localhost:${1} hfen3@thebeast.biology.gatech.edu
}

# Clone a git repository located at thebeast server (gatech)
function clonerepotb {
  git clone ssh://hfen3@thebeast.biology.gatech.edu:/data/home/hfen3/git_repos/$1
}

# copy a script template
function cptemplate {
  command="cp ${TEMPLATES_DIR}/$1 $2";
  echo $command;
  eval $command;
}

function vfile {
  column $1 | less -SN
}

function reheader {
    local $file=$1
    local $header=$2
    cat "$header" "$file" > tmp;
    rm -fr "$file";
    mv tmp "$file";
}
