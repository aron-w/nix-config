{ pkgs, pkgsUnstable, ... }:
{
  home = {
    username = "aron";
    homeDirectory = "/home/aron";
    stateVersion = "25.11";

    packages = [
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

      pkgsUnstable.codex
    ];
  };

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

    ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks."*" = { };
    };
  };
}
