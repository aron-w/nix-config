{
  flake.modules.nixos."features-gaming" =
    { pkgs, ... }:
    let
      optiscaler = pkgs.stdenvNoCC.mkDerivation {
        pname = "optiscaler";
        version = "0.9.1";

        src = pkgs.fetchurl {
          url = "https://github.com/optiscaler/OptiScaler/releases/download/v0.9.1/Optiscaler_0.9.1-final.20260427._DSB.7z";
          hash = "sha256-VtGhjjoy2XjAE0hE6AO6jPBBNCJs/NuCg/aNGAg2+rA=";
        };

        nativeBuildInputs = [
          pkgs.p7zip
        ];

        dontConfigure = true;
        dontBuild = true;

        unpackPhase = ''
          runHook preUnpack
          7z x "$src"
          runHook postUnpack
        '';

        installPhase = ''
          runHook preInstall
          mkdir -p "$out/share/optiscaler"
          cp -r . "$out/share/optiscaler"
          runHook postInstall
        '';
      };

      optiscalerEnshrouded = pkgs.writeShellApplication {
        name = "optiscaler-enshrouded";
        runtimeInputs = [
          pkgs.coreutils
          pkgs.findutils
          pkgs.gnused
          pkgs.rsync
        ];
        text = ''
          set -euo pipefail

          optiscaler_src="${optiscaler}/share/optiscaler"
          game_dir="''${STEAM_LIBRARY:-$HOME/.local/share/Steam}/steamapps/common/Enshrouded"
          dll_name="winmm.dll"

          usage() {
            cat <<'EOF'
          Usage: optiscaler-enshrouded [install|remove|status|launch-options] [--game-dir PATH] [--force]

          Installs the pinned Nix-provided OptiScaler build next to enshrouded.exe.
          Steam launch option after install:
            WINEDLLOVERRIDES=winmm=n,b mangohud %COMMAND%
          EOF
          }

          command="status"
          force="n"
          while [ "$#" -gt 0 ]; do
            case "$1" in
              install|remove|status|launch-options)
                command="$1"
                shift
                ;;
              --game-dir)
                game_dir="$2"
                shift 2
                ;;
              --force)
                force="y"
                shift
                ;;
              -h|--help)
                usage
                exit 0
                ;;
              *)
                echo "Unknown argument: $1" >&2
                usage >&2
                exit 2
                ;;
            esac
          done

          manifest="$game_dir/.optiscaler-nix-manifest"

          require_game_dir() {
            if [ ! -f "$game_dir/enshrouded.exe" ]; then
              echo "Could not find enshrouded.exe in: $game_dir" >&2
              echo "Pass --game-dir PATH if the Steam library is elsewhere." >&2
              exit 1
            fi
          }

          case "$command" in
            launch-options)
              echo "WINEDLLOVERRIDES=winmm=n,b mangohud %COMMAND%"
              ;;

            status)
              require_game_dir
              echo "Game dir: $game_dir"
              if [ -f "$game_dir/$dll_name" ] && [ -f "$manifest" ]; then
                echo "OptiScaler appears installed by optiscaler-enshrouded."
              elif [ -f "$game_dir/$dll_name" ]; then
                echo "$dll_name exists, but no optiscaler-enshrouded manifest was found."
              else
                echo "OptiScaler is not installed as $dll_name."
              fi
              ;;

            install)
              require_game_dir
              if [ -e "$game_dir/$dll_name" ] && [ ! -f "$manifest" ] && [ "$force" != "y" ]; then
                echo "$game_dir/$dll_name already exists and was not created by this helper." >&2
                echo "Inspect it first, or rerun with --force to back it up and replace it." >&2
                exit 1
              fi

              timestamp="$(date +%Y%m%d-%H%M%S)"
              backup_dir="$game_dir/backup/optiscaler-$timestamp"
              mkdir -p "$backup_dir"

              if [ -e "$game_dir/$dll_name" ] && [ ! -f "$manifest" ]; then
                mv "$game_dir/$dll_name" "$backup_dir/$dll_name"
              fi

              if [ -f "$manifest" ]; then
                while IFS= read -r relpath; do
                  [ -n "$relpath" ] || continue
                  rm -rf -- "''${game_dir:?}/''${relpath:?}"
                done < "$manifest"
              fi

              rsync -a --chmod=u+w "$optiscaler_src"/ "$game_dir"/
              if [ ! -f "$game_dir/OptiScaler.dll" ]; then
                echo "The OptiScaler release did not contain OptiScaler.dll." >&2
                exit 1
              fi
              mv "$game_dir/OptiScaler.dll" "$game_dir/$dll_name"

              (
                cd "$optiscaler_src"
                find . -mindepth 1 -printf '%P\n' | sed "s#^OptiScaler.dll\$#$dll_name#"
              ) | sort -u > "$manifest"

              echo "Installed OptiScaler ${optiscaler.version} into: $game_dir"
              echo "Set this Steam launch option:"
              echo "WINEDLLOVERRIDES=winmm=n,b mangohud %COMMAND%"
              ;;

            remove)
              require_game_dir
              if [ ! -f "$manifest" ]; then
                echo "No optiscaler-enshrouded manifest found in: $game_dir" >&2
                exit 1
              fi

              while IFS= read -r relpath; do
                [ -n "$relpath" ] || continue
                rm -rf -- "''${game_dir:?}/''${relpath:?}"
              done < "$manifest"
              rm -f "$manifest"
              echo "Removed OptiScaler files installed by optiscaler-enshrouded."
              ;;
          esac
        '';
      };
    in
    {
      environment.systemPackages = [
        pkgs.lutris
        pkgs.mangohud
        pkgs.moonlight-qt
        optiscaler
        optiscalerEnshrouded
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
