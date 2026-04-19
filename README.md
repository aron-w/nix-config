# nixos-config

Personal NixOS configuration for multiple machines, NixOS-WSL, Home Manager, and AI-assisted maintenance.

The repo uses the Vimjoyer-style Dendritic Pattern: `flake.nix` delegates to `vic/import-tree`, and active Nix modules live under `modules/` as top-level `flake-parts` modules.

## Quick Start

```sh
direnv allow
nix develop
nix flake check
nix fmt
```

If `direnv` is not installed yet, enter the shell directly:

```sh
nix develop
```

The first Nix command may update `flake.lock` when inputs change. Commit it after review so inputs stay pinned.

## Current Host Targets

- `exile`: main/gaming machine.
- `dominus`: workstation POC for the future home server.
- `wsl-home`: personal NixOS-WSL environment.
- `wsl-work`: work NixOS-WSL environment.

`dominus` is the current concrete `nixosConfiguration`. `exile`, `wsl-home`, and `wsl-work` remain planned targets. Add or change host outputs only after collecting the machine's hostname, architecture, users, boot mode, disk strategy, hardware config, secrets policy, and activation workflow.

## Documentation

- [Architecture](docs/architecture.md)
- [Hosts](docs/hosts.md)
- [Tooling](docs/tooling.md)
- [Secrets](docs/secrets.md)
- [Verification](docs/verification.md)
- [AI workflow](docs/ai-workflow.md)
- [Decisions](docs/decisions.md)

## Core Policy

- Stable Nixpkgs is the default. Use `nixpkgs-unstable` only explicitly.
- Active Nix files under `modules/` are `flake-parts` modules. Group files by concern, not by output type.
- Home Manager should be integrated as a NixOS module for full NixOS and NixOS-WSL hosts.
- Secrets must be encrypted with `sops-nix` and `age`; plaintext secrets do not belong in this repo.
- `AGENTS.md` is a thin, tool-agnostic entrypoint for coding agents. Durable conventions live in `docs/`.
