#!/usr/bin/env sh
set -eu

if ! command -v nix >/dev/null 2>&1; then
  cat >&2 <<'MSG'
Nix is required to run the Izrao installer wrapper.

Boot a NixOS installer or another Linux system with Nix, then rerun:
  curl -fsSL https://raw.githubusercontent.com/aron-w/nix-config/main/scripts/install-izrao.sh | sh
MSG
  exit 1
fi

exec nix --extra-experimental-features "nix-command flakes" run github:aron-w/nix-config#bootstrap -- \
  --mode install-wizard \
  --host izrao \
  --i-understand-this-wipes-the-disk \
  "$@"
