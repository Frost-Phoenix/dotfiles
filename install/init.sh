#!/usr/bin/env bash
# Reinstall pipeline entrypoint.
#
#   sudo ./init.sh                 # full base install (still stows as your user)
#   PROFILE=optional ./init.sh     # base + optional profile (media/games)
#
# Ordering matters: repos -> base -> graphics -> hyprland/login -> cli -> apps
# -> dev -> source builds -> themes -> post -> stow.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

: "${PROFILE:=base}"
export PROFILE

source ./lib.sh
log "reinstall pipeline — profile: $PROFILE"

for stage in [0-9][0-9]-*.sh; do
	[[ -f "$stage" ]] || continue
	log "=== stage: $stage ==="
	bash "$stage"
done

log "=== stowing dotfiles ==="
bash ./stow.sh

log "reinstall complete (profile: $PROFILE)"
