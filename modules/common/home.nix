{
  config,
  pkgs,
  ...
}: {
  home.username = "dannicholls";
  home.homeDirectory = "/home/dannicholls";

  # Pin HM release
  home.stateVersion = "24.11";

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    GOPATH = "$HOME/go";
  };

  home.sessionPath = [
    "$HOME/.nix-profile/bin"
    "$HOME/go/bin"
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
