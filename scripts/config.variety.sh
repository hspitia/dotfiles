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

if ! command -v variety >/dev/null 2>&1; then
  echo "ERROR: variety is not installed" >&2
  exit 1
fi

CONFIG_DIR="${HOME}/.dotfiles"
VARIETY_SETTINGS_DIR="${CONFIG_DIR}/settings/variety"
VARIETY_CONFIG_DIR="${HOME}/.config/variety"

echo "[variety] Applying Variety configuration"

# Create config directory if it doesn't exist
run_cmd mkdir -p "${VARIETY_CONFIG_DIR}"

# Copy main configuration file
if [[ -f "${VARIETY_SETTINGS_DIR}/variety.conf" ]]; then
  run_cmd cp "${VARIETY_SETTINGS_DIR}/variety.conf" "${VARIETY_CONFIG_DIR}/variety.conf"
  echo "[variety] Copied variety.conf"
else
  echo "[variety] WARNING: variety.conf not found at ${VARIETY_SETTINGS_DIR}/variety.conf"
fi

# Copy slideshow configuration
if [[ -f "${VARIETY_SETTINGS_DIR}/variety_slideshow.json" ]]; then
  run_cmd cp "${VARIETY_SETTINGS_DIR}/variety_slideshow.json" "${VARIETY_CONFIG_DIR}/variety_slideshow.json"
  echo "[variety] Copied variety_slideshow.json"
fi

# Copy banned wallpapers list
if [[ -f "${VARIETY_SETTINGS_DIR}/banned.txt" ]]; then
  run_cmd cp "${VARIETY_SETTINGS_DIR}/banned.txt" "${VARIETY_CONFIG_DIR}/banned.txt"
  echo "[variety] Copied banned.txt"
fi

# Copy history
if [[ -f "${VARIETY_SETTINGS_DIR}/history.txt" ]]; then
  run_cmd cp "${VARIETY_SETTINGS_DIR}/history.txt" "${VARIETY_CONFIG_DIR}/history.txt"
  echo "[variety] Copied history.txt"
fi

# Copy wallpaper folder contents
if [[ -d "${VARIETY_SETTINGS_DIR}/wallpaper" ]]; then
  run_cmd mkdir -p "${VARIETY_CONFIG_DIR}/wallpaper"
  run_cmd cp -r "${VARIETY_SETTINGS_DIR}/wallpaper"/* "${VARIETY_CONFIG_DIR}/wallpaper/" 2>/dev/null || true
  echo "[variety] Copied wallpaper folder"
fi

# Copy scripts
if [[ -d "${VARIETY_SETTINGS_DIR}/scripts" ]]; then
  run_cmd mkdir -p "${VARIETY_CONFIG_DIR}/scripts"
  run_cmd cp -r "${VARIETY_SETTINGS_DIR}/scripts"/* "${VARIETY_CONFIG_DIR}/scripts/" 2>/dev/null || true
  run_cmd chmod +x "${VARIETY_CONFIG_DIR}/scripts"/* 2>/dev/null || true
  echo "[variety] Copied scripts"
fi

echo "[variety] Configuration applied"
