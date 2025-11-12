{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.zsh = {
    enable = true;
    shellAliases = {
      ls = "eza";
      hms = "home-manager switch --flake ~/nix-config#{hostRole}";
      gitcm = "git diff --staged | sgpt \"make me a very brief conventional commit message\" --code";
      glog = "git log --oneline -n 10 --color=always | cat";
      sp = "spotify_player";
      nixrgl = "nix run --impure github:nix-community/nixGL --";
    };
    antidote = {
      enable = true;
      plugins = [
        "zsh-users/zsh-autosuggestions"
        "zsh-users/zsh-syntax-highlighting"
        "Aloxaf/fzf-tab"
        "jeffreytse/zsh-vi-mode"
      ];
    };
    history = {
      size = 5000;
      save = 5000;
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      saveNoDups = true;
      share = true;
      findNoDups = true;
      extended = true;
    };
    # Ensure Ctrl R is always fzf-history
    #initExtra = "bindkey '^R' fzf-history-widget";
    initExtra = ''
      # Source Home Manager session vars
      if [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
      	source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
      fi
    '';
  };

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    settings = builtins.fromJSON (builtins.readFile ./oh-my-zsh.json);
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [
      "--cmd cd"
    ];
  };

  # Ensures shell variables are passed correctly
  targets.genericLinux.enable = true;

  # Ensures ZSH gets set to the default shell
  home.activation.make-zsh-default-shell = lib.hm.dag.entryAfter ["writeBoundary"] ''
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
