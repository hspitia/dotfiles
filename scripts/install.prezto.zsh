#!/usr/bin/env zsh

set -euo pipefail

DRY_RUN="${DRY_RUN:-0}"

run_cmd() {
    if [[ "$DRY_RUN" == "1" ]]; then
        echo "[dry-run] $*"
    else
        "$@"
    fi
}

zdotdir="${ZDOTDIR:-$HOME}"
prezto_dir="${zdotdir}/.zprezto"
prezto_repo="https://github.com/hspitia/prezto.git"
dotfiles_dir="${CONFIG_DIR:-$HOME/.dotfiles}"
custom_prompt_src="${dotfiles_dir}/files/prezto/prompt_hspitia_setup"
custom_prompt_dst="${prezto_dir}/modules/prompt/functions/prompt_hspitia_setup"

if [[ ! -d "${prezto_dir}/.git" ]]; then
    echo "[prezto] Cloning prezto into ${prezto_dir}"
    run_cmd git clone --recursive "${prezto_repo}" "${prezto_dir}"
else
    echo "[prezto] Updating existing prezto repository"
    run_cmd git -C "${prezto_dir}" pull --ff-only
    run_cmd git -C "${prezto_dir}" submodule update --init --recursive
fi

setopt EXTENDED_GLOB
for rcfile in "${prezto_dir}"/runcoms/^README.md(.N); do
    target="${zdotdir}/.${rcfile:t}"
    run_cmd ln -sfn "${rcfile}" "${target}"
done

if [[ -f "${custom_prompt_src}" ]]; then
    run_cmd cp "${custom_prompt_src}" "${custom_prompt_dst}"
    run_cmd chmod 755 "${custom_prompt_dst}"
    echo "[prezto] Installed custom prompt function: ${custom_prompt_dst}"
else
    echo "[prezto] WARNING: custom prompt source not found: ${custom_prompt_src}"
fi

zpreztorc_file="${zdotdir}/.zpreztorc"
if [[ -f "${zpreztorc_file}" ]]; then
    if grep -q "^zstyle ':prezto:module:prompt' theme " "${zpreztorc_file}"; then
        run_cmd sed -i "s/^zstyle ':prezto:module:prompt' theme .*/zstyle ':prezto:module:prompt' theme 'hspitia'/" "${zpreztorc_file}"
    else
        if [[ "$DRY_RUN" == "1" ]]; then
            echo "[dry-run] append custom prompt theme line to ${zpreztorc_file}"
        else
            printf "\n# Use custom dotfiles prompt theme\nzstyle ':prezto:module:prompt' theme 'hspitia'\n" >> "${zpreztorc_file}"
        fi
    fi
    echo "[prezto] Prompt theme configured: hspitia"
fi

echo "[prezto] Runcom links updated in ${zdotdir}"