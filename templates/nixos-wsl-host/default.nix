{
  lib,
  ...
}:
{
  imports = [
    # inputs.nixos-wsl.nixosModules.default
  ];

  networking.hostName = lib.mkDefault "replace-me";

  wsl = {
    enable = true;
    defaultUser = "replace-me";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "25.11";
}
