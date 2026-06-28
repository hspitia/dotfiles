#!/usr/bin/env bash

set -euo pipefail

usage() {
    cat <<EOF
usage: $1 -m <MODE> [options]

This script sets up the configuration from .dotfiles repository.

ARGUMENTS:
    -m MODE      Configuration mode. 'd' for desktop, 's' for server.

OPTIONS:
    -i           Install software stack (baseline + extra repos/packages if available)
    -n           Dry run (print planned actions without changing the system)
    -p FILE      File with list of Ubuntu packages to install
    -r FILE      File with list of apt repositories to add
    -v           Verbose
    -h           Show this message
EOF
    exit 1
}

script_name=$(basename "$0")
mode=""
verbose=0
install_software=0
dry_run=0

CONFIG_DIR="${HOME}/.dotfiles"
CONF_SETTINGS_DIR="${CONFIG_DIR}/settings"
CONF_SCRIPTS_DIR="${CONFIG_DIR}/scripts"
CONF_PACKAGES_DIR="${CONFIG_DIR}/packages"

detect_package_file() {
    local release_file=""
    if command -v lsb_release >/dev/null 2>&1; then
        release_file="${CONF_PACKAGES_DIR}/packages.ubuntu_$(lsb_release -rs).list.txt"
    fi

    if [[ -n "$release_file" && -f "$release_file" ]]; then
        echo "$release_file"
    else
        echo "${CONF_PACKAGES_DIR}/packages.list.txt"
    fi
}

package_file="$(detect_package_file)"
repo_file="${CONF_PACKAGES_DIR}/repos.list.txt"

while getopts "m:inp:r:vh" opt; do
    case "$opt" in
        m) mode="$OPTARG" ;;
        i) install_software=1 ;;
        n) dry_run=1 ;;
        p) package_file="$OPTARG" ;;
        r) repo_file="$OPTARG" ;;
        v) verbose=1 ;;
        h) usage "$script_name" ;;
        *) usage "$script_name" ;;
    esac
done

log() {
    echo "[setup] $*"
}

debug() {
    if [[ "$verbose" -eq 1 ]]; then
        echo "[debug] $*"
    fi
}

require_cmd() {
    local cmd="$1"
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "ERROR: required command not found: $cmd" >&2
        exit 1
    fi
}

run_cmd() {
    if [[ "$dry_run" -eq 1 ]]; then
        echo "[dry-run] $*"
    else
        "$@"
    fi
}

verify_prezto_prompt() {
    if [[ "$dry_run" -eq 1 ]]; then
        log "DRY-RUN: skipping Prezto prompt verification"
        return
    fi

    local prompt_file="${HOME}/.zprezto/modules/prompt/functions/prompt_hspitia_setup"
    local zpreztorc_file="${HOME}/.zpreztorc"
    local prompt_file_ok=0
    local prompt_theme_ok=0

    if [[ -f "$prompt_file" ]]; then
        prompt_file_ok=1
    fi

    if [[ -f "$zpreztorc_file" ]] && grep -q "^zstyle ':prezto:module:prompt' theme 'hspitia'" "$zpreztorc_file"; then
        prompt_theme_ok=1
    fi

    if [[ "$prompt_file_ok" -eq 1 && "$prompt_theme_ok" -eq 1 ]]; then
        log "PASS: Prezto custom prompt is installed and active"
    else
        log "WARN: Prezto custom prompt verification failed"
        [[ "$prompt_file_ok" -eq 0 ]] && log "WARN: missing prompt file ${prompt_file}"
        [[ "$prompt_theme_ok" -eq 0 ]] && log "WARN: prompt theme is not set to 'hspitia' in ${zpreztorc_file}"
    fi
}

if [[ -z "$mode" ]]; then
    echo "ERROR: option -m is required" >&2
    usage "$script_name"
fi

if [[ "$dry_run" -eq 1 ]]; then
    log "DRY-RUN mode enabled"
    export DRY_RUN=1
fi

prefix=""
if [[ "$mode" == "d" ]]; then
    prefix="desktop"
elif [[ "$mode" == "s" ]]; then
    prefix="server"
else
    echo "ERROR: invalid value for -m. Use 'd' or 's'." >&2
    usage "$script_name"
fi

if ! command -v git >/dev/null 2>&1; then
    if command -v sudo >/dev/null 2>&1; then
        log "Installing git bootstrap dependency"
        run_cmd sudo apt-get update -y
        run_cmd sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y git
    else
        echo "ERROR: git is required and sudo is unavailable to install it." >&2
        exit 1
    fi
fi

LOCAL_SOFTWARE="${LOCAL_SOFTWARE:-${HOME}/software}"
LOCAL_SCRIPTS="${LOCAL_SCRIPTS:-${LOCAL_SOFTWARE}/scripts}"
XDG_CONFIG_HOME_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}"

prefer_ssh=0
if [[ -f "${HOME}/.ssh/id_ed25519" || -f "${HOME}/.ssh/id_rsa" ]]; then
    prefer_ssh=1
fi

dotfiles_url="https://github.com/hspitia/dotfiles.git"
scripts_url="https://github.com/hspitia/scripts.git"
if [[ "$prefer_ssh" -eq 1 ]]; then
    dotfiles_url="git@github.com:hspitia/dotfiles.git"
    scripts_url="git@github.com:hspitia/scripts.git"
fi

if [[ ! -d "$CONFIG_DIR/.git" ]]; then
    log "Cloning dotfiles into ${CONFIG_DIR}"
    run_cmd git clone "$dotfiles_url" "$CONFIG_DIR"
else
    log "Updating existing dotfiles repository"
    run_cmd git -C "$CONFIG_DIR" pull --ff-only
fi

if [[ "$prefix" == "desktop" ]]; then
    if ! command -v zsh >/dev/null 2>&1; then
        if command -v sudo >/dev/null 2>&1; then
            log "Installing zsh bootstrap dependency"
            run_cmd sudo apt-get update -y
            run_cmd sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y zsh
        else
            echo "ERROR: zsh is required for desktop mode and sudo is unavailable to install it." >&2
            exit 1
        fi
    fi
    log "Installing/updating prezto"
    DRY_RUN="$dry_run" zsh "$CONF_SCRIPTS_DIR/install.prezto.zsh"
    verify_prezto_prompt
fi

link_dotfile() {
    local src="$1"
    local dst="$2"

    if [[ -L "$dst" ]]; then
        run_cmd ln -sfn "$src" "$dst"
    elif [[ -e "$dst" ]]; then
        run_cmd mv "$dst" "${dst}.bak.$(date +%Y%m%d%H%M%S)"
        run_cmd ln -s "$src" "$dst"
    else
        run_cmd ln -s "$src" "$dst"
    fi
}

if [[ "$prefix" == "desktop" ]]; then
    link_dotfile "${CONFIG_DIR}/files/desktop.bashrc" "${HOME}/.bashrc"
    link_dotfile "${CONFIG_DIR}/files/desktop.common.config.sh" "${HOME}/.common.config.sh"
    link_dotfile "${CONFIG_DIR}/files/desktop.customrc.sh" "${HOME}/.customrc.sh"
    link_dotfile "${CONFIG_DIR}/files/desktop.zshrc" "${HOME}/.zshrc"
    link_dotfile "${CONFIG_DIR}/files/desktop.zpreztorc" "${HOME}/.zpreztorc"
    link_dotfile "${CONFIG_DIR}/files/desktop.gitconfig" "${HOME}/.gitconfig"
    link_dotfile "${CONFIG_DIR}/files/desktop.condarc" "${HOME}/.condarc"
else
    link_dotfile "${CONFIG_DIR}/files/server.bashrc" "${HOME}/.bashrc"
    link_dotfile "${CONFIG_DIR}/files/server.common.config.sh" "${HOME}/.common.config.sh"
    link_dotfile "${CONFIG_DIR}/files/server.customrc.sh" "${HOME}/.customrc.sh"
    link_dotfile "${CONFIG_DIR}/files/server.gitconfig" "${HOME}/.gitconfig"
    link_dotfile "${CONFIG_DIR}/files/server.condarc" "${HOME}/.condarc"
fi

if [[ "$install_software" -eq 1 ]]; then
    require_cmd sudo
    log "Installing baseline software stack"
    DRY_RUN="$dry_run" bash "$CONF_SCRIPTS_DIR/install_baseline_software.sh"

    if [[ -f "$repo_file" ]]; then
        require_cmd add-apt-repository
        log "Adding extra apt repositories from ${repo_file}"
        DRY_RUN="$dry_run" bash "$CONF_SCRIPTS_DIR/add_apt_repos.sh" "$repo_file"
    else
        debug "Repository list not found, skipping extra repos: ${repo_file}"
    fi

    if [[ -f "$package_file" ]]; then
        log "Installing extra packages from ${package_file}"
        DRY_RUN="$dry_run" bash "$CONF_SCRIPTS_DIR/install_packages.sh" "$package_file"
    else
        debug "Package list not found, skipping extra packages: ${package_file}"
    fi
else
    debug "Skipping software installation (-i not set)"
fi

if [[ "$prefix" == "desktop" ]]; then
    if command -v ghostty >/dev/null 2>&1 && command -v zsh >/dev/null 2>&1; then
        log "Configuring Ghostty to launch Zsh by default"
        run_cmd mkdir -p "${XDG_CONFIG_HOME_DIR}/ghostty"
        link_dotfile "${CONFIG_DIR}/config/ghostty/config" "${XDG_CONFIG_HOME_DIR}/ghostty/config"
    else
        debug "Ghostty or zsh is unavailable; skipping Ghostty configuration"
    fi
fi

run_cmd mkdir -p "$LOCAL_SOFTWARE"
if [[ ! -d "$LOCAL_SCRIPTS/.git" ]]; then
    log "Cloning personal scripts repository"
    run_cmd git clone "$scripts_url" "$LOCAL_SCRIPTS"
else
    log "Updating personal scripts repository"
    run_cmd git -C "$LOCAL_SCRIPTS" pull --ff-only
fi

is_graphical_session=0
if [[ -n "${DISPLAY:-}" || -n "${WAYLAND_DISPLAY:-}" ]]; then
    is_graphical_session=1
fi

if [[ "$prefix" == "desktop" && "$is_graphical_session" -eq 1 ]]; then
    if command -v dconf >/dev/null 2>&1 && [[ -f "${CONF_SETTINGS_DIR}/gnome_terminal.settings.txt" ]]; then
        log "Applying GNOME Terminal configuration"
        run_cmd dconf reset -f /org/gnome/terminal/
        if [[ "$dry_run" -eq 1 ]]; then
            echo "[dry-run] dconf load /org/gnome/terminal/ < ${CONF_SETTINGS_DIR}/gnome_terminal.settings.txt"
        else
            dconf load /org/gnome/terminal/ < "${CONF_SETTINGS_DIR}/gnome_terminal.settings.txt"
        fi
    fi

    if command -v gsettings >/dev/null 2>&1; then
        log "Applying Nemo preferences"
        if gsettings list-schemas | grep -qx 'org.nemo.extensions.nemo-terminal'; then
            run_cmd gsettings set org.nemo.extensions.nemo-terminal default-visible false || true
        fi
        run_cmd gsettings set org.nemo.preferences start-with-dual-pane true || true
    fi

    if command -v nemo >/dev/null 2>&1; then
        log "Applying Nemo desktop integration"
        DRY_RUN="$dry_run" bash "$CONF_SCRIPTS_DIR/config.nemo.sh"
    fi

    if command -v gsettings >/dev/null 2>&1; then
        log "Installing hybrid Numix Circle + Yaru folder icon theme"
        DRY_RUN="$dry_run" bash "$CONF_SCRIPTS_DIR/config.icon_theme.sh"
    fi

    if command -v variety >/dev/null 2>&1; then
        log "Applying Variety configuration"
        DRY_RUN="$dry_run" bash "$CONF_SCRIPTS_DIR/config.variety.sh"
    fi
fi

log "Setup complete. Open a new terminal session to load updated shell configuration."