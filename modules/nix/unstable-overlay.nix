{ inputs, ... }:
let
  unstableOverlay = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final) config;
      inherit (final.stdenv.hostPlatform) system;
    };
  };
in
{
  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          unstableOverlay
        ];
      };
    };

  flake.modules.nixos."nixpkgs-unstable-overlay" = {
    nixpkgs.overlays = [
      unstableOverlay
    ];
  };
}
