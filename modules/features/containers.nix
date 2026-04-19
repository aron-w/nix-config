{
  flake.modules.nixos."features-containers" = {
    virtualisation.docker.enable = true;
  };
}
