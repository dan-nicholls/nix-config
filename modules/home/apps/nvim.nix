{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      catppuccin-nvim
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
      nvim-dap
      nvim-dap-go
      nvim-dap-ui
      nvim-nio
    ];
    extraConfig = ''
      colorscheme catppuccin
      set number
      set tabstop=4
      set shiftwidth=4
      set relativenumber
      set splitbelow
    '';
    extraLuaConfig = builtins.readFile ./nvim-extra.lua;
  };
}
