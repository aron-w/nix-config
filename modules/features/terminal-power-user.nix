{
  flake.modules.nixos."features-terminal-power-user" =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.curl
        pkgs.fd
        pkgs.file
        pkgs.git
        pkgs.git-lfs
        pkgs.gnumake
        pkgs.jq
        pkgs.just
        pkgs.pciutils
        pkgs.ripgrep
        pkgs.unzip
        pkgs.usbutils
        pkgs.vim
        pkgs.wget
        pkgs.zip
      ];

      programs.zsh.enable = true;
    };

  flake.modules.homeManager."features-terminal-power-user" =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.bat
        pkgs.bottom
        pkgs.delta
        pkgs.difftastic
        pkgs.direnv
        pkgs.dust
        pkgs.duf
        pkgs.eza
        pkgs.fastfetch
        pkgs.fzf
        pkgs.gh
        pkgs.git-lfs
        pkgs.hyperfine
        pkgs.lazygit
        pkgs.nix-direnv
        pkgs.ouch
        pkgs.procs
        pkgs.sd
        pkgs.tealdeer
        pkgs.tmux
        pkgs.tree
        pkgs.xh
        pkgs.yq
        pkgs.zoxide
      ];

      programs = {
        bash.enable = true;
        btop.enable = true;
        gh.enable = true;

        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };

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
            init.defaultBranch = "main";
            merge.conflictStyle = "zdiff3";
            pull.rebase = true;
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
