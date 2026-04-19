# AGENTS.md

This repo is a scaffold for personal NixOS, NixOS-WSL, Home Manager, and secret management configuration.

## Read First

- Use `.codex/skills/conventional-commits` whenever the user asks to commit changes or prepare git history.
- Start with [docs/decisions.md](docs/decisions.md).
- Use [docs/architecture.md](docs/architecture.md) before changing repo structure.
- Use [docs/hosts.md](docs/hosts.md) before adding or changing hosts.
- Use [docs/secrets.md](docs/secrets.md) before touching anything under `secrets/`.

## Safe Commands

- Inspect outputs: `nix flake show`
- Enter tools: `nix develop`
- Format: `nix fmt`
- Validate: `nix flake check`
- Find files: `rg --files`
- Search text: `rg "pattern"`

## Rules For Agents

- Do not add real host settings from guesses.
- Do not commit plaintext secrets, private keys, tokens, passwords, or generated age identities.
- Do not add `nixosConfigurations` until the host facts listed in [docs/hosts.md](docs/hosts.md) are known.
- Prefer stable `nixpkgs`; use `nixpkgs-unstable` only when a package is explicitly called out as needing it.
- Keep reusable NixOS modules under `nix/modules/nixos/` and reusable Home Manager modules under `nix/modules/home/`.
- Keep `README.md` concise for humans. Put durable conventions in `docs/`.
- Do not run destructive git commands unless the user explicitly asks.
- After structural changes, run `nix fmt` and `nix flake check` when Nix is available.

## Current Scope

The repo is scaffold-only. `exile`, `dominus`, `wsl-home`, and `wsl-work` are planned host targets, not complete configurations.
