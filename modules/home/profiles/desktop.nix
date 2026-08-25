{pkgs, ...}: {
  imports = [
    ../apps
    ../apps/ghostty.nix
    ../apps/zen.nix
  ];
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.terminess-ttf
    lan-mouse
  ];
}
