#!/usr/bin/env bash
# Theme / font / cursor assets that are NOT in dnf and NOT in this repo:
#   - font:   Maple Mono / Maple Mono NF   -> ~/.local/share/fonts
#   - GTK:    Colloid-Green*-Gruvbox       -> ~/.themes
#   - cursor: Bibata-Modern-Ice            -> ~/.icons
# Sources still need to be pinned. Everything is guarded, so this is a no-op once done.
set -euo pipefail
source "../lib.sh"

fonts_dir="$HOME/.local/share/fonts"
themes_dir="$HOME/.themes"
icons_dir="$HOME/.icons"

# --- Maple Mono (font) ---
if [[ ! -d "$fonts_dir/MapleMono" ]]; then
	warn "TODO: fetch Maple Mono (+ Nerd Font variant 'Maple Mono NF') -> $fonts_dir/MapleMono"
	# Upstream: https://github.com/subframe7536/maple-font (releases)
fi

# --- Colloid GTK themes ---
if [[ ! -d "$themes_dir/Colloid-Green-Dark-Gruvbox" ]]; then
	warn "TODO: install Colloid-Green*-Gruvbox -> $themes_dir"
	# Upstream: https://github.com/vinceliuice/Colloid-gtk-theme (build with gruvbox colors)
fi

# --- Bibata cursor ---
if [[ ! -d "$icons_dir/Bibata-Modern-Ice" ]]; then
	warn "TODO: install Bibata-Modern-Ice -> $icons_dir"
	# Upstream: https://github.com/ful1e5/Bibata_Cursor (or dnf: bibata-cursor-theme)
fi

have fc-cache && fc-cache -f >/dev/null 2>&1 || true
