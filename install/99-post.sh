#!/usr/bin/env bash
set -euo pipefail
source "lib.sh"

log "enabling system services"
enable_system_units \
	keyd.service \
	swayosd-libinput-backend.service \
	tuned.service tuned-ppd.service \
	irqbalance.service \
	firewalld.service \
	NetworkManager.service bluetooth.service \
	chronyd.service avahi-daemon.service \
	udisks2.service upower.service rtkit-daemon.service \
	switcheroo-control.service systemd-resolved.service \
	systemd-oomd.service uresourced.service joycond.service

log "enabling user services"
enable_user_units \
	awww-daemon.service swaync.service swayosd-server.service waybar.service \
	hyprpolkitagent.service nautilus.service udiskie.service \
	power-alert.timer ssh-agent.socket

if have fwupdmgr; then
	sudo fwupdmgr refresh --force || warn "fwupd refresh failed"
fi
