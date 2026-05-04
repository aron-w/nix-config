{ inputs, ... }:
let
  homeModules = inputs.self.modules.homeManager;
  nixosModules = inputs.self.modules.nixos;
in
{
  flake.nixosConfigurations.izaro = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      nixosModules."nix-settings"
      nixosModules."nixpkgs-unstable-overlay"
      nixosModules."home-manager"
      nixosModules."disko"
      nixosModules."sops"

      nixosModules."features-coding"
      nixosModules."features-containers"
      nixosModules."features-desktop-hyprland"
      nixosModules."features-desktop-plasma"
      nixosModules."features-gaming"
      nixosModules."features-power-user"
      nixosModules."features-ssh"

      nixosModules."hosts-izaro"
      nixosModules."hosts-izaro-disk"
      nixosModules."hosts-izaro-hardware"
      nixosModules."hosts-izaro-users"

      {
        home-manager.users.aron = {
          imports = [
            homeModules."features-coding"
            homeModules."features-onepassword-ssh"
            homeModules."features-power-user"
            homeModules."features-ssh"
            homeModules."hosts-izaro-aron"
          ];
        };
      }
    ];
  };
}
