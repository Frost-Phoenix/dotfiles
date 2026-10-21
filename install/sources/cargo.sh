#!/usr/bin/env bash
# cargo crates from manifests/cargo.txt (installed only if the binary is missing).
set -euo pipefail
source "../lib.sh"

have cargo || die "cargo missing (install stage 80-dev first)"
cargo_install_manifest cargo.txt
