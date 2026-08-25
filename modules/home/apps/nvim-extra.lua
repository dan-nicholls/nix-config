local telescope = require("telescope.builtin")
local lspconfig = require("lspconfig")
local util = require("lspconfig.util")
local configs = require("lspconfig.configs")

lspconfig.gopls.setup({})
require("nvim-surround").setup({})
require("octo").setup({})

-- Debugger
require("dapui").setup()
require("dap-go").setup()

vim.g.mapleader = " "

-- Theme
require("catppuccin").setup({
  flavour = "mocha",
  transparent_background = true,
  integrations = {
    treesitter = true,
    telescope = true,
    cmp = true,
  },
})
vim.cmd.colorscheme "catppuccin"

-- LSP
vim.diagnostic.config({virtual_text = true, signs = true, underline = true})

require("blink.cmp").setup({
    keymap = {
        preset = "super-tab",
        ['<C-space>'] = {},
        ['<C-d>'] = {
            'show', 'show_documentation', 'hide_documentation', 'fallback'
        },
        ['<C-s>'] = {'show_signature', 'hide_signature', 'fallback'}
    },
    appearance = {nerd_font_variant = "mono"},
    completion = {documentation = {auto_show = false}},
    sources = {default = {"lsp", "path", "snippets", "buffer"}},
    fuzzy = {implementation = "prefer_rust_with_warning"}
})

-- Templ LSP
vim.filetype.add({ extension = { templ = "templ" } })

if not configs.templ then
  configs.templ = {
    default_config = {
      cmd = { "templ", "lsp" },
      filetypes = { "templ" },
      root_dir = function(fname)
        return util.root_pattern("go.mod", ".git")(fname) or util.path.dirname(fname)
      end,
      single_file_support = true,
    },
  }
end

lspconfig.templ.setup({})

require("nvim-treesitter.configs").setup {
	highlight = {
		enable = true,
		additional_vim_regrex_highlighting = false,
	}
}

-- Leetcode Setup
require("leetcode").setup({
    lang = "golang",
    storage = {home = "~/Repos/leetcode"}
})


-- Telescope Keybindings
vim.keymap.set("n", "<leader>ff", telescope.find_files, {desc = "Find Files"})
vim.keymap.set("n", "<leader>fb", telescope.buffers, {desc = "Find Buffers"})
vim.keymap.set("n", "<leader>fm", telescope.marks, {desc = "Find Marks"})
vim.keymap.set("n", "<leader>fg", telescope.live_grep, {desc = "Find Grep"})
vim.keymap.set("n", "<leader>fc", telescope.git_commits, {desc = "Find Commit"})

-- Fugitive Keybindings
vim.keymap.set("n", "<leader>gs", "<cmd>Git<CR>", {desc = "Git Status"})
vim.keymap.set("n", "<leader>gu", "<cmd>Git push<CR>", {desc = "Git Push"})
vim.keymap.set("n", "<leader>gp", "<cmd>Git pull<CR>", {desc = "Git Pull"})
vim.keymap.set("n", "<leader>gb", "<cmd>Git blame<CR>", {desc = "Git Blame"})
vim.keymap.set("n", "<leader>gd", "<cmd>Git diff<CR>", {desc = "Git Diff"})

-- Leetcode Keybindings
vim.keymap.set("n", "<leader>lt", "<cmd>Leet test<CR>", {desc = "Leet Test"})
vim.keymap.set("n", "<leader>ls", "<cmd>Leet submit<CR>", {desc = "Leet Submit"})
vim.keymap.set("n", "<leader>ll", "<cmd>Leet list<CR>", {desc = "Leet List"})

-- Other Keybindings
vim.keymap.set("n", "<Tab>", "<cmd>bnext<CR>", {desc = "Next Buffer"})
vim.keymap.set("n", "<S-Tab>", "<cmd>bprevious<CR>", {desc = "Previous Buffer"})
vim.keymap.set("n", "<leader>dd", function()
	vim.diagnostic.open_float()
end, {desc = "Show Diagnostic"})

vim.keymap.set("i", "<C-h>", "<Left>", {noremap = true})
vim.keymap.set("i", "<C-j>", "<Down>", {noremap = true})
vim.keymap.set("i", "<C-k>", "<Up>", {noremap = true})
vim.keymap.set("i", "<C-l>", "<Right>", {noremap = true})

vim.keymap.set("n", "<C-s>", ":w<CR>", {desc = "Save Buffer"})
vim.keymap.set("n", "<C-c>", ":%y+<CR>", {desc = "Copy Buffer"})
vim.keymap.set("n", "<leader>rn", function()
    if vim.wo.relativenumber then
        vim.wo.relativenumber = false
    else
        vim.wo.relativenumber = true
    end
end, {noremap = true, silent = true})
vim.keymap.set("n", "<leader>lf", function() vim.lsp.buf.format() end,
               {desc = "Format buffer"})
