{ lib, ... }:
{
  imports = [
    # ./hardware-configuration.nix
  ];

  # Replace every placeholder before importing this module into flake outputs.
  networking.hostName = lib.mkDefault "replace-me";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "25.11";
}
