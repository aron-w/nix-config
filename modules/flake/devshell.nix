{
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShellNoCC {
        packages = [
          pkgs.age
          pkgs.deadnix
          pkgs.direnv
          pkgs.git
          pkgs.nil
          pkgs.nix-direnv
          pkgs.nix-output-monitor
          pkgs.nix-tree
          pkgs.nixd
          pkgs.nixfmt
          pkgs.nixpkgs-review
          pkgs.sops
          pkgs.ssh-to-age
          pkgs.statix

          pkgs.unstable.nh
        ];

        shellHook = ''
          echo "NixOS config dev shell"
          echo "Run: nix flake check"
          echo "Run: nix fmt"
        '';
      };
    };
}
