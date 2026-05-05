{
  flake.modules.nixos."hosts-izaro" = {
    console = {
      useXkbConfig = true;
    };

    services.xserver.xkb = {
      layout = "us";
      variant = "altgr-intl";
    };

    networking = {
      hostName = "izaro";
      networkmanager.enable = true;
      firewall.enable = true;
    };

    time.timeZone = "Europe/Berlin";

    i18n.defaultLocale = "en_US.UTF-8";

    sops.age.sshKeyPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
    ];

    zramSwap = {
      enable = true;
      memoryPercent = 100;
    };

    swapDevices = [
      {
        device = "/var/lib/swapfile";
        size = 16 * 1024;
      }
    ];

    services.fwupd.enable = true;

    system.stateVersion = "25.11";
  };
}
