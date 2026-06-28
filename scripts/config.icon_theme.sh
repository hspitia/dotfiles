#!/usr/bin/env bash

set -euo pipefail

DRY_RUN="${DRY_RUN:-0}"
APPLY_HYBRID_THEME="${APPLY_HYBRID_THEME:-0}"

run_cmd() {
  if [[ "$DRY_RUN" == "1" ]]; then
    echo "[dry-run] $*"
  else
    "$@"
  fi
}

log() {
  echo "[icons] $*"
}

strip_quotes() {
  local value="$1"
  value="${value#\'}"
  value="${value%\'}"
  printf '%s\n' "$value"
}

hybrid_theme_name() {
  local yaru_theme="$1"
  if [[ "$yaru_theme" == "Yaru" ]]; then
    printf '%s\n' "Numix-Circle-Yaru-Folders"
  else
    printf '%s\n' "Numix-Circle-${yaru_theme#Yaru-}-Folders"
  fi
}

create_hybrid_theme() {
  local numix_theme="$1"
  local yaru_theme="$2"
  local theme_name="$3"
  local theme_root="${HOME}/.local/share/icons/${theme_name}"
  local index_theme_file="${theme_root}/index.theme"
  local places_dirs=(16x16 16x16@2x 24x24 24x24@2x 32x32 32x32@2x 48x48 48x48@2x 256x256 256x256@2x scalable)
  local icon_names=(folder folder-open folder-documents folder-download folder-music folder-pictures folder-videos folder-publicshare folder-templates folder-remote folder-recent user-home user-desktop user-trash)
  local symbolic_icons=(folder-symbolic folder-download-symbolic folder-documents-symbolic folder-music-symbolic folder-pictures-symbolic folder-videos-symbolic folder-publicshare-symbolic folder-templates-symbolic folder-remote-symbolic folder-saved-search-symbolic user-home-symbolic user-desktop-symbolic user-trash-symbolic)

  log "Generating hybrid icon theme ${theme_name} from ${yaru_theme}"
  run_cmd mkdir -p "$theme_root"

  if [[ "$DRY_RUN" == "1" ]]; then
    echo "[dry-run] write ${index_theme_file} inheriting ${numix_theme},${yaru_theme},Yaru,hicolor"
  else
    cat > "$index_theme_file" <<EOF
[Icon Theme]
Name=${theme_name}
Comment=Numix Circle icons with ${yaru_theme} folder icons
Inherits=${numix_theme},${yaru_theme},Yaru,hicolor
Directories=16x16/places,16x16@2x/places,24x24/places,24x24@2x/places,32x32/places,32x32@2x/places,48x48/places,48x48@2x/places,256x256/places,256x256@2x/places,scalable/places

[16x16/places]
Size=16
Context=Places
Type=Threshold

[16x16@2x/places]
Size=16
Scale=2
Context=Places
Type=Threshold

[24x24/places]
Size=24
Context=Places
Type=Threshold

[24x24@2x/places]
Size=24
Scale=2
Context=Places
Type=Threshold

[32x32/places]
Size=32
Context=Places
Type=Threshold

[32x32@2x/places]
Size=32
Scale=2
Context=Places
Type=Threshold

[48x48/places]
Size=48
Context=Places
Type=Threshold

[48x48@2x/places]
Size=48
Scale=2
Context=Places
Type=Threshold

[256x256/places]
Size=256
Context=Places
Type=Threshold

[256x256@2x/places]
Size=256
Scale=2
Context=Places
Type=Threshold

[scalable/places]
Size=64
MinSize=16
MaxSize=512
Context=Places
Type=Scalable
EOF
  fi

  for dir_name in "${places_dirs[@]}"; do
    local source_dir="/usr/share/icons/${yaru_theme}/${dir_name}/places"
    local target_dir="${theme_root}/${dir_name}/places"
    [[ -d "$source_dir" ]] || continue
    run_cmd mkdir -p "$target_dir"

    local icon_name
    for icon_name in "${icon_names[@]}"; do
      local ext
      for ext in png svg; do
        local source_icon="${source_dir}/${icon_name}.${ext}"
        local target_icon="${target_dir}/${icon_name}.${ext}"
        if [[ -f "$source_icon" ]]; then
          run_cmd ln -sfn "$source_icon" "$target_icon"
        fi
      done
    done

    local symbolic_icon
    for symbolic_icon in "${symbolic_icons[@]}"; do
      local source_icon="${source_dir}/${symbolic_icon}.svg"
      local target_icon="${target_dir}/${symbolic_icon}.svg"
      if [[ -f "$source_icon" ]]; then
        run_cmd ln -sfn "$source_icon" "$target_icon"
      fi
    done
  done

  if command -v gtk-update-icon-cache >/dev/null 2>&1; then
    run_cmd gtk-update-icon-cache -q "$theme_root" || true
  fi
}

current_icon_theme=""
if command -v gsettings >/dev/null 2>&1; then
  current_icon_theme="$(gsettings get org.gnome.desktop.interface icon-theme 2>/dev/null || true)"
  current_icon_theme="$(strip_quotes "$current_icon_theme")"
fi

numix_theme=""
if [[ "$current_icon_theme" == Numix-Circle* ]] && [[ -d "/usr/share/icons/${current_icon_theme}" ]]; then
  numix_theme="$current_icon_theme"
elif [[ -d /usr/share/icons/Numix-Circle ]]; then
  numix_theme="Numix-Circle"
elif [[ -d /usr/share/icons/Numix-Circle-Light ]]; then
  numix_theme="Numix-Circle-Light"
else
  log "WARNING: Numix Circle theme is not installed; skipping hybrid icon theme setup"
  exit 0
fi

# Verify the Numix theme has actual icon files
if ! find "/usr/share/icons/${numix_theme}" -name '*.svg' -o -name '*.png' 2>/dev/null | grep -q .; then
  log "WARNING: Numix theme ${numix_theme} found but has no icon files; skipping hybrid icon theme setup"
  exit 0
fi

mapfile -t yaru_themes < <(find /usr/share/icons -maxdepth 1 -mindepth 1 -type d -name 'Yaru*' -printf '%f\n' | sort -u)
if [[ "${#yaru_themes[@]}" -eq 0 ]]; then
  log "WARNING: No Yaru icon themes found; skipping hybrid icon theme setup"
  exit 0
fi

# Filter Yaru themes to only those with actual icon content
mapfile -t valid_yaru_themes < <(
  for theme in "${yaru_themes[@]}"; do
    if find "/usr/share/icons/${theme}" -name '*.svg' -o -name '*.png' 2>/dev/null | grep -q .; then
      echo "$theme"
    fi
  done
)

if [[ "${#valid_yaru_themes[@]}" -eq 0 ]]; then
  log "WARNING: No valid Yaru icon themes found with icon files; skipping hybrid icon theme setup"
  exit 0
fi

for yaru_theme in "${valid_yaru_themes[@]}"; do
  create_hybrid_theme "$numix_theme" "$yaru_theme" "$(hybrid_theme_name "$yaru_theme")"
done

if command -v gsettings >/dev/null 2>&1; then
  if [[ "$current_icon_theme" == Numix-Circle* ]]; then
    log "Current theme already uses Numix Circle; leaving it unchanged"
  elif [[ "$current_icon_theme" == Yaru* && "$APPLY_HYBRID_THEME" == "1" ]]; then
    target_theme="$(hybrid_theme_name "$current_icon_theme")"
    log "Activating hybrid icon theme ${target_theme}"
    run_cmd gsettings set org.gnome.desktop.interface icon-theme "$target_theme"
  else
    log "Hybrid Yaru variants installed. Current theme left unchanged (${current_icon_theme:-unknown})"
  fi
fi