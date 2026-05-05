{
  flake.modules.homeManager."hosts-izaro-aron" = {
    home = {
      username = "aron";
      homeDirectory = "/home/aron";
      stateVersion = "25.11";
    };

    xdg.configFile."hypr/hyprland.conf" = {
      force = true;
      text = ''
        monitor=,preferred,auto,1

        debug {
          disable_logs = false
        }

        input {
          kb_layout = us
        }

        general {
          gaps_in = 5
          gaps_out = 10
          border_size = 2
          layout = dwindle
        }

        decoration {
          rounding = 8
        }

        misc {
          disable_hyprland_logo = false
          force_default_wallpaper = -1
        }

        exec-once = dbus-update-activation-environment --systemd DISPLAY HYPRLAND_INSTANCE_SIGNATURE WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
        exec-once = systemctl --user import-environment DISPLAY HYPRLAND_INSTANCE_SIGNATURE WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
        exec-once = waybar
        exec-once = mako

        $mainMod = SUPER
        $terminal = kitty
        $menu = wofi --show drun

        bind = $mainMod, Return, exec, $terminal
        bind = $mainMod, D, exec, $menu
        bind = $mainMod, M, exit
        bind = $mainMod, Q, killactive
        bind = $mainMod, V, togglefloating

        bind = $mainMod, 1, workspace, 1
        bind = $mainMod, 2, workspace, 2
        bind = $mainMod, 3, workspace, 3
        bind = $mainMod, 4, workspace, 4
        bind = $mainMod, 5, workspace, 5
        bind = $mainMod, 6, workspace, 6
        bind = $mainMod, 7, workspace, 7
        bind = $mainMod, 8, workspace, 8
        bind = $mainMod, 9, workspace, 9
      '';
    };
  };
}
