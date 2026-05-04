{
  flake.modules.nixos."hosts-izrao-users" =
    { pkgs, ... }:
    {
      users = {
        mutableUsers = true;
        defaultUserShell = pkgs.zsh;
        users.aron = {
          isNormalUser = true;
          description = "Aron";
          extraGroups = [
            "docker"
            "networkmanager"
            "video"
            "wheel"
          ];
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGTfW29yQzRaOJNIFBZQuf8eQ6PBNUO/xv+mP7qaHmdi"
          ];
        };
      };

      programs._1password-gui.polkitPolicyOwners = [
        "aron"
      ];
    };
}
