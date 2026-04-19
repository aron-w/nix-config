#!/usr/bin/env sh
set -eu

repo="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

docker run --rm \
  -v "$repo:/repo" \
  -w /repo \
  ghcr.io/nixos/nix:latest \
  nix --extra-experimental-features "nix-command flakes" flake check
