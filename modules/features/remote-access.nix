{
  flake.modules.nixos."features-remote-access" =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.rustdesk-flutter
      ];

      services.sunshine = {
        enable = true;
        autoStart = true;
        capSysAdmin = true;
        openFirewall = true;
      };
    };
}
