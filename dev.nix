{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
  };

  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      gruvbox
    ];
    extraConfig = ''
      set number
      colorscheme gruvbox
    '';
  };

  home.packages = with pkgs; [
    git
    curl
    tree
    tldr
  ];
}
