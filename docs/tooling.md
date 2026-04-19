# Tooling

The default development environment is exposed through `nix develop`.

## Direnv

Direnv is still useful for Nix repos because it loads the flake dev shell automatically per directory. The dev shell includes both `direnv` and `nix-direnv`. This repo uses:

```sh
use flake
```

Run this once after reviewing `.envrc`:

```sh
direnv allow
```

## Editor

VS Code and Cursor should use one Nix language server at a time.

Recommended default:

- Primary LSP: `nixd`.
- Alternative LSP: `nil`.
- Formatter: `nixfmt`.
- Environment: open the repo after `direnv allow`, or launch the editor from `nix develop`.

Avoid enabling both `nixd` and `nil` as active LSPs in the same workspace unless debugging LSP behavior.

The repo includes VS Code/Cursor recommendations in `.vscode/extensions.json` and conservative Nix IDE settings in `.vscode/settings.json`.

## Commands

```sh
nix develop
nix flake show
nix fmt
nix flake check
```

The first Nix command will create `flake.lock`. Review and commit that file.

For future local activations:

```sh
sudo nixos-rebuild switch --flake .#<host>
```

For future `nh` activations:

```sh
nh os switch . --hostname <host>
```
