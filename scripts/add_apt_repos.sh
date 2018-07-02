#!/bin/bash

repo_list_file=$1; # package list file 

dist=$(lsb_release -sc);

# while read -r repo || [[ -n "$repo" ]]; do
while read -r repo s; do
	[[ "$repo" =~ ^#.*$ || "$repo" =~ ^$ ]] && continue # Ignore blank and commented lines

	cmd="sudo add-apt-repository -y ${repo}"
	echo $cmd;
	# eval $cmd;

done < "$repo_list_file"




