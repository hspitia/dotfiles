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

package_list_file="${1:-}"

if [[ -z "${package_list_file}" ]]; then
	echo "usage: $0 <package_list_file>" >&2
	exit 1
fi

if [[ ! -f "${package_list_file}" ]]; then
	echo "ERROR: package list file not found: ${package_list_file}" >&2
	exit 1
fi

if ! command -v sudo >/dev/null 2>&1; then
	echo "ERROR: sudo is required" >&2
	exit 1
fi

echo "[packages] Updating apt cache"
run_cmd sudo apt-get update -y

if [[ "${DO_UPGRADE:-0}" == "1" ]]; then
	echo "[packages] Running apt upgrade (dist-upgrade is disabled by default)"
	run_cmd sudo env DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
fi

mapfile -t packages < <(
	grep -vE '^\s*(#|$)' "${package_list_file}" | xargs -n1 | sort -u
)

if [[ "${#packages[@]}" -eq 0 ]]; then
	echo "[packages] No packages to install"
	exit 0
fi

echo "[packages] Installing ${#packages[@]} packages"
run_cmd sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y "${packages[@]}"
