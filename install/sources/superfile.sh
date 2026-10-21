#!/usr/bin/env bash
# superfile (Go TUI file manager) -> /usr/local/sbin/spf
# Upstream: https://github.com/yorukot/superfile
set -euo pipefail
source "../lib.sh"

if have spf; then
	log "superfile already installed"
	exit 0
fi

# TODO(verify): pin a version and the exact release asset name before relying on this.
SUPERFILE_VERSION="${SUPERFILE_VERSION:-latest}"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

url="https://github.com/yorukot/superfile/releases/${SUPERFILE_VERSION}/download/superfile-linux-amd64.tar.gz"
log "downloading $url"
curl -fsSL "$url" -o "$tmp/superfile.tar.gz"
tar -xzf "$tmp/superfile.tar.gz" -C "$tmp"
bin="$(find "$tmp" -type f -name 'spf*' -perm -u+x | head -1)"
[[ -n "$bin" ]] || die "could not locate spf binary in release archive"
sudo install -Dm755 "$bin" /usr/local/sbin/spf
