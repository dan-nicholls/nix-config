{pkgs, lib, ...}: {
  programs.ghostty = {
    enable = lib.mkDefault true;
    package = lib.mkDefault pkgs.ghostty;
    settings = {
      theme = lib.mkDefault "GruvboxDark";
      background-opacity = lib.mkDefault 0.9;
      font-family = lib.mkDefault "Terminess Nerd Font Mono";
      font-size = lib.mkDefault 15;
    };
  };
}
