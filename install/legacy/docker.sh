#!/usr/bin/env bash

set -euo pipefail

if ! command -v docker &> /dev/null; then
	curl -fsSL https://get.docker.com | sudo sh
	sudo systemctl enable --now docker
	sudo usermod -aG docker $USER
fi
