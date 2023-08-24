require("catppuccin").setup({
  flavour = "mocha",   -- latte, frappe, macchiato, mocha
  integrations = {
    indent_blankline = {
      enabled = true,
      colored_indent_levels = false,
    },
    cmp = true,
    gitsigns = true,
    nvimtree = true,
    treesitter = true,
    treesitter_context = true,
    -- fidget = true, -- is ugly
    harpoon = true,
    lsp_saga = true,
    telescope = {
      enabled = true,
      -- style = "nvchad",
    },
    which_key = true,
  },
})
vim.cmd.colorscheme "catppuccin"

vim.cmd([[set guicursor=n-v:block,i-c-ci-ve:ver25,r-cr:hor20,o:hor50]])

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local opt = vim.opt
opt.nu = true
opt.relativenumber = true

opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartcase = true
opt.ignorecase = true

opt.smartindent = true
opt.showmode = false
opt.laststatus = 2
-- opt.laststatus = 3 -- global statusline


opt.swapfile = false
opt.backup = false

opt.undodir = os.getenv("HOME") .. "/.undodir"
opt.undofile = true

opt.hlsearch = false
opt.incsearch = true

opt.termguicolors = true

opt.scrolloff = 8
opt.signcolumn = "yes"
opt.isfname:append("@-@")


opt.updatetime = 50
opt.textwidth = 0
opt.wrapmargin = 0
opt.wrap = false
opt.colorcolumn = ""
