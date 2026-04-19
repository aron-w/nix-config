{ inputs, ... }:
let
  homeModules = inputs.self.modules.homeManager;
  nixosModules = inputs.self.modules.nixos;
in
{
  flake.nixosConfigurations.dominus = inputs.nixpkgs.lib.nixosSystem {
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
      nixosModules."features-remote-access"
      nixosModules."features-ssh"

      nixosModules."hosts-dominus"
      nixosModules."hosts-dominus-disk"
      nixosModules."hosts-dominus-hardware"
      nixosModules."hosts-dominus-users"

      {
        home-manager.users.aron = {
          imports = [
            homeModules."features-coding"
            homeModules."features-onepassword-ssh"
            homeModules."features-ssh"
            homeModules."hosts-dominus-aron"
          ];
        };
      }
    ];
  };
}
