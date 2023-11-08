vim.cmd [[set guicursor=n-v:block,i-c-ci-ve:ver25,r-cr:hor20,o:hor50]]

vim.api.nvim_create_autocmd("VimLeave", { callback = function() vim.cmd [[set guicursor=a:ver25]] end })

-- Disable some built-in plugins I don't use
vim.g.loaded_gzip = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1

vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_2html_plugin = 1

vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1

local opt = vim.opt
local o = vim.o
o.number = true
o.relativenumber = true

local tabwidth = 2
o.shiftwidth = tabwidth
o.tabstop = tabwidth
o.softtabstop = tabwidth
o.expandtab = true

o.smartcase = true
o.ignorecase = true

o.smartindent = true
o.breakindent = true
o.showmode = false
o.splitright = true
o.splitbelow = true

o.swapfile = false
o.backup = false

o.undodir = os.getenv("HOME") .. "/.local/state/undodir"
o.undofile = true

o.hlsearch = false
o.incsearch = true

o.termguicolors = true

o.scrolloff = 8
o.signcolumn = "yes"
opt.isfname:append("@-@")


o.updatetime = 50
o.timeoutlen = 300
o.textwidth = 0
o.wrapmargin = 0
o.wrap = false
o.colorcolumn = ""

o.completeopt = 'menuone,noselect'


-- Highlight yanked text
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank {
      timeout = 100,
      on_visual = false,
    }
  end,
  group = highlight_group,
  pattern = '*',
})
