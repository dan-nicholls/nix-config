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
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "28";
    HYPRCURSOR_THEME = "Bibata-Modern-Classic";
    HYPRCURSOR_SIZE = "28";
  };

  home.sessionPath = [
    "$HOME/.nix-profile/bin"
    "$HOME/go/bin"
  ];

  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = false;
  };

  home.packages = with pkgs; [
    (writeShellScriptBin "check-swaylock" ''
      #!/usr/bin/env bash
      set -euo pipefail

      if command -v /usr/bin/swaylock >/dev/null 2>&1; then
        echo "swaylock is already installed at /usr/bin/swaylock"
        exit 0
      fi

      if command -v dpkg >/dev/null 2>&1 && dpkg -s swaylock >/dev/null 2>&1; then
        echo "swaylock is already installed (dpkg reports installed)"
        exit 0
      fi

      printf "swaylock is not installed. Install with apt now? [y/N]: "
      read -r reply
      case "''${reply}" in
        y|Y)
          if ! command -v sudo >/dev/null 2>&1; then
            echo "sudo not found; cannot install swaylock"
            exit 1
          fi
          sudo apt update
          sudo apt install -y swaylock
          ;;
        *)
          echo "Skipped install"
          ;;
      esac
    '')
  ];

  home.activation.warnMissingSwaylock = config.lib.dag.entryAfter ["writeBoundary"] ''
    if [ ! -x /usr/bin/swaylock ]; then
      echo "warning: swaylock is not installed; run check-swaylock to install"
    fi
  '';

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
