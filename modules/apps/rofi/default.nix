{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.rofi = {
    enable = true;

    theme = ./theme.rasi;

    extraConfig = {
      show-icons = true;
      icon-theme = "Papirus-Dark";
      modi = "drun,run,filebrowser,window";
      cycle = true;
      scroll-method = 0;
      normalize-match = true;
      case-sensitive = false;

      display-drun = "Apps";
      click-to-exit = true;

      kb-mode-next = "Shift+Right,Control+Tab";
      kb-mode-previous = "Shift+Left";
    };
  };
}
