{
  flake.modules.nixos."hosts-izrao" = {
    networking = {
      hostName = "izrao";
      networkmanager.enable = true;
      firewall.enable = true;
    };

    time.timeZone = "Europe/Berlin";

    i18n.defaultLocale = "en_US.UTF-8";
    console.keyMap = "us";

    sops.age.sshKeyPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
    ];

    services.fwupd.enable = true;

    system.stateVersion = "25.11";
  };
}
