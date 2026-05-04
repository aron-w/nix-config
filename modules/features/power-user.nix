{
  flake.modules.nixos."features-power-user" =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.file
        pkgs.git-lfs
        pkgs.gnumake
        pkgs.just
        pkgs.pciutils
        pkgs.usbutils
        pkgs.vim
        pkgs.wl-clipboard
      ];

      programs.zsh.enable = true;
    };

  flake.modules.homeManager."features-power-user" =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.difftastic
        pkgs.fastfetch
        pkgs.gh
        pkgs.git-lfs
        pkgs.lazygit
        pkgs.tealdeer
        pkgs.tree
        pkgs.yq
      ];

      programs = {
        btop.enable = true;
        gh.enable = true;

        git = {
          enable = true;
          lfs.enable = true;
          settings = {
            alias = {
              co = "checkout";
              graph = "log --oneline --graph --decorate --all";
              s = "status --short --branch";
            };
            diff.tool = "difftastic";
            difftool.prompt = false;
            merge.conflictStyle = "zdiff3";
            rerere.enabled = true;
          };
        };

        starship.enable = true;

        zoxide = {
          enable = true;
          enableBashIntegration = true;
          enableZshIntegration = true;
        };

        zsh = {
          enable = true;
          enableCompletion = true;
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;
          shellAliases = {
            g = "git";
            glg = "git log --oneline --graph --decorate --all";
            gst = "git status --short --branch";
            rebuild = "nh os switch . --hostname $(hostname)";
          };
        };
      };
    };
}
