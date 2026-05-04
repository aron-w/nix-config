{ inputs, ... }:
let
  homeModules = inputs.self.modules.homeManager;
  nixosModules = inputs.self.modules.nixos;
in
{
  flake.nixosConfigurations.izrao = inputs.nixpkgs.lib.nixosSystem {
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

      nixosModules."hosts-izrao"
      nixosModules."hosts-izrao-disk"
      nixosModules."hosts-izrao-hardware"
      nixosModules."hosts-izrao-users"

      {
        home-manager.users.aron = {
          imports = [
            homeModules."features-coding"
            homeModules."features-onepassword-ssh"
            homeModules."features-power-user"
            homeModules."features-ssh"
            homeModules."hosts-izrao-aron"
          ];
        };
      }
    ];
  };
}
