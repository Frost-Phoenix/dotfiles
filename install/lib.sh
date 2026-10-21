#!/usr/bin/env bash
# Shared helpers for the reinstall pipeline. Source from every stage:
#   source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
set -euo pipefail

INSTALL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANIFEST_DIR="$INSTALL_DIR/manifests"

log()  { printf '\033[1;32m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m warn:\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31mERROR:\033[0m %s\n' "$*" >&2; exit 1; }

have() { command -v "$1" >/dev/null 2>&1; }

# PROFILE=base (default) or PROFILE=optional (adds optional manifests).
profile_optional() { [[ "${PROFILE:-base}" == "optional" ]]; }

# Print a manifest, dropping comments and blank lines.
read_manifest() {
	local file="$MANIFEST_DIR/$1"
	[[ -f "$file" ]] || die "missing manifest: $file"
	sed -e 's/[[:space:]]*#.*$//' -e '/^[[:space:]]*$/d' "$file"
}

dnf_install() { sudo dnf install -y "$@"; }

dnf_install_manifest() {
	local -a pkgs=()
	mapfile -t pkgs < <(read_manifest "$1")
	((${#pkgs[@]})) || return 0
	log "dnf: ${#pkgs[@]} packages from $1"
	dnf_install "${pkgs[@]}"
}

copr_enable() {
	local repo="$1"
	if dnf copr list 2>/dev/null | grep -qF "$repo"; then
		log "copr $repo already enabled"
	else
		log "copr enable $repo"
		sudo dnf copr enable -y "$repo"
	fi
}

copr_enable_manifest() {
	while read -r repo; do copr_enable "$repo"; done < <(read_manifest "$1")
}

flatpak_add_flathub() {
	flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
}

flatpak_install_manifest() {
	local app
	while read -r app; do
		if flatpak info "$app" >/dev/null 2>&1; then
			log "flatpak $app present"
		else
			log "flatpak install $app"
			flatpak install -y --noninteractive flathub "$app"
		fi
	done < <(read_manifest "$1")
}

# cargo.txt entries: "<crate>" or "<crate>:<binary>".
cargo_install_manifest() {
	local entry crate bin
	while read -r entry; do
		crate="${entry%%:*}"
		bin="${entry##*:}"
		[[ "$bin" == "$entry" ]] && bin="$crate"
		if have "$bin"; then
			log "cargo $bin present"
		else
			log "cargo install $crate"
			cargo install "$crate"
		fi
	done < <(read_manifest "$1")
}

pip_install_manifest() {
	local -a pkgs=()
	mapfile -t pkgs < <(read_manifest "$1")
	((${#pkgs[@]})) || return 0
	log "pip --user: ${#pkgs[@]} packages from $1"
	python3 -m pip install --user "${pkgs[@]}"
}

# Tolerant unit enabling (missing/vendor units only warn).
enable_system_units() {
	local u
	for u in "$@"; do
		sudo systemctl enable --now "$u" || warn "could not enable $u"
	done
}

enable_user_units() {
	local u
	for u in "$@"; do
		systemctl --user enable --now "$u" || warn "could not enable $u"
	done
}
