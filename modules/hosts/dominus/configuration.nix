{
  flake.modules.nixos."hosts-dominus" = {
    networking = {
      hostName = "dominus";
      networkmanager.enable = true;
      firewall.enable = true;
    };

    time.timeZone = "Europe/Berlin";

    sops.age.sshKeyPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
    ];

    system.stateVersion = "25.11";
  };
}
