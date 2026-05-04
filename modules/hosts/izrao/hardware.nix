{
  flake.modules.nixos."hosts-izrao-hardware" =
    { config, lib, ... }:
    {
      boot = {
        initrd = {
          availableKernelModules = [
            "ahci"
            "nvme"
            "sd_mod"
            "usbhid"
            "xhci_pci"
          ];
          kernelModules = [
            "amdgpu"
          ];
        };

        loader = {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        };

        supportedFilesystems = [
          "ntfs"
        ];
      };

      hardware = {
        enableRedistributableFirmware = true;

        cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

        graphics = {
          enable = true;
          enable32Bit = true;
        };
      };

      services.xserver.videoDrivers = [
        "amdgpu"
      ];
    };
}
