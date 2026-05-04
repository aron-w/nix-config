# Hosts

Do not add a real host configuration from assumptions. Collect the facts below first.

## Required Facts For Any Host

- Hostname.
- Architecture, usually `x86_64-linux` or `aarch64-linux`.
- Usernames and whether each user is managed by Home Manager.
- Stable release target.
- Whether unfree packages are allowed.
- Secrets required by the host.
- Activation command and rollback expectation.

## Required Facts For Full NixOS Hosts

- Boot mode: systemd-boot, GRUB, or other.
- Disk and filesystem plan.
- Generated `hardware-configuration.nix`, reviewed before importing.
- GPU and firmware requirements.
- Network management approach.
- Desktop/server role.

## Required Facts For NixOS-WSL Hosts

- Windows-side distro name.
- Whether systemd is enabled.
- Default Linux username.
- Interop needs with Windows paths, SSH agent, Git credentials, and Docker.
- Work/home separation rules.

## Current Hosts

- `dominus`: workstation POC for coding, gaming, desktop, secrets, and remote access before becoming server-first.
- `izrao`: current Windows gaming and coding workstation target; hardware facts are known from Windows, while install disk selection must be verified from the NixOS installer.

## Planned Hosts

- `exile`: main/gaming machine. Real hardware details are not known yet.
- `wsl-home`: personal NixOS-WSL profile. Real username and interop needs are not known yet.
- `wsl-work`: work NixOS-WSL profile. Real compliance and separation needs are not known yet.
