# ===================================================================
# Aliases
# ====================================================================
alias awk='awk -F"\t"'
alias ba="byobu a -t";
alias column="column -s'	' -t ";
alias conserver='ssh -X hfen3@thebeast.biology.gatech.edu'
alias consting='ssh hfen3@sting.biosci.gatech.edu'
alias convann='ssh -X hfen3@gpuvannberg.biology.gatech.edu'
alias concomp='ssh -X hfen3@compgenome2016.biology.gatech.edu'
alias conbrow='ssh -X hfen3@gbrowse2016.biology.gatech.edu'
alias conusda='ssh -X robertshatters@10.251.28.128' 
alias concano='ssh -X canolab_hpserver@10.251.28.118' 
# alias conusda='ssh -X hespitianavarro@10.251.28.128' 
alias grep='grep --color=always'
alias gst="git status";
# alias l='ls -lhA';
alias lh='ls -lh';
alias lstmplts='ls $LOCAL_SCRIPTS/templates';
alias xtermcolors='ruby -e "$(curl -fsSL https://raw.githubusercontent.com/gawin/bash-colors-256/master/colors)"'
# cvstk aliases
alias csvtk='csvtk -t';
alias cahead='csvtk add-header';
alias ccut='csvtk cut';
alias cdhead='csvtk del-header';
alias cgrep='csvtk grep';
alias cmut='csvtk mutate';
alias cmut2='csvtk mutate2';
alias cpret='csvtk pretty';
alias csort='csvtk sort';
alias ctrn='csvtk transpose';
alias ec='expressvpn connect smart'
alias ed='expressvpn disconnect'
alias prettyjson='python -m json.tool'
alias vu='nmcli con up id gatech'
alias vd='nmcli con down id gatech'
alias glu='nmcli con up id glink'
alias gld='nmcli con down id glink'
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

export KENTUTILS=$LOCAL_SOFTWARE/kentutils;

export COMMON_PATH_VARS=$LOCAL_SOFTWARE:$KENTUTILS:$LOCAL_BIN:$LOCAL_SCRIPTS:$TEMPLATES_DIR:$LOCAL_DIR/bin;

export blast_fields="qseqid sseqid pident length qlen mismatch gapopen qstart qend sstart send evalue bitscore sstrand qcovhsp"
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

function cfile {
  cat $1 | csvtk -t pretty | less -S
}

function reheader {
  local $file=$1
  local $header=$2
  cat "$header" "$file" > tmp;
  rm -fr "$file";
  mv tmp "$file";
}

function get_crtime {
  for target in "${@}"; do
      inode=$(stat -c '%i' "${target}")
      fs=$(df  --output=source "${target}"  | tail -1)
      crtime=$(sudo debugfs -R 'stat <'"${inode}"'>' "${fs}" 2>/dev/null | 
      grep -oP 'crtime.*--\s*\K.*')
      printf "%s\t%s\n" "${target}" "${crtime}"
  done
}

function cac {
  conda activate $1;
  export HOST=$(hostname)
}

function cde {
  conda deactivate;
  export HOST=$(hostname)
}