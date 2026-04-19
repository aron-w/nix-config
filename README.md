# nixos-config

Personal NixOS configuration scaffold for multiple machines, NixOS-WSL, Home Manager, and AI-assisted maintenance.

The repo is intentionally scaffold-only right now. It provides the surrounding structure, tooling, checks, templates, and docs needed before adding real host configurations.

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

The first Nix command will generate `flake.lock`. Commit it after review so inputs stay pinned.

## Current Host Targets

- `exile`: main/gaming machine.
- `dominus`: first home server.
- `wsl-home`: personal NixOS-WSL environment.
- `wsl-work`: work NixOS-WSL environment.

No host has a real `nixosConfiguration` yet. Add one only after collecting the machine's hostname, architecture, users, boot mode, disk strategy, hardware config, secrets policy, and activation workflow.

## Documentation

- [Architecture](docs/architecture.md)
- [Hosts](docs/hosts.md)
- [Tooling](docs/tooling.md)
- [Secrets](docs/secrets.md)
- [AI workflow](docs/ai-workflow.md)
- [Decisions](docs/decisions.md)

## Core Policy

- Stable Nixpkgs is the default. Use `nixpkgs-unstable` only explicitly.
- Home Manager should be integrated as a NixOS module for full NixOS and NixOS-WSL hosts.
- Secrets must be encrypted with `sops-nix` and `age`; plaintext secrets do not belong in this repo.
- `AGENTS.md` is a thin, tool-agnostic entrypoint for coding agents. Durable conventions live in `docs/`.
