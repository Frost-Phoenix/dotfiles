#!/usr/bin/env bash

set -euo pipefail

add_config() {
    local file="$1"
    local config="$2"

    grep -qF "$config" "$file" || echo "$config" | sudo tee -a "$file" >/dev/null
}

add_config "/etc/dnf/dnf.conf" "defaultyes=True"
add_config "/etc/dnf/dnf.conf" "fastestmirror=True"
add_config "/etc/dnf/dnf.conf" "max_parallel_downloads=10"

sudo dnf -y upgrade --refresh

sudo dnf -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

sudo dnf -y swap ffmpeg-free ffmpeg --allowerasing
sudo dnf -y group upgrade multimedia
sudo dnf -y group upgrade core
