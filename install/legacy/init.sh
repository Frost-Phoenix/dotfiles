#!/usr/bin/env bash

set -euo pipefail

./dnf.sh
./flatpak.sh
./app-image.sh
