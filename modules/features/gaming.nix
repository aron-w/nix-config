{
  flake.modules.nixos."features-gaming" =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.lutris
        pkgs.mangohud
        pkgs.moonlight-qt
        pkgs.protonup-qt
        pkgs.protontricks
        pkgs.steam-run
        pkgs.vulkan-tools
        pkgs.wineWowPackages.staging
        pkgs.winetricks
      ];

      hardware.steam-hardware.enable = true;

      programs = {
        appimage = {
          enable = true;
          binfmt = true;
        };

        gamemode.enable = true;

        gamescope = {
          enable = true;
          capSysNice = true;
        };

        nix-ld.enable = true;

        steam = {
          enable = true;
          remotePlay.openFirewall = true;
          localNetworkGameTransfers.openFirewall = true;
          gamescopeSession.enable = true;
        };
      };
    };
}
