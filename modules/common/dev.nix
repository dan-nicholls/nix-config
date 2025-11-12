{
  config,
  pkgs,
  hostRole ? "laptop",
  self,
  ...
}: {
  imports = [
    ../apps/tmux.nix
    ../apps/nvf.nix
  ];

  home.packages = with pkgs; [
    git
    curl
    tree
    tldr
    eza
    wl-clipboard
    shell-gpt
    ripgrep
    yazi
    go
    gopls
    delve
    gotests
    gnumake
    hyperfine
    fselect
    wiki-tui
    mask
    mprocs
    gh
    fd
    bat
  ];
}
