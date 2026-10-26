#!/usr/bin/env bash

set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/../lib.sh"

have curl || error "curl missing"

if have spf; then
	log "superfile already installed"
	exit 0
fi

bash -c "$(curl -sLo- https://superfile.dev/install.sh)"

log "installed $(spf --version 2>&1 | head -1) -> $(command -v spf)"
