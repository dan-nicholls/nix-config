{ config, pkgs, ... }:

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
      nvim-surround
      nvim-lspconfig
      nvim-bqf
	  leetcode-nvim
	  nvim-treesitter
	  nvim-treesitter-parsers.html

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
    extraLuaConfig = ''
            local telescope = require("telescope.builtin")
            local lspconfig = require("lspconfig")

            lspconfig.gopls.setup({})
            require("nvim-surround").setup({})

            vim.g.mapleader = " "

      	  	vim.diagnostic.config({
      	    	virtual_text = true,
      			signs = true,
      			underline = true,
      	 	})

      	  	require("blink.cmp").setup({
            	keymap = {
      				preset = "super-tab",
      		  		['<C-space>'] = {},
      		  		['<C-d>'] = {'show', 'show_documentation', 'hide_documentation', 'fallback'},
      		  		['<C-s>'] = {'show_signature', 'hide_signature', 'fallback'}
      			},
				appearance = {
					nerd_font_variant = "mono",
				},
				completion = {
					documentation = { auto_show = false },
				},
              	sources = {
                	default = { "lsp", "path", "snippets", "buffer" },
              	},
				fuzzy = {
					implementation = "prefer_rust_with_warning"
				}
           	})

			-- Leetcode Setup
		 	require("leetcode").setup({
      	   		lang = "golang",
				storage = {
					home = "~/Repos/leetcode",
				}
    	 	})

            -- Telescope Keybindings
            vim.keymap.set("n", "<leader>ff", telescope.find_files, { desc = "Find Files" })
            vim.keymap.set("n", "<leader>fb", telescope.buffers, { desc = "Find Buffers" })
            vim.keymap.set("n", "<leader>fm", telescope.marks, { desc = "Find Marks" })
            vim.keymap.set("n", "<leader>fg", telescope.live_grep, { desc = "Find Grep" })
            vim.keymap.set("n", "<leader>fc", telescope.git_commits, { desc = "Find Commit" })

            -- Fugitive Keybindings
            vim.keymap.set("n", "<leader>gs", "<cmd>Git<CR>", { desc = "Git Status" })
            vim.keymap.set("n", "<leader>gu", "<cmd>Git push<CR>", { desc = "Git Push" })
            vim.keymap.set("n", "<leader>gp", "<cmd>Git pull<CR>", { desc = "Git Pull" })
            vim.keymap.set("n", "<leader>gb", "<cmd>Git blame<CR>", { desc = "Git Blame" })
            vim.keymap.set("n", "<leader>gd", "<cmd>Git diff<CR>", { desc = "Git Diff" })

            -- Other Keybindings
            vim.keymap.set("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next Buffer" })
            vim.keymap.set("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Previous Buffer" })

			vim.keymap.set("i", "<C-h>", "<Left>", { noremap = true })
			vim.keymap.set("i", "<C-j>", "<Down>", { noremap = true })
			vim.keymap.set("i", "<C-k>", "<Up>", { noremap = true })
			vim.keymap.set("i", "<C-l>", "<Right>", { noremap = true })

            vim.keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save Buffer" })
            vim.keymap.set("n", "<C-c>", ":%y+<CR>", { desc = "Copy Buffer" })
      	  	vim.keymap.set("n", "<leader>rn", function()
      	    	if vim.wo.relativenumber then
      		  		vim.wo.relativenumber = false
      			else
      		  		vim.wo.relativenumber = true
      			end
      	  	end, { noremap = true, silent = true })
      	  	vim.keymap.set("n", "<leader>lf", function()
      	   		vim.lsp.buf.format()
      	  	end, { desc = "Format buffer" })
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
    ranger
    go
    gopls
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
      hms = "home-manager switch --flake ~/nix-config#laptop";
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
    settings = builtins.fromJSON (
      builtins.readFile ./oh-my-zsh.json
    );
  };
}
