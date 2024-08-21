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

Load.now(function()
    require('mini.basics').setup {
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
end)

vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = false

vim.o.timeoutlen = 300

local tabwidth = 4
vim.o.shiftwidth = tabwidth
vim.o.tabstop = tabwidth
vim.o.softtabstop = tabwidth
vim.o.expandtab = true

vim.o.smartcase = true
vim.o.ignorecase = true

vim.o.smartindent = true
vim.o.breakindent = true
vim.o.showmode = false
vim.o.splitright = true
vim.o.splitbelow = true

vim.o.swapfile = false
vim.o.backup = false
vim.o.writebackup = false

vim.o.undodir = vim.fn.stdpath('state') .. "/undodir"
vim.o.undofile = true

vim.o.hlsearch = false
vim.o.incsearch = true

vim.o.termguicolors = true

vim.o.scrolloff = 8
vim.o.signcolumn = "yes"
vim.opt.isfname:append("@-@")


vim.o.updatetime = 50
vim.o.timeoutlen = 300
vim.o.textwidth = 0
vim.o.wrapmargin = 0
vim.o.wrap = false
vim.o.colorcolumn = ""
vim.o.conceallevel = 2

vim.o.completeopt = 'menuone,noselect'


vim.o.listchars = 'tab:▸ ,trail:·,nbsp:␣,extends:❯,precedes:❮'

-- more useful diffs (nvim -d)
vim.opt.diffopt:append('iwhite')
-- and using a smarter algorithm
-- https://vimways.org/2018/the-power-of-diff/
-- https://stackoverflow.com/questions/32365271/whats-the-difference-between-git-diff-patience-and-git-diff-histogram
-- https://luppeng.wordpress.com/2020/10/10/when-to-use-each-of-the-git-diff-algorithms/
vim.opt.diffopt:append('algorithm:histogram')
vim.opt.diffopt:append('indent-heuristic')

-- vim.o.list = true

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


-- bar cursor in insert mode
-- vim.api.nvim_create_autocmd("VimLeave", { callback = function() vim.cmd [[set guicursor=a:ver25]] end })
vim.cmd [[set guicursor=n-v:block,i-c-ci-ve:ver25,r-cr:hor20,o:hor50]]
local signs = { Error = '', Warn = '', Hint = '', Info = '' }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

Load.perform_lazy_loading()
