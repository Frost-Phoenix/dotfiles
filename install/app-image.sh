#!/usr/bin/env bash

set -euo pipefail

sudo dnf install fuse-libs

flatpak install it.mijorus.gearlever
