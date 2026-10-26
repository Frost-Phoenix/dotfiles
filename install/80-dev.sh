#!/usr/bin/env bash
set -euo pipefail
source "lib.sh"

dnf_install_manifest dev.txt

# Enable Docker now that the packages exist.
enable_system_units docker.service
if ! id -nG "$USER" | grep -qw docker; then
	sudo usermod -aG docker "$USER"
	warn "added $USER to the docker group (log out/in to take effect)"
fi
