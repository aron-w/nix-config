# Architecture

This repo uses a `flake-parts` flake as the top-level composition layer.

## Layers

- `flake.nix` owns inputs, supported systems, templates, and imports for flake-level modules.
- `nix/devshell.nix` owns development tools exposed through `nix develop`.
- `nix/formatter.nix` owns `nix fmt` and static checks.
- `nix/modules/nixos/` is for reusable NixOS modules.
- `nix/modules/home/` is for reusable Home Manager modules.
- `hosts/<name>/` is for host-specific composition once real host facts are known.
- `secrets/` is for encrypted SOPS files only.
- `scripts/` is for small host-independent helper commands.

## Host Composition

Future host configurations should be small composition files that import reusable modules. Host files should set only facts that are truly host-specific: hardware, boot, filesystems, network identity, users, and role-specific services.

Use Home Manager through the NixOS module for both full NixOS and NixOS-WSL hosts unless a future non-NixOS target is added.

`dominus` is currently a workstation proof of concept. Once that profile proves the coding, gaming, desktop, secrets, and remote-control workflow, reusable workstation modules should move toward `exile`, and `dominus` should become server-first.

## Package Policy

Stable `nixpkgs` is the default source for systems and user packages. Use `nixpkgs-unstable` only for explicitly chosen packages that need newer versions.

When adding unstable packages, keep the boundary visible in code. Do not silently replace the stable package set.

## Future Optional Lanes

- `impermanence`: ephemeral root and persistent state.
- `stylix`: centralized themes.
- `nixvim`: managed Neovim distribution.
- `deploy-rs` or `colmena`: remote deployment.
- `lanzaboote`: Secure Boot.
- Binary cache: Cachix or private cache after real hosts exist.
