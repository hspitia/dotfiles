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

log() {
	echo "[nemo] $*"
}

source_accels_file="${HOME}/.dotfiles/settings/nemo/custom_nemo_accelsrc"
legacy_accels_dir="${HOME}/.gnome2/accels"
modern_accels_dir="${HOME}/.config/nemo/accels"
local_apps_dir="${HOME}/.local/share/applications"
local_nemo_desktop="${local_apps_dir}/nemo.desktop"

if [[ -f "$source_accels_file" ]]; then
	log "Installing Nemo accelerator configuration"
	run_cmd mkdir -p "$legacy_accels_dir"
	run_cmd mkdir -p "$modern_accels_dir"
	run_cmd ln -sfn "$source_accels_file" "${legacy_accels_dir}/nemo"
	run_cmd ln -sfn "$source_accels_file" "${modern_accels_dir}/nemo"
else
	log "WARNING: custom Nemo accelerator file not found: ${source_accels_file}"
fi

if [[ -f /usr/share/applications/nemo.desktop ]]; then
	log "Installing user-level Nemo desktop entry override"
	run_cmd mkdir -p "$local_apps_dir"
	run_cmd cp /usr/share/applications/nemo.desktop "$local_nemo_desktop"
	if [[ "$DRY_RUN" == "1" ]]; then
		echo "[dry-run] python-like edit nemo.desktop icon to Icon=nemo"
	else
		sed -i 's/^Icon=.*/Icon=nemo/' "$local_nemo_desktop"
	fi
fi

if command -v xdg-mime >/dev/null 2>&1; then
	log "Setting Nemo as default file manager"
	run_cmd xdg-mime default nemo.desktop inode/directory
	run_cmd xdg-mime default nemo.desktop application/x-gnome-saved-search
fi

if [[ "$DRY_RUN" != "1" ]] && command -v xdg-mime >/dev/null 2>&1; then
	log "Current inode/directory handler: $(xdg-mime query default inode/directory 2>/dev/null || true)"
	log "Current saved-search handler: $(xdg-mime query default application/x-gnome-saved-search 2>/dev/null || true)"
fi