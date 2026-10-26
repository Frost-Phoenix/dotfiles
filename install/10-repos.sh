#!/usr/bin/env bash
# Repositories: dnf tweaks, RPM Fusion, coprs, Docker CE, flathub.

set -euo pipefail
source "lib.sh"

# --- dnf.conf tweaks ---
add_dnf_conf() {
	local config="$1"
	grep -qF "$config" /etc/dnf/dnf.conf || echo "$config" | sudo tee -a /etc/dnf/dnf.conf >/dev/null
}
add_dnf_conf "defaultyes=True"
add_dnf_conf "fastestmirror=True"
add_dnf_conf "max_parallel_downloads=10"

# --- RPM Fusion ---
if ! rpm -q rpmfusion-free-release >/dev/null 2>&1; then
	fedora_ver="$(rpm -E %fedora)"
	sudo dnf install -y \
		"https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${fedora_ver}.noarch.rpm" \
		"https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${fedora_ver}.noarch.rpm"
fi

# --- Docker CE repo ---
if ! dnf repolist 2>/dev/null | grep -q docker-ce-stable; then
	sudo dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo
fi

# --- COPRs ---
copr_enable_manifest copr.txt

# --- Flatpak ---
have flatpak || dnf_install flatpak
flatpak_add_flathub
