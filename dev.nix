{ config, pkgs, nixglPkgs, ... }:

{
  programs.tmux = {
    enable = true;
    prefix = "C-space";
    baseIndex = 1;
    keyMode = "vi";
    mouse = true;

    plugins = with pkgs.tmuxPlugins; [
      sensible
      gruvbox
      yank
    ];

    extraConfig = ''
	bind-key -T copy-mode-vi v send-keys -X begin-selection
	bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
	bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
    '';
  };

  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      gruvbox
      vim-fugitive
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

  programs.zsh = {
    enable = true;
    shellAliases = {
      ls = "eza";
      hms = "home-manager switch --flake ~/nix-config#laptop";
    };
  };
}
