# Decisions

Record structural choices here before future agents change them.

## Accepted

- Use flakes.
- Use `flake-parts` for top-level composition.
- Use stable Nixpkgs by default with explicit selective unstable access.
- Use Home Manager as a NixOS module for full NixOS and NixOS-WSL hosts.
- Use `sops-nix` with `age` for encrypted secrets.
- Use `disko` for the initial `dominus` full-machine install.
- Optimize editor docs for VS Code and Cursor first.
- Use `nixfmt` as the Nix formatter.
- Use `treefmt-nix` for `nix fmt` and formatting checks.
- Keep AI guidance tool-agnostic: durable docs in `docs/`, thin agent entrypoint in `AGENTS.md`.
- Start with local rebuild workflows. Do not add `deploy-rs` or `colmena` yet.

## Deferred

- Impermanence.
- Secure Boot.
- Binary cache.
- Remote deployment.
- Full theming.
- Managed Neovim.

## Host Names

- `exile`: main/gaming machine.
- `dominus`: first home server.
- `wsl-home`: personal NixOS-WSL environment.
- `wsl-work`: work NixOS-WSL environment.

## Host-Specific Decisions

- `dominus` starts as a workstation POC, not as the final server profile.
- `dominus` uses UEFI, systemd-boot, ext4, and the Samsung 840 EVO disk by stable disk ID.
- `dominus` uses Plasma 6 Wayland as default and Hyprland as an optional session because GTX 1060/NVIDIA/Pascal is a higher-risk Hyprland target than `exile`.
- `exile` is expected to be the better future Hyprland-first target because it has an AMD RX 6700 XT.
- `dominus` uses SSH-key-only remote login for `aron`; the local password is set on the machine and not stored in Git.
