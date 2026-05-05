{ inputs, ... }:
let
  codexPkgFor = pkgs: inputs.codex-cli-nix.packages.${pkgs.system}.default;
in
{
  flake.modules.nixos."features-coding" =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.vscode

        (codexPkgFor pkgs)
        pkgs.unstable.nh
      ];
    };

  flake.modules.homeManager."features-coding" =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.nil
        pkgs.nixd
        pkgs.nixfmt
        pkgs.nodejs_24
        pkgs.uv

        (codexPkgFor pkgs)
      ];
    };
}
