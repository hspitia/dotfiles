#!/bin/bash

# set -e              # errexit exit whenever a command exits with a non zero status 
# set -u              # Undefined variables as errors
# set -o pipefail     # Non zero status in a pipe when one command has one non zero status

# =============================================================
# Author:      Héctor Fabio Espitia Navarro
# Date:        
# Version:     
# Description: 
# =============================================================

# Input arguments to variables
blacklistFile=$1;
# base variables
verbose=1;
setName="blacklist"
# =======================================================
# Functions
# -------------------------------------------------------
# Verbose message
function log() {
    if [[ "$verbose" -eq 1 ]]; then
        echo -e "$@"
    fi
}

# Usage message
function usage() 
{
    scriptNameSize=${#0};
    line="";
    for i in $(seq 1 $scriptNameSize); do 
        line="${line}="; 
    done;

cat << EOF
$0
$line

This script adds IP addresses from a blacklist file, to iptables. This script 
requires the ipset program.

Usage: 
    $0 [options] <blacklist_file>

Arguments:
    blacklist_file    Text file with IP addresses, one each line,
                      with the format ip:port or name:port. Example:

                      51.15.69.136:4675
                      aeon.pool.minergate.com:45690
Options:
    -h --help         Show this message and exit.
EOF
}
# =======================================================
# Check for arguments
if [[ $blacklistFile == "" || $blacklistFile == "-h" || $blacklistFile == "--help" ]]; then
    usage;
    exit 1;
fi

# Check for required programs
ipsetLocation=$(which ipset)
if [[ "$ipsetLocation" == "" ]]; then
    echo -e "$0: ipset is not installed" 1>&2
    exit 1;
fi

# Validate IP address format
function isValid() {
    if [[ "$1" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
      echo 1
    else
      echo 0
    fi
}
# Begin of code =======================================================

# res=$(isValid "mph-1535617039.us-east-1.elb.amazonaws.com.")
# echo "resultado: $res"


setInfo=$(sudo ipset list)
setExists=$(echo -e "$setInfo" | grep Name | grep -c $setName)

if [[ "$setExists" -eq 0 ]]; then
    log "Creating set \"${setName}\""
    cmd="sudo ipset create ${setName} hash:ip,port hashsize 4096"
    log $cmd;
    eval $cmd;
    log "Done!"
fi

# Set up iptables rules. Match with blacklist and drop traffic
log "Setting up iptables rules based on set \"${setName}\""
cmd="sudo iptables -I INPUT -m set --match-set blacklist src -j DROP"
log $cmd;
eval $cmd;
cmd="sudo iptables -I FORWARD -m set --match-set blacklist src -j DROP"
log $cmd;
eval $cmd;
log -e "Done!"

log "Adding IP from file to set \"$setName\""

while IFS=$':' read -r domain port
do
    echo $domain
    ips=$(dig +short ${domain})

    for ip in $(echo $ips); do
        ipStatus=$(isValid $ip)
        if [[ $ipStatus -eq 1 ]]; then
            cmd="sudo ipset add ${setName} ${ip},${port}"
            log $cmd;
            eval $cmd;
        fi
    done
done < "$blacklistFile"
log -e "Done!"

# End of code =========================================================
