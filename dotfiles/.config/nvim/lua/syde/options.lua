vim.cmd [[set guicursor=n-v:block,i-c-ci-ve:ver25,r-cr:hor20,o:hor50]]

vim.api.nvim_create_autocmd("VimLeave", { callback = function() vim.cmd [[set guicursor=a:ver25]] end })

-- Disable some unused built-in plugins
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

local MiniBasics = vim.F.npcall(require, 'mini.basics')
if MiniBasics then
    MiniBasics.setup {
        -- Options. Set to `false` to disable.
        options = {
            -- Basic options ('termguicolors', 'number', 'ignorecase', and many more)
            basic = true,

            -- Extra UI features ('winblend', ...)
            extra_ui = false,

            -- Presets for window borders ('single', 'double', ...)
            win_borders = 'single',
        },

        -- Mappings. Set to `false` to disable.
        mappings = {
            -- Basic mappings (better 'jk', save with Ctrl+S, ...)
            basic = true,

            -- Prefix for mappings that toggle common options ('wrap', 'spell', ...).
            -- Supply empty string to not create these mappings.
            option_toggle_prefix = [[<leader><leader>]],

            -- Window navigation with <C-hjkl>, resize with <C-arrow>
            windows = false,

            -- Move cursor in Insert, Command, and Terminal mode with <M-hjkl>
            move_with_alt = false,
        },

        -- Autocommands. Set to `false` to disable
        autocommands = {
            -- Basic autocommands (highlight on yank, start Insert in terminal, ...)
            basic = false,

            -- Set 'relativenumber' only in linewise and blockwise Visual mode
            relnum_in_visual_mode = false,
        },

        -- Whether to disable showing non-error feedback
        silent = false,
    }
end

local opt = vim.opt
local o = vim.o
o.number = true
o.relativenumber = true
o.cursorline = false

o.timeoutlen = 300

local tabwidth = 4
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
o.writebackup = false

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
o.conceallevel = 2

o.completeopt = 'menuone,noselect'


-- o.listchars = 'tab:▸ ,trail:·,nbsp:␣,extends:❯,precedes:❮'
-- o.list = true

-- Highlight yanked text
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank {
            timeout = 200,
            on_visual = false,
        }
    end,
    group = highlight_group,
    pattern = '*',
})


local signs = { Error = '', Warn = '', Hint = '', Info = '' }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local lazy = require('syde.lazy')
lazy.setup_lazy_loading()
lazy.perform_lazy_loading()
