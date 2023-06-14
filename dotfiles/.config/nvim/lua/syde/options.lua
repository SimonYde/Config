vim.cmd.colorscheme "catppuccin-mocha"
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

opt.smartindent = true

opt.wrap = true

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
opt.colorcolumn = "80"











