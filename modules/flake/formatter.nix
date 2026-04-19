{ inputs, ... }:
let
  repoRoot = ../..;
in
{
  imports = [
    inputs.treefmt-nix.flakeModule
  ];

  perSystem =
    { pkgs, ... }:
    {
      treefmt = {
        projectRootFile = "flake.nix";

        programs = {
          nixfmt.enable = true;
        };

        settings = {
          global.excludes = [
            "flake.lock"
            ".direnv/**"
            "result"
            "result-*"
          ];
        };
      };

      checks.deadnix = pkgs.runCommand "deadnix-check" { nativeBuildInputs = [ pkgs.deadnix ]; } ''
        deadnix --fail ${repoRoot}
        touch $out
      '';

      checks.statix = pkgs.runCommand "statix-check" { nativeBuildInputs = [ pkgs.statix ]; } ''
        statix check ${repoRoot}
        touch $out
      '';
    };
}
