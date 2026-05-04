{ inputs, ... }:
let
  codexPkgFor = pkgs: inputs.codex-cli-nix.packages.${pkgs.system}.default;
in
{
  flake.modules.nixos."features-coding" =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.curl
        pkgs.fd
        pkgs.git
        pkgs.jq
        pkgs.ripgrep
        pkgs.unzip
        pkgs.vscode
        pkgs.wget
        pkgs.xclip
        pkgs.xdg-utils
        pkgs.zip

        (codexPkgFor pkgs)
        pkgs.unstable.nh
      ];
    };

  flake.modules.homeManager."features-coding" =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.bat
        pkgs.bottom
        pkgs.delta
        pkgs.direnv
        pkgs.eza
        pkgs.fzf
        pkgs.nil
        pkgs.nix-direnv
        pkgs.nixd
        pkgs.nixfmt
        pkgs.nodejs_24
        pkgs.uv
        pkgs.zoxide

        (codexPkgFor pkgs)
      ];

      programs = {
        bash.enable = true;

        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };

        git = {
          enable = true;
          settings = {
            init.defaultBranch = "main";
            pull.rebase = true;
          };
        };
      };
    };
}
