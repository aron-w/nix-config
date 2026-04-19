# Decisions

Record structural choices here before future agents change them.

## Accepted

- Use flakes.
- Use `flake-parts` for top-level composition.
- Use stable Nixpkgs by default with explicit selective unstable access.
- Use Home Manager as a NixOS module for full NixOS and NixOS-WSL hosts.
- Use `sops-nix` with `age` for encrypted secrets.
- Optimize editor docs for VS Code and Cursor first.
- Use `nixfmt` as the Nix formatter.
- Use `treefmt-nix` for `nix fmt` and formatting checks.
- Keep AI guidance tool-agnostic: durable docs in `docs/`, thin agent entrypoint in `AGENTS.md`.
- Start with local rebuild workflows. Do not add `deploy-rs` or `colmena` yet.

## Deferred

- Real `nixosConfigurations`.
- Disk layout and `disko`.
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
