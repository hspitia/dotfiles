#!/bin/bash

# CUSTOM CONFIGURATION
################################################################################
# ===================================================================
# Aliases
# ====================================================================

alias conserver='ssh -X hfen3@thebeast.biology.gatech.edu'
alias convann='ssh -X hfen3@gpuvannberg.biology.gatech.edu'
alias concomp='ssh -X hfen3@compgenome2016.biology.gatech.edu'
alias conbrow='ssh -X hfen3@gbrowse2016.biology.gatech.edu'
# alias gatk='java -jar /home/hspitia/.software/gatk/GenomeAnalysisTK.jar'
alias grep='grep --color=always'
alias vu='nmcli con up id gatech'
alias vd='nmcli con down id gatech'
alias lstmplts='ls $LOCAL_SCRIPTS/templates';
alias xtermcolors='ruby -e "$(curl -fsSL https://raw.githubusercontent.com/gawin/bash-colors-256/master/colors)"'
alias column="column -txs'      '";
alias gst="git status";
alias lh='ls -lh';
# alias l='ls -lhA';

# ===================================================================
# Variables
# ===================================================================
# PATH
export LOCAL_SOFTWARE=$HOME/.software;
export LOCAL_BIN=$LOCAL_SOFTWARE/bin;
export LOCAL_SCRIPTS=$LOCAL_SOFTWARE/scripts;
export LOCAL_DIR=$HOME/.local;

export CONFIG_DIR=$HOME/.dotfiles;
export CONF_FILES_DIR=$CONFIG_DIR/files;
export CONF_SETTINGS_DIR=$CONFIG_DIR/settings;
export CONF_UTILS_DIR=$CONFIG_DIR/utils;
export CONF_SCRIPTS_DIR=$CONFIG_DIR/scripts;
export CONF_PACKAGES_DIR=$CONFIG_DIR/packages;

export TEMPLATES_DIR=$LOCAL_SCRIPTS/templates;
export BRC=$HOME/.bashrc;
export HRC=$HOME/.customrc.sh;
export ZRC=$HOME/.zshrc;
export ZPREZTORC=$HOME/.zprestorc;

export ANACONDA=$LOCAL_SOFTWARE/anaconda3/bin;
#export MINICONDA=$LOCAL_SOFTWARE/miniconda3/bin;

export PATH=$LOCAL_SOFTWARE:$LOCAL_BIN:$ANACONDA:$LOCAL_SCRIPTS:$LOCAL_DIR/bin:$PATH;

## export ART=$LOCAL_SOFTWARE/art;
## export ARTEMIS=$LOCAL_SOFTWARE/artemis;
#export ARTEMIS="";
#export BCFTOOLS=$LOCAL_SOFTWARE/bcftools/1.2;
#export BEDTOOLS=$LOCAL_SOFTWARE/bedtools/2/bin;
#export BLAST=$LOCAL_SOFTWARE/ncbi-blast/2.2.31/bin;
#export BLAT=$LOCAL_SOFTWARE/blat;
## export BLAST2GO=$LOCAL_SOFTWARE/blast2go;
#export BOWTIE2=$LOCAL_SOFTWARE/bowtie2/2.2.6;
#export BWA=$LOCAL_SOFTWARE/bwa/0.7.12-r1044;
#export CDHIT=$LOCAL_SOFTWARE/cdhit/4.6.5;
#export ECLIPSE=$LOCAL_SOFTWARE/eclise;
#export EDIRECT=$LOCAL_SOFTWARE/edirect;
#export FASTQC=$LOCAL_SOFTWARE/fastqc;
#export FOURKSTOGRAM=$LOCAL_SOFTWARE/4kstogram;
#export GATK=$LOCAL_SOFTWARE/gatk;
#export GENEMARK=$LOCAL_SOFTWARE/gmsuite;
#export GIT_EXTRAS=$LOCAL_SOFTWARE/gitextras;
#export HTSLIB=$LOCAL_SOFTWARE/htslib/1.2.1/bin;
#export LSBSR=$LOCAL_SOFTWARE/lsbsr;
#export MAUVE=$LOCAL_SOFTWARE/mauve;
#export MESQUITE=$LOCAL_SOFTWARE/mesquite;
#export MUMMER=$LOCAL_SOFTWARE/mummer;
#export NODEJS=$LOCAL_SOFTWARE/nvm/versions/node/v6.10.2/bin;
## export NODEJS=$LOCAL_SOFTWARE/nvm/versions/node/v6.10.2/bin/npm;
#export ParallelMETA=$LOCAL_SOFTWARE/parallel-meta/2.1;
#export PARALLELMETA=$LOCAL_SOFTWARE/parallel-meta/2.1/bin;
#export POPCORN=$LOCAL_SOFTWARE/popcorn;
#export PROCESSING=$LOCAL_SOFTWARE/processing/3.3;
#export PRODIGAL=$LOCAL_SOFTWARE/prodigal/2.5;
#export QT=$LOCAL_SOFTWARE/qt/5.6/gcc_64/bin;
## export QTCREATOR=$LOCAL_SOFTWARE/qt/Tools/QtCreator/bin;
#export QTCREATOR=$LOCAL_SOFTWARE/qtcreator/4.1.0/bin;
#export RDPTOOLS=$LOCAL_SOFTWARE/rdptools;
#export SRATOOLKIT=$LOCAL_SOFTWARE/sratoolkit/2.8.1-3/bin;
#export TESTDISK=$LOCAL_SOFTWARE/testdisk;
#export WINE=$LOCAL_SOFTWARE/wine/2.0/bin;

#export TEXLIVE=/usr/local/texlive/2015/bin/x86_64-linux;

#export PATH=$LOCAL_DIR/bin:$LOCAL_SOFTWARE:$LOCAL_BIN:$MINICONDA:$ANACONDA:$LOCAL_SCRIPTS:$TEMPLATES_DIR:$WINE:$VSEARCH:$USEARCH:$TEXLIVE:$TESTDISK:$SRATOOLKIT:$RDPTOOLS:$QTCREATOR:$QT:$PRODIGAL:$PROCESSING:$POPCORN:$PARALLELMETA:$ParallelMETA:$NODEJS:$MUMMER:$MESQUITE:$MAUVE:$LSBSR:$HTSLIB:$GENEMARK:$GATK:$EDIRECT:$ECLIPSE:$CDHIT:$BWA:$BOWTIE2:$BLAT:$BLAST2GO:$BLAST:$BEDTOOLS:$BCFTOOLS:$ARTEMIS:$FOURKSTOGRAM:$PATH;

## ====================================================================
## Other variables
#export INFOPATH=$INFOPATH:/usr/local/texlive/2015/texmf-dist/doc/info;
#export MANPATH=$MANPATH:/usr/local/texlive/2015/texmf-dist/doc/man;
#export PKG_CONFIG_PATH=$LOCAL_SOFTWARE/lib/pkgconfig:$PKG_CONFIG_PATH
#export PYTHONPATH=$LSBSR:$PYTHONPATH

## ====================================================================
## Anaconda 3
#export PATH="$LOCAL_SOFTWARE/anaconda3/bin:$PATH"

## ====================================================================
## T-COFFEE variables
#export DIR_4_TCOFFEE="/home/hspitia/.software/tcoffee/11.00.8cbe486"
#export MAFFT_BINARIES="$DIR_4_TCOFFEE/plugins/linux/"
#export CACHE_4_TCOFFEE="/home/hspitia/.t_coffee/cache/"
#export TMP_4_TCOFFEE="$DIR_4_TCOFFEE/tmp/"
#export LOCKDIR_4_TCOFFEE="$DIR_4_TCOFFEE/lck/"
#export PERL5LIB="$PERL5LIB:$DIR_4_TCOFFEE/perl/lib/perl5"
#export EMAIL_4_TCOFFEE="hspitia@gmail.com"
#export PATH="$DIR_4_TCOFFEE/bin:$PATH"
# ====================================================================
# terminix configuration: VTE (Virtual Terminal Emulator)
#. /etc/profile.d/vte.sh

# ====================================================================

# Get aliases for RDPtools applications
# source $RDPTOOLS/aliases;

# ====================================================================
# Functions
# ====================================================================
# Clone a git repository located at thebeast server (gatech)
function clonerepotb {
  git clone ssh://hfen3@thebeast.biology.gatech.edu:/data/home/hfen3/git_repos/$1
}

# copy a script template
function cptmplt {
  command="cp ${TEMPLATES_DIR}/$1 $2";
  echo $command;
  eval $command;
}


function vfile {
  column -s '	' -t $1 | less -SN
}

function reheader {
    cat $2 $1 > tmp;
    rm -fr $1;
    mv tmp $1;
}

# ====================================================================
# Sources
# ====================================================================

# source $GIT_EXTRAS/git-prompt.sh;
# source $HOME/projects/nthi/scripts/load_path_variables.sh;

## Tilix
#if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
#        source /etc/profile.d/vte.sh
#fi
