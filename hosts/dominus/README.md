# dominus

POC desktop/gaming/coding profile for the future home server.

This host intentionally starts as an `exile`-style workstation proof of concept:

- Ryzen 5 3600.
- NVIDIA GTX 1060 3GB.
- 32 GB DDR4.
- Samsung 840 EVO SATA SSD.
- UEFI boot.
- Plasma 6 Wayland as the reliable default session.
- Hyprland installed as an optional session.

After the desktop/gaming/coding workflow is proven, reusable parts should move toward `exile`, and `dominus` should become server-first.

## Bootstrap Notes

The disk layout is declarative through `disko` and targets:

```text
/dev/disk/by-id/ata-Samsung_SSD_840_EVO_120GB_S1D5NSBF107735D
```

This will wipe and repartition the SSD when run through `disko-install`.

Remote SSH login is key-only for `aron`. Set the local graphical/sudo password on the host during bootstrap:

```sh
passwd aron
```

Secrets are wired through `sops-nix`, but no encrypted secrets are defined until the host age recipient is generated.
