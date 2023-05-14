
-- vim.o.background = "dark"

require("monokai-pro").setup({
  transparent_background = false,
  terminal_colors = true,
  devicons = true, -- highlight the icons of `nvim-web-devicons`
  styles = {
    comment = { italic = true },
    keyword = { italic = true }, -- any other keyword
    type = { italic = true }, -- (preferred) int, long, char, etc
    storageclass = { italic = true }, -- static, register, volatile, etc
    structure = { italic = true }, -- struct, union, enum, etc
    parameter = { italic = true }, -- parameter pass in function
    annotation = { italic = true },
    tag_attribute = { italic = true }, -- attribute of tag in reactjs
  },
  filter = "spectrum", -- classic | octagon | pro | machine | ristretto | spectrum
  -- Enable this will disable filter option
  inc_search = "background", -- underline | background
  background_clear = {
    -- "float_win",
    "toggleterm",
    "telescope",
    "which-key",
    "renamer",
    "neo-tree"
  },-- "float_win", "toggleterm", "telescope", "which-key", "renamer", "neo-tree"
  plugins = {
    bufferline = {
      underline_selected = false,
      underline_visible = false,
    },
    indent_blankline = {
      context_highlight = "default", -- default | pro
      context_start_underline = false,
    },
  },
  ---@param c Colorscheme
  override = function(c) end,
})
vim.cmd([[colorscheme monokai-pro]])
vim.cmd([[set guicursor=n-v:block,i-c-ci-ve:ver25,r-cr:hor20,o:hor50,n-v:blinkwait700-blinkoff400-blinkon250]])
--        \,a:blinkwait700-blinkoff400-blink250-Cursor/lCursor
--        \,sm:block-blinkwait175-blinkoff150-blinkon175]])
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

opt.undodir = os.getenv("HOME") .. "/.config/nvim/undodir"
opt.undofile = true

opt.hlsearch = false
opt.incsearch = true

opt.termguicolors = true

opt.scrolloff = 8
opt.signcolumn = "yes"
opt.isfname:append("@-@")


opt.updatetime = 50
opt.colorcolumn = "80"











