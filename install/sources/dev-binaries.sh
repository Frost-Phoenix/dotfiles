#!/usr/bin/env bash

set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/../lib.sh"

local_bin="$HOME/.local/bin"
mkdir -p "$local_bin"

# --- zls (Zig language server) ---
if [[ ! -x "$local_bin/zls" ]]; then
	warn "TODO: install zls to $local_bin/zls (match the installed zig version)"
fi

# --- Odin toolchain + ols (Odin language server) ---
if ! have odin && [[ ! -e "$local_bin/odin" ]]; then
	warn "TODO: install the Odin toolchain + ols into $local_bin"
fi

# --- aseprite ---
if ! have aseprite && [[ ! -e "$local_bin/aseprite" ]]; then
	warn "TODO: install aseprite (build or AppImage) into $local_bin"
fi

# --- nnd ---
if [[ ! -x "$local_bin/nnd" ]]; then
	warn "TODO: identify the source of 'nnd' and install it"
fi

# --- dusklight AppImage (managed by Gearlever) ---
if [[ ! -f "$HOME/.appimages/dusklight.appimage" ]]; then
	warn "TODO: download the dusklight AppImage into ~/.appimages/"
fi
