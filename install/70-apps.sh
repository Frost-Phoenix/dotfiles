#!/usr/bin/env bash
set -euo pipefail
source "lib.sh"

flatpak_install_manifest flatpak-base.txt

if profile_optional; then
	dnf_install_manifest optional-rpm.txt
	flatpak_install_manifest flatpak-optional.txt
fi
