$ErrorActionPreference = "Stop"

$repo = Resolve-Path "$PSScriptRoot\.."

docker run --rm `
  -v "${repo}:/repo" `
  -w /repo `
  ghcr.io/nixos/nix:latest `
  nix --extra-experimental-features "nix-command flakes" flake check
