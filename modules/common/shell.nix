{ config, pkgs, lib, ... }: {

  # Ensures shell variables are passed correctly
  targets.genericLinux.enable = true;

  # Ensures ZSH gets set to the default shell
  home.activation.make-zsh-default-shell = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    PATH="/usr/bin:/bin:$PATH"
    ZSH_PATH="${config.home.homeDirectory}/.nix-profile/bin/zsh"
    if [[ $(getent passwd ${config.home.username}) != *"$ZSH_PATH" ]]; then
      echo "setting zsh as default shell (using chsh). password might be necessary."
      if ! grep -q "$ZSH_PATH" /etc/shells; then
        echo "adding zsh to /etc/shells"
        run echo "$ZSH_PATH" | sudo tee -a /etc/shells
      fi
      run chsh -s $ZSH_PATH ${config.home.username}
      echo "zsh is now set as default shell!"
    fi
  '';
}
