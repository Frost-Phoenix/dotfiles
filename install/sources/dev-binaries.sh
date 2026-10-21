#!/usr/bin/env bash
# Misc dev binaries — one-off tools that are NOT in dnf / cargo / pip.
# Each block is guarded and safe to re-run. Several sources still need pinning.
set -euo pipefail
source "../lib.sh"

local_bin="$HOME/.local/bin"
mkdir -p "$local_bin"

# --- zls (Zig language server) ---
# Currently ~/.local/bin/zls (from GitHub releases). TODO: pin zig version + asset.
if [[ ! -x "$local_bin/zls" ]]; then
	warn "TODO: install zls to $local_bin/zls (match the installed zig version)"
fi

# --- Odin toolchain + ols (Odin language server) ---
# Currently ~/.local/bin/odin (-> odin-bin/odin) and ~/.local/bin/ols (+ odinfmt).
if ! have odin && [[ ! -e "$local_bin/odin" ]]; then
	warn "TODO: install the Odin toolchain + ols into $local_bin"
fi

# --- aseprite ---
# Currently ~/.local/bin/aseprite -> ~/.local/bin/aseprite-app/aseprite (self-built).
if ! have aseprite && [[ ! -e "$local_bin/aseprite" ]]; then
	warn "TODO: install aseprite (build or AppImage) into $local_bin"
fi

# --- nnd ---
# Currently ~/.local/bin/nnd. TODO: identify upstream/source.
if [[ ! -x "$local_bin/nnd" ]]; then
	warn "TODO: identify the source of 'nnd' and install it"
fi

# --- dusklight AppImage (managed by Gearlever) ---
# Currently ~/.appimages/dusklight.appimage.
if [[ ! -f "$HOME/.appimages/dusklight.appimage" ]]; then
	warn "TODO: download the dusklight AppImage into ~/.appimages/"
fi
