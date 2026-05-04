{
  flake.modules.nixos."hosts-izaro-disk" =
    {
      config,
      lib,
      ...
    }:
    {
      options.awe.hosts.izaro.installDisk = lib.mkOption {
        type = lib.types.str;
        default = "/dev/disk/by-id/REPLACE_WITH_TARGET_SSD";
        description = ''
          Disko target for Izaro installs. Replace this with the verified
          /dev/disk/by-id path for the fresh internal SSD or external bootstrap SSD.
        '';
      };

      config.disko.devices = {
        disk.system = {
          type = "disk";
          device = config.awe.hosts.izaro.installDisk;
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                size = "1G";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [
                    "umask=0077"
                  ];
                };
              };

              root = {
                size = "100%";
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/";
                };
              };
            };
          };
        };
      };
    };
}
