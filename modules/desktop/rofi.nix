{pkgs, ...}: {
  environment.systemPackages = [pkgs.rofi];

  environment.etc."xdg/rofi/theme.rasi".source = ./rofi.rasi;
}
