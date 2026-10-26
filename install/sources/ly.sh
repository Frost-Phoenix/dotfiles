#!/usr/bin/env bash
# Ly display manager (Zig rewrite). Repo: https://codeberg.org/fairyglade/ly
#
# Upstream (tag v1.5.0) procedure:
#   zig build
#   sudo zig build installexe -Dinit_system=systemd   # exe + PAM + units + /etc/ly
#   systemctl enable ly@tty2.service
#   systemctl disable getty@tty2.service              # mandatory: ly owns the TTY
#
# We run installnoconf instead of installexe on purpose: installexe writes
# /etc/ly/config.ini with createFile, which follows the stow symlink and would
# overwrite this repo's dotfile with upstream defaults. installnoconf skips
# config.ini/startup.sh, so startup.sh is installed separately below.
#
# Toolchain: tag v1.5.0 declares minimum_zig_version = "0.17.0" in
# build.zig.zon (its readme still claims 0.16.x — stale). Fedora 44 only ships
# zig 0.16.0, which fails on `b.root`/`@backingInt`, so this script provisions
# 0.17.0 under ~/.local/share/zig (no root needed, cached across runs).
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/../lib.sh"

LY_VERSION="${LY_VERSION:-1.5.0}"
LY_TTY="${LY_TTY:-2}"
LY_ZIG_VERSION="${LY_ZIG_VERSION:-0.17.0}"
ZIG_HOME="${ZIG_HOME:-$HOME/.local/share/zig}"

have git || error "git missing"
have curl || error "curl missing"

version_ge() { [[ "$(printf '%s\n%s\n' "$1" "$2" | sort -V | tail -1)" == "$1" ]]; }

# $LY_ZIG wins, then a new-enough system zig, then a locally provisioned one.
resolve_zig() {
	local bin="$ZIG_HOME/$LY_ZIG_VERSION/zig"
	if [[ -n "${LY_ZIG:-}" ]]; then
		have "$LY_ZIG" || error "LY_ZIG=$LY_ZIG not found"
		printf '%s\n' "$LY_ZIG"
	elif have zig && version_ge "$(zig version)" "$LY_ZIG_VERSION"; then
		command -v zig
	elif [[ -x "$bin" ]] && [[ "$("$bin" version)" == "$LY_ZIG_VERSION" ]]; then
		printf '%s\n' "$bin"
	else
		local arch tarball url tmp
		case "$(uname -m)" in
		x86_64) arch=x86_64-linux ;;
		aarch64) arch=aarch64-linux ;;
		*) error "no zig build for $(uname -m)" ;;
		esac
		tarball="zig-$arch-$LY_ZIG_VERSION.tar.xz"
		url="https://ziglang.org/download/$LY_ZIG_VERSION/$tarball"
		log "zig $LY_ZIG_VERSION needed (system: $(zig version 2>/dev/null || echo none)) — fetching $url" >&2
		tmp="$(mktemp -d)"
		curl -fL --retry 3 -o "$tmp/$tarball" "$url" || error "zig download failed"
		mkdir -p "$ZIG_HOME"
		# python3 handles .tar.xz without relying on the xz binary
		python3 -c 'import sys,tarfile; tarfile.open(sys.argv[1]).extractall(sys.argv[2], filter="data")' \
			"$tmp/$tarball" "$ZIG_HOME"
		rm -rf "$tmp"
		# tarball unpacks to zig-<arch>-<version>/; keep a version-only path
		rm -rf "$ZIG_HOME/$LY_ZIG_VERSION"
		mv "$ZIG_HOME/zig-$arch-$LY_ZIG_VERSION" "$ZIG_HOME/$LY_ZIG_VERSION"
		[[ -x "$bin" ]] || error "zig extraction failed (expected $bin)"
		[[ "$("$bin" version)" == "$LY_ZIG_VERSION" ]] ||
			error "$bin reports $("$bin" version), expected $LY_ZIG_VERSION"
		printf '%s\n' "$bin"
	fi
}

# `ly --version` prints to stderr and the format changed between tags
# ("Ly version 1.4.1" -> "info: ly version 1.5.0"), so compare the last field.
if [[ "$(/usr/bin/ly --version 2>&1 | awk '{print $NF}')" == "$LY_VERSION" ]]; then
	log "ly $LY_VERSION already installed"
else
	# Absolute path: zig ships in /usr/sbin and sudo's secure_path may differ.
	ZIG_BIN="$(resolve_zig)"
	log "using zig $("$ZIG_BIN" version) ($ZIG_BIN)"

	# Build in a throwaway dir: the install step runs as root and leaves
	# root-owned .zig-cache/zig-out behind, so clean up with sudo.
	build_dir="$(mktemp -d /tmp/ly-build.XXXXXX)"
	trap 'sudo rm -rf "$build_dir"' EXIT

	# Same options for build and install so the install step reuses the cache.
	build_opts=(
		-Doptimize=ReleaseFast
		-Dinit_system=systemd
		"-Ddefault_tty=$LY_TTY"  # embedded into the binary
		"-Dfallback_tty=$LY_TTY" # embedded into the binary
	)

	git clone --depth 1 --branch "v$LY_VERSION" \
		https://codeberg.org/fairyglade/ly.git "$build_dir"
	(cd "$build_dir" && "$ZIG_BIN" build "${build_opts[@]}")

	# Installs /usr/bin/ly, /etc/pam.d/ly{,-autologin}, ly@.service,
	# ly-kmsconvt@.service, /etc/ly/{lang,custom-sessions,example.dur,
	# example.lua,setup.sh,config.ini.example} — but not config.ini.
	(cd "$build_dir" && sudo "$ZIG_BIN" build installnoconf "${build_opts[@]}")

	# installnoconf skips startup.sh, which config.ini references as start_cmd.
	[[ -e /etc/ly/startup.sh ]] ||
		sudo install -Dm755 "$build_dir/res/startup.sh" /etc/ly/startup.sh
fi

# README: getty must not spawn on the TTY ly owns.
sudo systemctl disable "getty@tty${LY_TTY}.service" 2>/dev/null || true
sudo systemctl enable "ly@tty${LY_TTY}.service"

# SELinux (Fedora): only needed if sessions fail to launch, per README:
#   ausearch -m avc -ts recent | audit2allow -M ly-local && sudo semodule -i ly-local.pp
# Not needed on this machine (no ly policy module installed and login works).
#
# Config stays stow-managed: /etc/ly/config.ini must be a symlink into this repo.
# Validate edits with: ly --validate-config /etc/ly/config.ini
