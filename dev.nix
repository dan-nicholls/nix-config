{ config, pkgs, nixglPkgs, ... }:

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
    eza
    zoxide
    wl-clipboard

    # Ghostty wrapped with nixGL
    (pkgs.writeShellScriptBin "ghostty" ''
      exec ${nixglPkgs.nixGLIntel}/bin/nixGLIntel ${pkgs.ghostty}/bin/ghostty "$@"
    '')
  ];
}
