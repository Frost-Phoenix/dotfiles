#!/usr/bin/env bash
# Stow the dotfiles. Keep this list in sync when packages are added/removed.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
source ./lib.sh

# Packages that map into $HOME.
HOME_PKGS=(
	bat electron fastfetch fish ghostty git helix hypr jolt k9s
	lazygit micro rofi scripts ssh superfile swaync swayosd systemd
	uwsm vscodium waybar xdg xdg-desktop-portal
)
# These map into /etc, not $HOME (see AGENTS.md).
ETC_PKGS=(ly keyd)

cd "$INSTALL_DIR/.." # repo root: stow needs the packages relative to cwd

for pkg in "${HOME_PKGS[@]}"; do
	log "stow $pkg"
	stow --restow "$pkg"
done

for pkg in "${ETC_PKGS[@]}"; do
	log "stow -t /etc $pkg"
	sudo stow -t /etc --restow "$pkg"
done
