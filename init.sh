#!/usr/bin/env bash

set -eu

add_config_if_not_present() {
    local file="$1"
    local config="$2"
    grep -qF "$config" "$file" || echo "$config" | sudo tee -a "$file" >/dev/null
}

# Check and add configuration settings to /etc/dnf/dnf.conf
add_config_if_not_present "/etc/dnf/dnf.conf" "max_parallel_downloads=10"
add_config_if_not_present "/etc/dnf/dnf.conf" "fastestmirror=True"
add_config_if_not_present "/etc/dnf/dnf.conf" "defaultyes=True"

sudo dnf upgrade -y --refresh

sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

sudo dnf swap ffmpeg-free ffmpeg --allowerasing
sudo dnf group upgrade multimedia
sudo dnf group upgrade core

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

sudo dnf install fuse-libs

flatpak install it.mijorus.gearlever

flatpak install flathub com.github.tchx84.Flatseal

if ! command -v docker &> /dev/null; then
	curl -fsSL https://get.docker.com | sudo sh
	sudo systemctl enable --now docker
	sudo usermod -aG docker $USER
fi
