#!/usr/bin/env bash

set -euo pipefail

dnf copr enable -y lionheartp/Hyprland
sudo dnf install -y hyprland

sudo dnf install -y sddm mako pipewire qt5-wayland qt6-wayland wireplumber tuned tuned-ppd kitty waybar hyprpolkitagent nautilus pavucontrol alsa-sof-firmware alsa-utils blueman NetworkManager-wifi nm-connection-editor-desktop gvfs gvfs-mtp
