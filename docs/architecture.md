# Architecture

This repo uses the Vimjoyer-style Dendritic Pattern with `flake-parts` and `vic/import-tree`.

## Dendritic Rules

- `flake.nix` owns inputs and delegates evaluation to `inputs.import-tree ./modules`.
- Every active `.nix` file under `modules/` is a top-level `flake-parts` module.
- Files are grouped by concern, not by output type.
- Reusable lower-level modules are exposed through `flake.modules.nixos.*` and `flake.modules.homeManager.*`.
- Host outputs are defined beside the host under `modules/hosts/<name>/`.
- Templates, docs, scripts, secrets, editor settings, and agent metadata stay outside `modules/` unless they are active `flake-parts` modules.

## Layers

- `modules/flake/` owns supported systems, templates, dev shells, formatters, and checks.
- `modules/nix/` owns Nix-wide integrations such as Home Manager, Disko, SOPS, and explicit unstable package access.
- `modules/features/` owns reusable behavior such as coding tools, desktop sessions, gaming, remote access, containers, SSH, and secrets wiring.
- `modules/hosts/<name>/` owns host-specific composition and facts: hardware, boot, filesystems, network identity, users, and host state versions.
- `secrets/` is for encrypted SOPS files only.
- `scripts/` is for small host-independent helper commands.

## Host Composition

Host configurations should compose modules from `inputs.self.modules.*`. Host files should set only facts that are truly host-specific: hardware, boot, filesystems, network identity, users, host secrets access, and role-specific local choices.

Use Home Manager through the NixOS module for both full NixOS and NixOS-WSL hosts unless a future non-NixOS target is added.

`dominus` is currently a workstation proof of concept. Once that profile proves the coding, gaming, desktop, secrets, and remote-control workflow, reusable workstation modules should move toward `exile`, and `dominus` should become server-first.

Profiles are deferred until at least two hosts share the same feature bundle. Until then, hosts should import feature modules directly so the dendritic learning path remains visible.

## Package Policy

Stable `nixpkgs` is the default source for systems and user packages. Use `nixpkgs-unstable` only for explicitly chosen packages that need newer versions.

Unstable packages are exposed as `pkgs.unstable` through `modules/nix/unstable-overlay.nix`. Keep unstable use visible at package call sites, for example `pkgs.unstable.codex`.

## Future Optional Lanes

- `impermanence`: ephemeral root and persistent state.
- `stylix`: centralized themes.
- `nixvim`: managed Neovim distribution.
- `deploy-rs` or `colmena`: remote deployment.
- `lanzaboote`: Secure Boot.
- Binary cache: Cachix or private cache after real hosts exist.
