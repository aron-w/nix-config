# AGENTS.md

This repo is a personal NixOS, NixOS-WSL, Home Manager, and secret management configuration.

## Read First

- Use `.codex/skills/conventional-commits` whenever the user asks to commit changes or prepare git history.
- When creating commits, split work by coherent reviewable intent so each commit is easy to review, revert, or bisect.
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
- Use the Dendritic Pattern under `modules/`: every active `.nix` file there is a top-level `flake-parts` module.
- Expose reusable lower-level modules through `flake.modules.nixos.*` and `flake.modules.homeManager.*`.
- Keep host-specific facts under `modules/hosts/<name>/`.
- Keep `README.md` concise for humans. Put durable conventions in `docs/`.
- Prefer one Conventional Commit per cohesive change. Do not bundle unrelated fixes, docs, and refactors into one commit when they can be reviewed independently.
- Do not run destructive git commands unless the user explicitly asks.
- After structural changes, run `nix fmt` and `nix flake check` when Nix is available.

## Current Scope

`dominus` is a concrete workstation POC host. `exile`, `wsl-home`, and `wsl-work` are planned targets, not complete configurations.
