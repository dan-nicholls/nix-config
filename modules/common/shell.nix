{pkgs, ...}: {
  users.users.dannicholls.shell = pkgs.zsh;

  environment.systemPackages = with pkgs; [
    eza
    fzf
    oh-my-posh
    zoxide
    zsh-fzf-tab
    zsh-vi-mode
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    shellAliases = {
      ls = "eza";
      nrs = "sudo nixos-rebuild switch --flake ~/Repos/nix-config#x1-carbon";
      gitcm = "git diff --staged | sgpt \"make me a very brief conventional commit message\" --code";
      glog = "git log --oneline -n 10 --color=always | cat";
      sp = "spotify_player";
      nixrgl = "nix run --impure github:nix-community/nixGL --";
    };

    histSize = 5000;
    histFile = "$HOME/.zsh_history";
    setOptions = [
      "HIST_IGNORE_DUPS"
      "HIST_IGNORE_SPACE"
      "HIST_EXPIRE_DUPS_FIRST"
      "HIST_SAVE_NO_DUPS"
      "HIST_FIND_NO_DUPS"
      "SHARE_HISTORY"
      "EXTENDED_HISTORY"
    ];

    interactiveShellInit = ''
      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
      source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
      source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      source ${pkgs.fzf}/share/fzf/completion.zsh
      eval "$(${pkgs.zoxide}/bin/zoxide init zsh --cmd cd)"
      eval "$(${pkgs.oh-my-posh}/bin/oh-my-posh init zsh --config ${./oh-my-zsh.json})"
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    '';

    promptInit = "";
  };
}
