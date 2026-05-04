# Izaro Install

`izaro` is the NixOS profile for the current Windows gaming and coding workstation.

## Hardware Facts

Collected from Windows on 2026-05-04:

- Chassis/mainboard: MSI `MS-7E26`.
- CPU: AMD Ryzen 5 7500F, 6 cores, 12 threads.
- GPU: AMD Radeon RX 6700 XT.
- Memory: 32 GiB.
- Firmware boot mode: UEFI.
- Secure Boot: not verified from Windows; this config uses plain systemd-boot and assumes Secure Boot is disabled.
- Current Windows boot disk: `CT1000P3SSD8`, serial `6479_A77F_9000_00A2`, 1 TB NVMe, GPT.
- Other currently attached disks: Samsung SSD 850 EVO 500 GB and Samsung SSD 870 EVO 2 TB, both MBR SATA disks.

Do not target the current Windows boot disk unless Windows is meant to be wiped.

## Included Workflow

The `izaro` host imports:

- Plasma 6 Wayland for the reliable default desktop.
- Hyprland as an optional power-user Wayland session.
- Steam, GameMode, Gamescope, MangoHud, Lutris, ProtonUp-Qt, Protontricks, Wine, Winetricks, Vulkan tools, AppImage support, and `nix-ld`.
- 32-bit graphics support for Steam and Proton through the AMD host hardware module.
- Codex from unstable, VS Code, Nix language servers, Node.js 24, `uv`, Docker, direnv, and Nix formatting tools.
- Git-heavy shell tooling: Git LFS, GitHub CLI, Lazygit, Difftastic, Delta, Starship, Zoxide, `just`, `ripgrep`, `fd`, `bat`, `eza`, and related inspection tools.
- 1Password SSH agent integration for GitHub SSH once 1Password is enabled after first login.

## Before Installing

Boot the NixOS installer and identify disks from Linux:

```sh
lsblk -o NAME,SIZE,MODEL,SERIAL,TYPE,MOUNTPOINTS
ls -l /dev/disk/by-id/
```

Then edit `modules/hosts/izaro/disk.nix` and replace:

```nix
"/dev/disk/by-id/REPLACE_WITH_TARGET_SSD"
```

with the verified target SSD path. This placeholder is intentional so Disko fails instead of wiping an accidental disk.

Generate and review Linux hardware facts before the final switch:

```sh
sudo nixos-generate-config --show-hardware-config
```

The current repo hardware module already captures the known AMD CPU/GPU and UEFI facts, but generated Linux filesystem and kernel-module facts should still be compared on the real installer boot.

## Path 1: Fresh Internal SSD

Use this when a fresh internal SSD is installed and ready to become the NixOS disk.

1. Boot the NixOS graphical installer USB in UEFI mode.
2. Connect networking.
3. Run the install wizard:

```sh
nix --extra-experimental-features "nix-command flakes" run github:aron-w/nix-config#bootstrap -- --mode install-wizard --host izaro --yes --i-understand-this-wipes-the-disk
```

Short wrapper for the same flow:

```sh
curl -fsSL https://raw.githubusercontent.com/aron-w/nix-config/main/scripts/install-izaro.sh | sh
```

The wizard will:

- clone or update the repo,
- show `lsblk` output and `/dev/disk/by-id` candidates,
- ask for the exact target SSD path,
- temporarily inject that path into the `izaro` disk module,
- run `disko`, `nixos-install`, and the first password prompt.

4. If you want the manual fallback instead, clone the repo and enter it:

```sh
git clone https://github.com/aron-w/nix-config.git
cd nix-config
```

5. Replace the placeholder disk in `modules/hosts/izaro/disk.nix` with the fresh SSD's `/dev/disk/by-id/...` path.
6. Format, install, and set the local password:

```sh
nix --extra-experimental-features "nix-command flakes" flake check
sudo nix --extra-experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode disko --flake .#izaro
sudo nixos-install --flake .#izaro
sudo nixos-enter --root /mnt -c "passwd aron"
```

7. Reboot, select the new NixOS disk in firmware, sign in as `aron`, and run the auth helper:

```sh
nix --extra-experimental-features "nix-command flakes" run github:aron-w/nix-config#bootstrap -- --mode auth --yes
```

## Path 2: External SSD Bootstrap

Use this when you want a reversible staging system before touching the internal SSD.

1. Boot the NixOS installer USB in UEFI mode with the external SSD attached.
2. Run the same install wizard from Path 1 and choose the external SSD's `/dev/disk/by-id/...` path.
3. Reboot into the external SSD and validate the desktop, Steam, Codex, GitHub SSH, and hardware behavior.
4. After the fresh internal SSD is installed, rerun the same wizard and choose the internal SSD, or use the manual fallback and update `modules/hosts/izaro/disk.nix` before `disko` and `nixos-install`.

The external SSD path gives you a bootable NixOS workspace with this repo, Nix, Git, and the full `izaro` tooling before the final internal install.
