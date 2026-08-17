{
  config,
  pkgs,
  lib,
  #nvfHomeModule,
  ...
}: {
#  imports = [
#    nvfHomeModule
#  ];

  programs.nvf = {
    enable = true;

    settings = {
      vim = {
        options = {
          scrolloff = 4;
          shiftwidth = 4;
          tabstop = 4;
        };

        theme = {
          enable = true;
          name = "catppuccin";
          style = "mocha";
          transparent = true;
        };

        autopairs.nvim-autopairs.enable = true;

        statusline = {
          lualine = {
            enable = true;
            theme = "catppuccin";
          };
        };

        telescope.enable = true;
        treesitter.context.enable = true;

        lsp = {
          enable = true;
          lspSignature.enable = false;
          formatOnSave = true;
          trouble.enable = true;
        };

        debugger = {
          nvim-dap = {
            enable = true;
            ui.enable = true;
          };
        };

        languages = {
          enableFormat = true;
          enableTreesitter = true;
          enableExtraDiagnostics = true;

          nix.enable = true;
          markdown.enable = true;

          # Enable languages here
          bash.enable = true;
          python.enable = true;
          go.enable = true;
          html.enable = true;
          css.enable = true;
          lua.enable = true;
        };

        autocomplete = {
          nvim-cmp.enable = false;
          blink-cmp.enable = true;
        };

        git = {
          enable = true;
        };

        binds = {
          whichKey.enable = true;
          cheatsheet.enable = true;
        };

        comments = {
          comment-nvim.enable = true;
        };

        notify = {
          nvim-notify.enable = true;
        };

        visuals = {
          nvim-web-devicons.enable = true;
          cinnamon-nvim.enable = true;
          cellular-automaton.enable = true;
        };

        utility = {
          ccc.enable = true;
          surround = {
            enable = true;
            useVendoredKeybindings = false;
          };
          smart-splits.enable = true;
          icon-picker.enable = true;
#          leetcode-nvim = {
#            enable = true;
#            setupOpts = {
#              lang = "golang";
#              storage = {
#                home = lib.generators.mkLuaInline ''
#                  "${config.home.homeDirectory}/Repos/leetcode"
#                '';
#              };
#            };
#          };
        };

        ui = {
          borders.enable = true;
        };

        keymaps = [
          # Fugitive Keybinds
          {
            desc = "Git Status";
            key = "<leader>gs";
            mode = "n";
            silent = true;
            action = "<cmd>Git<CR>";
          }
          {
            desc = "Git Push";
            key = "<leader>gu";
            mode = "n";
            silent = true;
            action = "<cmd>Git push<CR>";
          }
          {
            desc = "Git Pull";
            key = "<leader>gp";
            mode = "n";
            silent = true;
            action = "<cmd>Git pull<CR>";
          }
          {
            desc = "Git Blame";
            key = "<leader>gb";
            mode = "n";
            silent = true;
            action = "<cmd>Git blame<CR>";
          }
          {
            desc = "Git diff";
            key = "<leader>gd";
            mode = "n";
            silent = true;
            action = "<cmd>Git diff<CR>";
          }

          # Leetcode Keybinds
          {
            desc = "Leet Test";
            key = "<leader>lt";
            mode = "n";
            silent = true;
            action = "<cmd>Leet test<CR>";
          }
          {
            desc = "Leet Submit";
            key = "<leader>ls";
            mode = "n";
            silent = true;
            action = "<cmd>Leet submit<CR>";
          }
          {
            desc = "Leet List";
            key = "<leader>ll";
            mode = "n";
            silent = true;
            action = "<cmd>Leet list<CR>";
          }

          # Other
          {
            desc = "Move Left";
            key = "<C-h>";
            mode = "i";
            silent = true;
            action = "<Left>";
          }
          {
            desc = "Move Down";
            key = "<C-j>";
            mode = "i";
            silent = true;
            action = "<Down>";
          }
          {
            desc = "Move Up";
            key = "<C-k>";
            mode = "i";
            silent = true;
            action = "<Up>";
          }
          {
            desc = "Move Right";
            key = "<C-l>";
            mode = "i";
            silent = true;
            action = "<Right>";
          }
          {
            desc = "Save Buffer";
            key = "<C-s>";
            mode = "n";
            silent = true;
            action = ":w<CR>";
          }
          {
            desc = "Copy Buffer";
            key = "<C-c>";
            mode = "n";
            silent = true;
            action = ":%y+<CR>";
          }
          {
            desc = "Next Buffer";
            key = "<Tab>";
            mode = "n";
            silent = true;
            action = "<cmd>next<CR>";
          }
          {
            desc = "Previous Buffer";
            key = "<S-Tab>";
            mode = "n";
            silent = true;
            action = "<cmd>bprevious<CR>";
          }
          {
            desc = "Open Explore";
            key = "<C-e>";
            mode = "n";
            silent = true;
            action = "<cmd>Explore<CR>";
          }
        ];
      };
    };
  };
}
