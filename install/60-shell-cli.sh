#!/usr/bin/env bash
set -euo pipefail
source "lib.sh"

dnf_install_manifest cli.txt

# fish plugins via fisher (idempotent; reads ~/.config/fish/fish_plugins).
if have fish; then
	if ! fish -c 'functions -q fisher' 2>/dev/null; then
		log "installing fisher"
		curl -fsSL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish |
			fish -c 'source && fisher install jorgebucaran/fisher'
	fi
	fish -c 'fisher update' || warn "fisher update failed (config not stowed yet? run stow.sh first)"
fi
