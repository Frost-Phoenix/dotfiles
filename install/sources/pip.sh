#!/usr/bin/env bash
# Python user tools from manifests/pip.txt.
set -euo pipefail
source "../lib.sh"

have python3 || die "python3 missing"
pip_install_manifest pip.txt
