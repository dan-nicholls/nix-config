{
  config,
  pkgs,
  lib,
  nixglPkgs,
  deviceName ? "desktop",
  zenModule,
  ...
}: {
  imports = [zenModule];
  programs.zen-browser = {
    enable = true;
  };

  nixGL.packages = nixglPkgs;

  programs.ghostty = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.ghostty;
    settings = {
      theme = "GruvboxDark";
      background-opacity = 0.9;
      font-family = "Terminess Nerd Font Mono";
      font-size = 15;
    };
  };

  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.terminess-ttf
    #(config.lib.nixGL.wrap pkgs.prismlauncher)
  ];
}
