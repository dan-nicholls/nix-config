{
  config,
  pkgs,
  hostRole ? "laptop",
  self,
  ...
}: {
  programs.tmux = {
    enable = true;
    prefix = "C-space";
    baseIndex = 1;
    keyMode = "vi";
    mouse = true;
    escapeTime = 0;

    plugins = with pkgs.tmuxPlugins; [
      sensible
      gruvbox
      yank
      vim-tmux-navigator
      {
        plugin = resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        plugin = continuum;
        extraConfig = ''
                set -g @continuum-restore 'on'
                set -g @continuum-save-interval '30' # minutes
          set -g renumber-windows on
        '';
      }
    ];

    extraConfig = ''
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
    '';
  };

  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      gruvbox
      vim-fugitive
      vim-tmux-navigator
      telescope-nvim
      plenary-nvim
      nvim-surround
      nvim-lspconfig
      nvim-bqf
      leetcode-nvim
      nvim-treesitter
      nvim-treesitter-parsers.html
      nvim-treesitter-parsers.go
      nvim-treesitter-parsers.gotmpl
      octo-nvim
      blink-cmp
    ];
    extraConfig = ''
      colorscheme gruvbox
      set number
      set tabstop=4
      set shiftwidth=4
      set relativenumber
      set splitbelow
    '';
    extraLuaConfig = builtins.readFile ./nvim-extra.lua;
  };

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

  programs.zsh = {
    enable = true;
    shellAliases = {
      ls = "eza";
      hms = "home-manager switch --flake ~/nix-config#{hostRole}";
      gitcm = "git diff --staged | sgpt \"make me a very brief conventional commit message\" --code";
      glog = "git log --oneline -n 10 --color=always | cat";
      sp = "spotify_player";
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
}
