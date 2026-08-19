{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.devTools = {
    config,
    pkgs,
    ...
  }: {
    imports = [
      self.nixosModules.tmux
      self.nixosModules.nvim
      ./shell.nix
    ];

    #home.packages = with pkgs; [
    environment.systemPackages = with pkgs; [
      git
      curl
      tree
      tldr
      eza
      wl-clipboard
      #shell-gpt
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
      httpie
    ];
  };
}
