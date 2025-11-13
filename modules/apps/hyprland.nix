{
  config,
  pkgs,
  hyprlandPkgs,
  hyprlockPkgs,
  ...
}: {
  imports = [
    ../apps/waybar
    ../apps/rofi
  ];

  programs.hyprlock.enable = true;

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
      ];
      env = [
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
        follow_mouse = 1;
      };
      bind = [
        "$mod, Return, exec, ${config.home.homeDirectory}/.nix-profile/bin/ghostty"
        "$mod, Q, killactive"
        "$mod, M, exit"
        "$mod, F, fullscreen"
        "$mod, T, togglefloating"
        "$mod, P, pseudo"
        "$mod, L, exec, hyprlock"

        "$mod, R, exec, ${config.home.homeDirectory}/.nix-profile/bin/rofi -show run"
        "$mod, D, exec, ${config.home.homeDirectory}/.nix-profile/bin/rofi -show drun"
      ];
      exec-once = ["waybar"];
    };
  };
}
