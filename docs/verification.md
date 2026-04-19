# Verification

Use the strongest verification available from the machine you are on.

## From Windows With Docker Desktop

The Docker workflow is useful before a local Nix install exists.

PowerShell:

```powershell
.\scripts\nix-check-docker.ps1
```

Shell:

```sh
./scripts/nix-check-docker.sh
```

This uses the official Nix container to run:

```sh
nix --extra-experimental-features "nix-command flakes" flake check
```

Limitations:

- It can evaluate the flake and build checks.
- It is not a full NixOS boot test.
- Docker sandboxing differs from a normal Nix install.
- It does not replace `nixos-rebuild test` on real hardware.

## From NixOS

Before switching a host:

```sh
nix flake check
sudo nixos-rebuild test --flake .#dominus
```

After the test generation works:

```sh
sudo nixos-rebuild switch --flake .#dominus
```

For first install with disko, use the documented disko install flow and verify the disk ID before running any wipe command.
