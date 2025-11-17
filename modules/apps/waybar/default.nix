{
  config,
  pkgs,
  lib,
  ...
}: let
  waybarSettings = builtins.fromJSON (builtins.readFile ./settings.json);
in {
  programs.waybar = {
    enable = true;
    systemd.enable = false;
    style = ./styles.css;
    settings = waybarSettings;
  };
}
