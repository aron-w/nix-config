{
  flake.modules.nixos."features-desktop-plasma" =
    { pkgs, ... }:
    {
      environment = {
        sessionVariables = {
          NIXOS_OZONE_WL = "1";
        };

        systemPackages = [
          pkgs.firefox
          pkgs.unstable.spotify
          pkgs.unstable.vesktop
          pkgs.wl-clipboard
          pkgs.xclip
          pkgs.xdg-utils
        ];
      };

      services = {
        xserver.enable = true;

        displayManager.sddm = {
          enable = true;
          wayland.enable = true;
        };

        desktopManager.plasma6.enable = true;

        pipewire = {
          enable = true;
          alsa = {
            enable = true;
            support32Bit = true;
          };
          pulse.enable = true;
          jack.enable = true;
        };
      };

      hardware.logitech.wireless = {
        enable = true;
        enableGraphical = true;
      };

      security = {
        polkit.enable = true;
        rtkit.enable = true;
      };

      programs = {
        _1password.enable = true;
        _1password-gui.enable = true;
      };
    };
}
