#!/usr/bin/env bash
# Python user tools from manifests/pip.txt.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/../lib.sh"

have python3 || error "python3 missing"
pip_install_manifest pip.txt
