{
  description = "Personal NixOS, NixOS-WSL, and Home Manager configuration scaffold";

  nixConfig = {
    extra-experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    inputs@{
      flake-parts,
      treefmt-nix,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        treefmt-nix.flakeModule
        ./nix/devshell.nix
        ./nix/formatter.nix
      ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      flake = {
        templates = {
          nixos-host = {
            path = ./templates/nixos-host;
            description = "Template for a future full NixOS host module";
          };

          nixos-wsl-host = {
            path = ./templates/nixos-wsl-host;
            description = "Template for a future NixOS-WSL host module";
          };

          home-profile = {
            path = ./templates/home-profile;
            description = "Template for a future Home Manager profile";
          };
        };
      };
    };
}
