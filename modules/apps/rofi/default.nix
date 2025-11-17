{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.rofi = {
    enable = true;

    theme = ./theme.rasi;
  };
}
