-- Disable unused built-in plugins ============================================
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

-- Leader key =================================================================
vim.g.maplocalleader = ' '
vim.g.mapleader = ' '

-- General ====================================================================
vim.o.backup = false
vim.o.writebackup = false
vim.o.mouse = 'a'
vim.o.mousescroll = 'ver:6,hor:6'
vim.o.switchbuf = 'usetab'
vim.o.undofile = true
vim.o.swapfile = false

vim.o.shada = "'100,<50,s10,:1000,/100,@100,h" -- Limit what is stored in ShaDa file

vim.cmd('filetype plugin indent on')

-- UI =========================================================================
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = false
vim.o.colorcolumn = ''
vim.o.laststatus = 3 -- global statusline
vim.o.linebreak = true
vim.o.cmdheight = 0
vim.o.hlsearch = true
vim.o.list = true
vim.o.pumblend = 0
vim.o.winblend = 0
vim.o.pumheight = 10 -- slightly smaller built-in menus
vim.o.ruler = false
vim.o.shortmess = 'aoOWFcSC'
vim.o.showmode = false
vim.o.signcolumn = 'yes'
vim.o.scrolloff = 8
vim.o.termguicolors = true
vim.o.breakindent = true
vim.o.breakindentopt = 'list:-1' -- Add padding for lists when 'wrap' is on

vim.o.fillchars = 'eob: ' -- Don't show `~` outside of buffer
vim.o.listchars = 'tab:▸ ,nbsp:␣,extends:❯,precedes:❮'
vim.o.guicursor = 'n-v:block,i-c-ci-ve:ver25,r-cr:hor20,o:hor50'

vim.o.splitkeep = 'screen' -- Reduce scoll during window split
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.incsearch = true

vim.o.wrap = false
vim.o.wrapmargin = 0
vim.o.textwidth = 0
vim.o.conceallevel = 2

-- Colors =====================================================================
-- Enable syntax highlighing if it wasn't already (as it is time consuming)
if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end

-- Editing ====================================================================
local tabwidth = 4
vim.o.shiftwidth = tabwidth
vim.o.tabstop = tabwidth
vim.o.softtabstop = tabwidth
vim.o.expandtab = true

vim.o.formatoptions = 'rqnl1j' -- Improve comment editing
vim.o.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]] -- `gw` wrapping (don't think about it)

vim.o.ignorecase = true
vim.o.infercase = true
vim.o.smartcase = true

vim.o.smartindent = true
vim.o.autoindent = true

vim.o.inccommand = 'split'
vim.o.virtualedit = 'block'

vim.opt.isfname:append('@-@')

vim.opt.iskeyword:append('-') -- Treat dash separated words as a word text object

vim.o.updatetime = 50
vim.o.timeoutlen = 300

vim.opt.completeopt = 'menuone,noselect'

-- vim.opt.wildmode = 'list:longest'
-- when opening a file with a command (like :e),
-- don't suggest files like there:
-- vim.opt.wildignore = '.hg,.svn,*~,*.png,*.jpg,*.gif,*.min.js,*.swp,*.o,vendor,dist,_site'

if vim.fn.has('nvim-0.11') then vim.opt.completeopt:append('fuzzy') end

-- more useful diffs (nvim -d)
vim.opt.diffopt:append('iwhite')
-- and using a smarter algorithm
-- https://vimways.org/2018/the-power-of-diff/
-- https://stackoverflow.com/questions/32365271/whats-the-difference-between-git-diff-patience-and-git-diff-histogram
-- https://luppeng.wordpress.com/2020/10/10/when-to-use-each-of-the-git-diff-algorithms/
vim.opt.diffopt:append('algorithm:histogram')
vim.opt.diffopt:append('indent-heuristic')

-- Spelling ===================================================================
vim.o.spelllang = 'en,da'
vim.o.spelloptions = 'camel' -- Treat parts of camelCase words as seprate words
vim.opt.complete:append('kspell') -- Add spellcheck options for autocomplete
vim.opt.complete:remove('t') -- Don't use tags for completion

-- Custom autocommands ========================================================
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        -- Highlight yanked text
        vim.highlight.on_yank({
            timeout = 200,
            on_visual = false,
        })
    end,
    group = highlight_group,
    pattern = '*',
})

local augroup = vim.api.nvim_create_augroup('CustomSettings', {})
vim.api.nvim_create_autocmd('FileType', {
    group = augroup,
    callback = function()
        -- Don't auto-wrap comments and don't insert comment leader after hitting 'o'
        -- If don't do this on `FileType`, this keeps reappearing due to being set in
        -- filetype plugins.
        vim.cmd('setlocal formatoptions-=c formatoptions-=o')
    end,
    desc = [[Ensure proper 'formatoptions']],
})

-- Diagnostics ================================================================
vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '',
            [vim.diagnostic.severity.WARN] = '',
            [vim.diagnostic.severity.HINT] = '',
            [vim.diagnostic.severity.INFO] = '',
        },
    },
})

if vim.env.SSH_CONNECTION then
    local function vim_paste()
        local content = vim.fn.getreg('"')
        return vim.split(content, '\n')
    end

    vim.g.clipboard = {
        name = 'OSC 52',
        copy = {
            ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
            ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
        },
        paste = {
            ['+'] = vim_paste,
            ['*'] = vim_paste,
        },
    }
end

vim.filetype.add({
    extension = {
        mll = 'ocamllex',
        mly = 'menhir',
        ll = 'llvm',
        tex = 'tex',
        rasi = 'css',
        conf = function(path, _)
            -- For hyprland config files
            if path:find('hypr') then return 'hyprlang' end
            return 'conf'
        end,
    },
    filename = {
        ['flake.lock'] = 'json',
    },
})
