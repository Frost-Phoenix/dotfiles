#!/usr/bin/env bash
# hx = custom Helix fork: https://github.com/gj1118/helix
# (historically developed in ~/Documents/test/helix).
set -euo pipefail
source "../lib.sh"

HELIX_REPO="${HELIX_REPO:-https://github.com/gj1118/helix.git}"
# TODO: pin a tag/commit. Currently the fork carries a custom release (26.09.03).
HELIX_REF="${HELIX_REF:-master}"

if have hx; then
	log "hx already installed"
	exit 0
fi

have cargo || die "cargo missing (install stage 80-dev first)"
have git || die "git missing"

build_dir="${XDG_CACHE_HOME:-$HOME/.cache}/reinstall/helix"
rm -rf "$build_dir"
git clone "$HELIX_REPO" "$build_dir"
git -C "$build_dir" checkout "$HELIX_REF"
(
	cd "$build_dir"
	cargo install --path helix-term --locked
)
log "hx installed to $(command -v hx)"
