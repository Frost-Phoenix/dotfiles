#!/usr/bin/env bash
set -euo pipefail
source "lib.sh"

dnf_install_manifest login.txt
enable_system_units keyd.service
# ly itself is built in 90-sources.sh (sources/ly.sh) and stowed from /etc/ly.
