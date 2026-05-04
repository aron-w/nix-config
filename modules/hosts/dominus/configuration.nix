{
  flake.modules.nixos."hosts-dominus" = {
    console = {
      useXkbConfig = true;
    };

    i18n.defaultLocale = "en_US.UTF-8";

    networking = {
      hostName = "dominus";
      networkmanager.enable = true;
      firewall.enable = true;
    };

    services.xserver.xkb = {
      layout = "us";
      variant = "altgr-intl";
    };

    time.timeZone = "Europe/Berlin";

    sops.age.sshKeyPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
    ];

    system.stateVersion = "25.11";
  };
}
