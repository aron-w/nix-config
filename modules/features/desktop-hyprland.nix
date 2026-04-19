{
  flake.modules.nixos."features-desktop-hyprland" = {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };
}
