{
  flake.modules.nixos."features-desktop-hyprland" =
    { pkgs, ... }:
    {
      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
      };

      xdg.portal = {
        enable = true;
        extraPortals = [
          pkgs.xdg-desktop-portal-gtk
          pkgs.xdg-desktop-portal-hyprland
        ];
      };

      environment = {
        sessionVariables = {
          NIXOS_OZONE_WL = "1";
        };

        systemPackages = [
          pkgs.grim
          pkgs.kitty
          pkgs.mako
          pkgs.slurp
          pkgs.waybar
          pkgs.wl-clipboard
          pkgs.xdg-utils
          pkgs.wofi
        ];
      };
    };
}
