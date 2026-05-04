# nixos-config

Personal NixOS configuration for multiple machines, NixOS-WSL, Home Manager, and AI-assisted maintenance.

The repo uses the Vimjoyer-style Dendritic Pattern: `flake.nix` delegates to `vic/import-tree`, and active Nix modules live under `modules/` as top-level `flake-parts` modules.

## Quick Start

Bootstrap an existing NixOS, WSL, or Linux machine that already has Nix:

```sh
nix --extra-experimental-features "nix-command flakes" run github:aron-w/nix-config#bootstrap -- --yes
```

Fresh `dominus` install from the NixOS installer USB, after verifying the target disk:

```sh
nix --extra-experimental-features "nix-command flakes" run github:aron-w/nix-config#bootstrap -- --mode install --host dominus --yes --i-understand-this-wipes-the-disk
```

Fresh `izrao` install notes, including direct SSD and external SSD bootstrap paths: [docs/izrao-install.md](docs/izrao-install.md).

Fresh `izrao` install with the disk-selection wizard:

```sh
nix --extra-experimental-features "nix-command flakes" run github:aron-w/nix-config#bootstrap -- --mode install-wizard --host izrao --yes --i-understand-this-wipes-the-disk
```

Short wrapper for the same `izrao` install flow from a NixOS installer or another Linux system with Nix:

```sh
curl -fsSL https://raw.githubusercontent.com/aron-w/nix-config/main/scripts/install-izrao.sh | sh
```

After the first graphical login, finish 1Password Git SSH setup:

```sh
nix --extra-experimental-features "nix-command flakes" run github:aron-w/nix-config#bootstrap -- --mode auth --yes
```

On Linux or WSL without Nix, install Nix first:

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

Day-to-day work inside a checkout:

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

- `izrao`: current Windows gaming and coding workstation target.
- `exile`: main/gaming machine.
- `dominus`: workstation POC for the future home server.
- `wsl-home`: personal NixOS-WSL environment.
- `wsl-work`: work NixOS-WSL environment.

`dominus` and `izrao` are the current concrete `nixosConfigurations`. `exile`, `wsl-home`, and `wsl-work` remain planned targets. Add or change host outputs only after collecting the machine's hostname, architecture, users, boot mode, disk strategy, hardware config, secrets policy, and activation workflow.

## Documentation

- [Architecture](docs/architecture.md)
- [Hosts](docs/hosts.md)
- [Tooling](docs/tooling.md)
- [Izrao install](docs/izrao-install.md)
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
