{
  flake.modules.nixos."hosts-dominus-hardware" =
    { config, ... }:
    {
      boot = {
        loader = {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        };

        kernelParams = [
          "nvidia-drm.modeset=1"
        ];
      };

      hardware = {
        graphics = {
          enable = true;
          enable32Bit = true;
        };

        nvidia = {
          modesetting.enable = true;
          nvidiaSettings = true;
          open = false;
          package = config.boot.kernelPackages.nvidiaPackages.stable;
          powerManagement.enable = false;
        };
      };

      services.xserver.videoDrivers = [
        "nvidia"
      ];
    };
}
