#!/usr/bin/env bash
# Ly display manager (Zig rewrite). Repo: https://codeberg.org/fairyglade/ly
# Target tag: v1.5.0 (local dev checkout in ~/Documents/test/ly was v1.4.1).
set -euo pipefail
source "../lib.sh"

LY_VERSION="${LY_VERSION:-1.5.0}"
LY_REPO="${LY_REPO:-https://codeberg.org/fairyglade/ly.git}"

if [[ -x /usr/bin/ly ]]; then
	log "ly already installed"
	exit 0
fi

have zig || die "zig missing (install stage 80-dev first)"
have git || die "git missing"

build_dir="${XDG_CACHE_HOME:-$HOME/.cache}/reinstall/ly"
rm -rf "$build_dir"
git clone --depth 1 --branch "v$LY_VERSION" "$LY_REPO" "$build_dir"

(
	cd "$build_dir"
	zig build -Doptimize=ReleaseFast
)

# TODO(verify against the repo's documented install): binary path, /etc/ly defaults,
# PAM service and the systemd unit (ly.service). The repo's config.ini is stowed
# from /etc/ly by stow.sh, so /etc/ly must exist before stowing.
sudo install -Dm755 "$build_dir/zig-out/bin/ly" /usr/bin/ly
sudo mkdir -p /etc/ly

# TODO(verify): copy the systemd unit / PAM config shipped by the fork, e.g.
#   sudo install -Dm644 "$build_dir/systemd/ly.service" /usr/lib/systemd/system/ly.service
#   sudo install -Dm644 "$build_dir/pam.d/ly" /etc/pam.d/ly
# then disable any other display manager and enable ly.service.

log "ly built; finish the service/PAM wiring (see TODOs in this script)"
