{
  config,
  pkgs,
  hyprlandPkgs,
  hyprlockPkgs,
  ...
}: let
  lockCmd = "/usr/bin/swaylock";
  wallpaper = ../backgrounds/2-forest.jpg;
in {
  imports = [
    ../apps/waybar
    ../apps/rofi
  ];

  home.packages = with pkgs; [
    brightnessctl
    bluetui
    grim
    hypridle
    slurp
    swappy
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

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = lockCmd;
        before_sleep_cmd = lockCmd;
      };
      listener = [
        {
          timeout = 300;
          on-timeout = lockCmd;
        }
        {
          timeout = 1200;
          on-timeout = "systemctl hibernate";
        }
      ];
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

  home.file.".config/swaylock/config".text = ''
    show-failed-attempts
    indicator-idle-visible
    indicator-radius=90
    indicator-thickness=8
    line-uses-ring
    font=JetBrainsMono Nerd Font
    font-size=24
    image=${wallpaper}
    scaling=fill
    color=1b1f2a
    inside-color=02010188
    ring-color=393726cc
    ring-clear-color=816844ff
    ring-ver-color=9b7b52ff
    ring-wrong-color=7a3b2bff
    key-hl-color=816844ff
    inside-clear-color=020101aa
    inside-ver-color=020101aa
    inside-wrong-color=020101aa
    line-color=00000000
    line-clear-color=00000000
    line-ver-color=00000000
    line-wrong-color=00000000
    separator-color=00000000
    text-color=e6e1d6ff
    text-ver-color=e6e1d6ff
    text-wrong-color=e6e1d6ff
    text-clear-color=e6e1d6ff
  '';

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
        "$mod, BackSpace, exec, ${lockCmd}"
        "$mod SHIFT, BackSpace, exec, systemctl hibernate"
        ",XF86Sleep,exec,systemctl hibernate"

        # Brightness
        ",XF86MonBrightnessUp,exec,brightnessctl set 5%+"
        ",XF86MonBrightnessDown,exec,brightnessctl set 5%-"

        # Volume
        ",XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute,exec,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute,exec,wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

        # Screenshots
        "$mod, S,exec,grim -g \"$(slurp)\" - | wl-copy"
        "$mod SHIFT,S,exec,grim -g \"$(slurp)\" - | swappy -f -"

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
