{
  config,
  inputs,
  pkgs,
  ...
}:
let
  pkgsUnstable = import inputs.nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;
    config.allowUnfree = true;
  };
in
{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    ./disko.nix
  ];

  networking = {
    hostName = "dominus";
    networkmanager.enable = true;
    firewall.enable = true;
  };

  time.timeZone = "Europe/Berlin";

  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    optimise.automatic = true;
  };

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

  services = {
    xserver = {
      enable = true;
      videoDrivers = [
        "nvidia"
      ];
    };

    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    desktopManager.plasma6.enable = true;

    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };

    openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  programs = {
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [
        "aron"
      ];
    };

    hyprland = {
      enable = true;
      xwayland.enable = true;
    };

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

  virtualisation.docker.enable = true;

  users = {
    mutableUsers = true;
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

  sops = {
    age.sshKeyPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
    ];
    secrets = { };
  };

  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    systemPackages = [
      pkgs.curl
      pkgs.fd
      pkgs.firefox
      pkgs.git
      pkgs.jq
      pkgs.lutris
      pkgs.mangohud
      pkgs.moonlight-qt
      pkgs.protonup-qt
      pkgs.ripgrep
      pkgs.rustdesk-flutter
      pkgs.steam-run
      pkgs.unzip
      pkgs.vscode
      pkgs.wget
      pkgs.xclip
      pkgs.xdg-utils
      pkgs.zip

      pkgsUnstable.codex
      pkgsUnstable.nh
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs pkgsUnstable;
    };
    users.aron = import ./home.nix;
  };

  system.stateVersion = "25.11";
}
