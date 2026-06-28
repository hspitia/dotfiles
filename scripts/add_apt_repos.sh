#!/usr/bin/env bash

set -euo pipefail

DRY_RUN="${DRY_RUN:-0}"

run_cmd() {
	if [[ "$DRY_RUN" == "1" ]]; then
		echo "[dry-run] $*"
	else
		"$@"
	fi
}

run_sh() {
	if [[ "$DRY_RUN" == "1" ]]; then
		echo "[dry-run] $*"
	else
		bash -lc "$*"
	fi
}

repo_list_file="${1:-}"

if [[ -z "${repo_list_file}" ]]; then
	echo "usage: $0 <repo_list_file>" >&2
	exit 1
fi

if [[ ! -f "${repo_list_file}" ]]; then
	echo "ERROR: repository list file not found: ${repo_list_file}" >&2
	exit 1
fi

if ! command -v add-apt-repository >/dev/null 2>&1; then
	echo "ERROR: add-apt-repository is required" >&2
	exit 1
fi

dist=""
if command -v lsb_release >/dev/null 2>&1; then
	dist="$(lsb_release -sc)"
fi

while IFS= read -r raw_line || [[ -n "$raw_line" ]]; do
	line="${raw_line%%#*}"
	line="${line%${line##*[![:space:]]}}"
	line="${line#${line%%[![:space:]]*}}"

	[[ -z "$line" ]] && continue
	if [[ -n "$dist" ]]; then
		line="${line//'${dist}'/$dist}"
	fi

	if [[ "$line" == \"*\" && "$line" == *\" ]]; then
		line="${line#\"}"
		line="${line%\"}"
	elif [[ "$line" == \'*\' && "$line" == *\' ]]; then
		line="${line#\'}"
		line="${line%\'}"
	fi

	if [[ "$line" == ppa:* || "$line" == deb* ]]; then
		echo "[repos] add-apt-repository: $line"
		run_cmd sudo add-apt-repository -y "$line"
	elif [[ "$line" == sudo* || "$line" == apt-key* || "$line" == wget* || "$line" == curl* ]]; then
		echo "[repos] running command: $line"
		run_sh "$line"
	else
		echo "[repos] Skipping unsupported entry: $line"
	fi
done < "$repo_list_file"




