{ config, pkgs, nixglPkgs, ... }:

{
  programs.tmux = {
    enable = true;
    prefix = "C-space";
    baseIndex = 1;
    keyMode = "vi";
    mouse = true;
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
    eza
    zoxide
    wl-clipboard
  ];


  nixGL.packages = nixglPkgs;
  #nixGL.defaultWrapper = "mesa";

  programs.ghostty = {
    enable = true;
    package = (config.lib.nixGL.wrap pkgs.ghostty);
    settings = {
      theme = "GruvboxDark";
    };
  };
}
