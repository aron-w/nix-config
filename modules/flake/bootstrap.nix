{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      apps.bootstrap = {
        type = "app";
        meta.description = "Bootstrap this NixOS config repo.";
        program = "${
          pkgs.writeShellApplication {
            name = "bootstrap";
            runtimeInputs = [
              pkgs.coreutils
              pkgs.git
              pkgs.nix
              pkgs.openssh
            ];
            text = ''
              export BOOTSTRAP_FLAKE="${inputs.self}"
              exec bash ${../../scripts/bootstrap.sh} "$@"
            '';
          }
        }/bin/bootstrap";
      };
    };
}
