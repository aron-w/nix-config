{
  flake.templates = {
    nixos-host = {
      path = ../../templates/nixos-host;
      description = "Template for a future full NixOS host module";
    };

    nixos-wsl-host = {
      path = ../../templates/nixos-wsl-host;
      description = "Template for a future NixOS-WSL host module";
    };

    home-profile = {
      path = ../../templates/home-profile;
      description = "Template for a future Home Manager profile";
    };
  };
}
