{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ./styles.css;
    settings = {
      mainBar = {
        reload-style-on-change = true;
        layer = "top";
        position = "top";
        spacing = 0;
        height = 26;
        modules-left = ["hyprland/workspaces"];
        modules-center = ["clock"];
        modules-right = ["group/tray-expander" "bluetooth" "network" "pulseaudio" "cpu" "battery"];
      };
    };
  };
}
