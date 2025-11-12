{ config, pkgs, lib, ... }:
let
  wrapWithNixGL = config.lib ? nixGL && config.lib.nixGL ? wrap;
  ghosttyPackage =
    if wrapWithNixGL
    then config.lib.nixGL.wrap pkgs.ghostty
    else pkgs.ghostty;
in {
  programs.ghostty = {
    enable = lib.mkDefault true;
    package = lib.mkDefault ghosttyPackage;
    settings = {
      theme = lib.mkDefault "GruvboxDark";
      background-opacity = lib.mkDefault 0.9;
      font-family = lib.mkDefault "Terminess Nerd Font Mono";
      font-size = lib.mkDefault 15;
    };
  };
}
