{ config, pkgs, nixglPkgs, ... }:

{
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
    ];
    extraConfig = ''
      set number
      colorscheme gruvbox
    '';
    extraLuaConfig = ''
      vim.g.mapleader = " "
      local telescope = require("telescope.builtin")

      -- Telescope Keybindings
      vim.keymap.set("n", "<leader>ff", telescope.find_files, { desc = "Find Files" })
      vim.keymap.set("n", "<leader>fb", telescope.buffers, { desc = "Find Buffers" })
      vim.keymap.set("n", "<leader>fm", telescope.marks, { desc = "Find Marks" })
      vim.keymap.set("n", "<leader>fg", telescope.live_grep, { desc = "Find Grep" })
      vim.keymap.set("n", "<leader>fc", telescope.git_commits, { desc = "Find Commit" })

      -- Fugitive Keybindings
      vim.keymap.set("n", "<leader>gs", "<cmd>Git<CR>", { desc = "Git Status" })
      vim.keymap.set("n", "<leader>gp", "<cmd>Git push<CR>", { desc = "Git Push" })
      vim.keymap.set("n", "<leader>gu", "<cmd>Git pull<CR>", { desc = "Git Pull" })
      vim.keymap.set("n", "<leader>gb", "<cmd>Git blame<CR>", { desc = "Git Blame" })
      vim.keymap.set("n", "<leader>gd", "<cmd>Git diff<CR>", { desc = "Git Diff" })
    '';
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
      gitcm = "git diff --staged | sgpt \"make me a very brief conventional commit message\" --code";
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
  };

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    settings = builtins.fromJSON(
      builtins.readFile ./oh-my-zsh.json
    ); 
  };
}
