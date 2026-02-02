{
  config,
  pkgs,
  hyprlandPkgs,
  hyprlockPkgs,
  ...
}: let
  wallpaper = ../backgrounds/2-forest.jpg;
in {
  imports = [
    ../apps/waybar
    ../apps/rofi
  ];

  home.packages = with pkgs; [
    brightnessctl
    bluetui
  ];

  programs.hyprlock = {
    enable = true;

    settings = {
      background = {
        monitor = "";
      };
      input-field = {
        monitor = "";
        position = "0, -150";
        size = "300, 50";
        halign = "center";
        valign = "center";
      };
    };
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;

      preload = [
        "${wallpaper}"
      ];
      wallpaper = [
        "eDP-1,${wallpaper}"
        "HDMI-A-1,${wallpaper}"
      ];
    };
  };

  programs.kitty.enable = true;
  wayland.windowManager.hyprland = {
    enable = true;
    package = config.lib.nixGL.wrap hyprlandPkgs.hyprland;
    portalPackage = hyprlandPkgs.xdg-desktop-portal-hyprland;

    xwayland.enable = true;
    systemd.enable = true;

    settings = {
      "$mod" = "SUPER";
      monitor = [
        "eDP-1,preferred,0x0,1"
        "HDMI-A-1,preferred,auto,1"
      ];
      bindl = [
        ",switch:on:Lid Switch,exec,hyprctl keyword monitor \"eDP-1,disable\""
        ",switch:off:Lid Switch,exec,hyprctl keyword monitor \"eDP-1,preferred,0x0,1\""
      ];
      env = [
        "PATH,${config.home.homeDirectory}/.nix-profile/bin:$PATH"

        "XCURSOR_SIZE,32"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "QT_ENABLE_HIGHDPI_SCALING,1"
      ];
      general = {
        border_size = 1;
        gaps_in = 4;
        gaps_out = 8;
      };
      decoration = {
        rounding = 1;
      };
      input = {
        kb_layout = "us";
        kb_options = ["caps:escape"];
      };
      bind = [
        "$mod, Return, exec, ${config.home.homeDirectory}/.nix-profile/bin/ghostty"
        "$mod, Q, killactive"
        "$mod, M, exit"
        "$mod, F, fullscreen"
        "$mod, T, togglefloating"
        "$mod, P, pseudo"
        "$mod, BackSpace, exec, hyprlock"

        # Brightness
        ",XF86MonBrightnessUp,exec,brightnessctl set 5%+"
        ",XF86MonBrightnessDown,exec,brightnessctl set 5%-"

        # Volume
        ",XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute,exec,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute,exec,wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

        # Change Focus
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"

        # Move Window
        "$mod SHIFT, H, movewindow, l"
        "$mod SHIFT, L, movewindow, r"
        "$mod SHIFT, K, movewindow, u"
        "$mod SHIFT, J, movewindow, d"

        # Resize Window
        "$mod CTRL, H, resizeactive, -50 0"
        "$mod CTRL, L, resizeactive, 50 0"
        "$mod CTRL, K, resizeactive, 0 -50"
        "$mod CTRL, J, resizeactive, 0 50"

        # Workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"

        # Workspaces
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"

        # Toggle split orientation
        "$mod, V, splitratio, -1"

        "$mod, R, exec, ${config.home.homeDirectory}/.nix-profile/bin/rofi -show drun"
      ];
      exec-once = ["waybar"];
    };
  };
}
