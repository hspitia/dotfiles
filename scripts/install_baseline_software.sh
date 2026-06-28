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

if ! command -v sudo >/dev/null 2>&1; then
  echo "ERROR: sudo is required" >&2
  exit 1
fi

require_cmd() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "ERROR: required command not found: $cmd" >&2
    exit 1
  fi
}

DIST_CODENAME=""
if command -v lsb_release >/dev/null 2>&1; then
  DIST_CODENAME="$(lsb_release -sc)"
fi

echo "[baseline] Bootstrapping apt prerequisites (curl, wget, gnupg, repo helpers)"
run_cmd sudo apt-get update -y
run_cmd sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y \
  ca-certificates \
  curl \
  wget \
  gnupg \
  lsb-release \
  software-properties-common \
  apt-transport-https

echo "[baseline] Adding Google Chrome repository"
run_sh "curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg"

run_sh "echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list >/dev/null"

echo "[baseline] Adding VS Code repository"
run_sh "wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/packages.microsoft.gpg >/dev/null"

run_sh "echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main' | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null"

echo "[baseline] Adding Sublime Text repository"
run_sh "wget -qO- https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/sublimehq-archive.gpg >/dev/null"

run_sh "echo 'deb [signed-by=/usr/share/keyrings/sublimehq-archive.gpg] https://download.sublimetext.com/ apt/stable/' | sudo tee /etc/apt/sources.list.d/sublime-text.list >/dev/null"

echo "[baseline] Adding CRAN repository for R"
if [[ -n "$DIST_CODENAME" ]]; then
  run_sh "wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | gpg --dearmor | sudo tee /usr/share/keyrings/cran-archive-keyring.gpg >/dev/null"
  run_sh "echo 'deb [signed-by=/usr/share/keyrings/cran-archive-keyring.gpg] https://cloud.r-project.org/bin/linux/ubuntu ${DIST_CODENAME}-cran40/' | sudo tee /etc/apt/sources.list.d/cran-r.list >/dev/null"
fi

echo "[baseline] Refreshing apt metadata"
run_cmd sudo apt-get update -y

echo "[baseline] Installing baseline packages"
run_cmd sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y \
  zsh \
  git \
  nemo \
  tilix \
  variety \
  sublime-text \
  inkscape \
  pigz \
  okular \
  python3 \
  python3-pip \
  python3-venv \
  r-base \
  google-chrome-stable \
  code

echo "[baseline] Installing Numix icon theme"
if apt-cache show numix-icon-theme >/dev/null 2>&1; then
  run_cmd sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y numix-icon-theme
else
  echo "[baseline] numix-icon-theme package not available in apt repos for this release"
fi

echo "[baseline] Installing Numix Circle icon theme"
if apt-cache show numix-icon-theme-circle >/dev/null 2>&1; then
  run_cmd sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y numix-icon-theme-circle
else
  echo "[baseline] numix-icon-theme-circle package not available in apt repos for this release"
fi

echo "[baseline] Installing Ghostty"
if apt-cache show ghostty >/dev/null 2>&1; then
  run_cmd sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y ghostty
else
  echo "[baseline] ghostty package not present in apt repos; installing via Snap"
  run_cmd sudo snap install ghostty || echo "[baseline] ghostty snap install failed. Install manually from Ghostty releases if needed."
fi

echo "[baseline] Installing DisplayLink driver from Synaptics APT repository"
displaylink_keyring_deb="/tmp/synaptics-repository-keyring.deb"
displaylink_keyring_url="https://www.synaptics.com/sites/default/files/Ubuntu/pool/stable/main/all/synaptics-repository-keyring.deb"
secure_boot_enabled=0
if command -v mokutil >/dev/null 2>&1 && mokutil --sb-state 2>/dev/null | grep -qi 'SecureBoot enabled'; then
  secure_boot_enabled=1
fi

displaylink_force_install="${DISPLAYLINK_FORCE_INSTALL:-0}"
if [[ "$secure_boot_enabled" -eq 1 && "$displaylink_force_install" != "1" ]]; then
  echo "[baseline] Secure Boot is enabled; skipping DisplayLink driver because DKMS enrollment is not fully non-interactive."
  echo "[baseline] To force it, rerun with DISPLAYLINK_FORCE_INSTALL=1 and complete MOK enrollment on reboot."
elif [[ "$DRY_RUN" == "1" ]]; then
  echo "[dry-run] curl -fsSL ${displaylink_keyring_url} -o ${displaylink_keyring_deb}"
  echo "[dry-run] sudo apt-get install -y ${displaylink_keyring_deb}"
  echo "[dry-run] sudo apt-get update -y"
  echo "[dry-run] sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y displaylink-driver"
elif curl -fsSL "${displaylink_keyring_url}" -o "${displaylink_keyring_deb}"; then
  if ! run_cmd sudo apt-get install -y "${displaylink_keyring_deb}"; then
    echo "[baseline] WARNING: failed to install Synaptics keyring; skipping DisplayLink driver"
  elif ! run_cmd sudo apt-get update -y; then
    echo "[baseline] WARNING: apt metadata refresh failed; skipping DisplayLink driver"
  elif ! run_cmd sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y displaylink-driver; then
    echo "[baseline] WARNING: DisplayLink driver installation failed. If Secure Boot is enabled, enroll the MOK key manually and retry."
  fi
else
  echo "[baseline] Could not download Synaptics repository keyring; trying existing apt sources"
  if apt-cache show displaylink-driver >/dev/null 2>&1; then
    if ! run_cmd sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y displaylink-driver; then
      echo "[baseline] WARNING: DisplayLink driver installation failed. If Secure Boot is enabled, enroll the MOK key manually and retry."
    fi
  else
    echo "[baseline] displaylink-driver package is unavailable. Use the standalone Synaptics installer manually."
  fi
fi

echo "[baseline] Installing Pixi"
run_sh "curl -fsSL https://pixi.sh/install.sh | bash"

echo "[baseline] Installing OnlyOffice Desktop Editors"
if command -v snap >/dev/null 2>&1; then
  run_cmd sudo snap install onlyoffice-desktopeditors
else
  echo "[baseline] snap is not available; skipping OnlyOffice snap installation"
fi

echo "[baseline] Installing latest RStudio"
if [[ -n "$DIST_CODENAME" ]]; then
  rstudio_url="https://download1.rstudio.org/electron/${DIST_CODENAME}/amd64/rstudio-latest-amd64.deb"
else
  rstudio_url="https://download1.rstudio.org/electron/jammy/amd64/rstudio-latest-amd64.deb"
fi

tmp_rstudio_deb="/tmp/rstudio-latest-amd64.deb"
if [[ "$DRY_RUN" == "1" ]]; then
  echo "[dry-run] curl -fsSL $rstudio_url -o $tmp_rstudio_deb"
  echo "[dry-run] sudo apt-get install -y $tmp_rstudio_deb"
elif curl -fsSL "$rstudio_url" -o "$tmp_rstudio_deb"; then
  run_cmd sudo apt-get install -y "$tmp_rstudio_deb" || run_cmd sudo apt-get -f install -y
else
  echo "[baseline] Could not download RStudio for codename ${DIST_CODENAME}. Try manual install from Posit."
fi

echo "[baseline] ExpressVPN cannot be fully automated without vendor package access."
echo "[baseline] If you have the .deb package, run: sudo apt-get install -y /path/to/expressvpn*.deb"
