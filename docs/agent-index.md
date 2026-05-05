# Agent Index

Use this as the first repo map after `AGENTS.md`. Read deeper docs only when the task routes there.

## Directory Map

- `flake.nix`: inputs and top-level flake-parts entrypoint.
- `modules/flake/`: supported systems, dev shell, formatter, checks, and flake-level plumbing.
- `modules/nix/`: Nix integrations such as Home Manager, Disko, SOPS, settings, and unstable package access.
- `modules/features/`: reusable NixOS and Home Manager behavior.
- `modules/hosts/<name>/`: host-specific composition and facts.
- `docs/`: durable human and agent conventions.
- `scripts/`: host-independent helper commands.
- `secrets/`: encrypted SOPS files only.

## Package Placement

- Stable package: use `pkgs.<name>`.
- Explicit unstable package: use `pkgs.unstable.<name>`.
- Unstable overlay definition: `modules/nix/unstable-overlay.nix`.
- Shared desktop GUI packages: `modules/features/desktop-plasma.nix`.
- Coding tools: `modules/features/coding.nix`.
- General power-user CLI tools: `modules/features/power-user.nix`.
- Gaming packages/settings: `modules/features/gaming.nix`.

## Host Status

- `dominus`: concrete workstation POC host.
- `izaro`: concrete gaming and coding workstation target.
- `exile`: planned main/gaming machine.
- `wsl-home`: planned personal NixOS-WSL environment.
- `wsl-work`: planned work NixOS-WSL environment.

Do not add or complete planned hosts from guesses. Read `docs/hosts.md` before host changes.

## Search Guidance

- Check this index before broad searches.
- Use `rg --files` for file discovery.
- Use `rg "pattern"` for text search.
- Prefer targeted reads over loading whole docs when a task only needs one section.
