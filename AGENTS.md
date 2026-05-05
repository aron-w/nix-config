# AGENTS.md

This repo is a personal NixOS, NixOS-WSL, Home Manager, and secret management configuration.

Always read this file first. Then read only the docs that match the task.

## Agent Routing

- First targeted lookup: [docs/agent-index.md](docs/agent-index.md).
- Repo structure change: read [docs/decisions.md](docs/decisions.md) and [docs/architecture.md](docs/architecture.md).
- Host add/change: read [docs/hosts.md](docs/hosts.md).
- Secret, SOPS, age, recipient, or service-secret wiring change: read [docs/secrets.md](docs/secrets.md).
- Commit, history, split, or publish work: use `.codex/skills/conventional-commits`.
- Verification question or host switch/install command: read [docs/verification.md](docs/verification.md).

## Common Changes

- Add a desktop GUI package: prefer `modules/features/desktop-plasma.nix`; use `pkgs.unstable.<name>` only when unstable is explicitly requested.
- Add a coding tool: use `modules/features/coding.nix`; system tools go in `environment.systemPackages`, user tools in Home Manager `home.packages`.
- Add general CLI/user utilities: prefer `modules/features/power-user.nix`.
- Add host-specific facts: keep them under `modules/hosts/<name>/`.
- Add reusable behavior: put it under `modules/features/` or another concern-based `modules/` subtree.
- Touch `modules/` structure or exported modules: every active `.nix` file there must remain a top-level `flake-parts` module.

## Safe Commands

- Inspect outputs: `nix flake show`
- Enter tools: `nix develop`
- Format: `nix fmt`
- Validate: `nix flake check`
- Find files: `rg --files`
- Search text: `rg "pattern"`

## Verification Scope

- Docs-only: no Nix check required unless commands, examples, or module semantics changed.
- Package or feature module change: run `nix fmt` and `nix flake check` when Nix is available.
- Host, boot, disk, secrets, or activation change: read the relevant doc first, then run `nix fmt`, `nix flake check`, and host-specific rebuild/test when available.
- Structural changes: run `nix fmt` and `nix flake check` when Nix is available.

## Rules For Agents

- Do not add real host settings from guesses.
- Do not add `nixosConfigurations` until the host facts listed in [docs/hosts.md](docs/hosts.md) are known.
- Do not commit plaintext secrets, private keys, tokens, passwords, generated age identities, or work credentials.
- Prefer stable `nixpkgs`; use `nixpkgs-unstable` only when a package is explicitly called out as needing it.
- Keep unstable package use visible at call sites as `pkgs.unstable.<name>`.
- Expose reusable lower-level modules through `flake.modules.nixos.*` and `flake.modules.homeManager.*`.
- Keep `README.md` concise for humans. Put durable conventions in `docs/`.
- Create commits only when explicitly requested, when preparing history, or when publishing changes.
- Prefer one Conventional Commit per cohesive change when commits are requested.
- Do not run destructive git commands unless the user explicitly asks.

## Current Scope

`dominus` and `izaro` are concrete NixOS workstation targets. `exile`, `wsl-home`, and `wsl-work` are planned targets, not complete configurations.
