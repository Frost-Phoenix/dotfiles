#!/usr/bin/env bash
# Source / non-rpm builds. Each script is idempotent.
set -euo pipefail
source "lib.sh"

for src in \
	ly.sh \
	helix.sh \
	superfile.sh \
	cargo.sh \
	pip.sh \
	dev-binaries.sh; do
	log "source: $src"
	bash "$INSTALL_DIR/sources/$src"
done
