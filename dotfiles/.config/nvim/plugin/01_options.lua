-- General ====================================================================
vim.g.mapleader = ' '
vim.o.mousescroll = 'ver:5,hor:6'
vim.o.swapfile = false
vim.o.shada = "'100,<50,s10,:1000,/100,@100,h" -- Limit what is stored in ShaDa file
vim.o.undofile = true

-- UI =========================================================================
Load.now(function() require('vim._core.ui2').enable({ enable = true, msg = { target = 'msg' } }) end) -- enable the experimental TUI for cmdline
vim.o.number = true
vim.o.relativenumber = true
vim.o.cmdheight = 0
vim.o.wrap = false
vim.o.signcolumn = 'yes'
vim.o.ruler = false
vim.o.cursorline = false
vim.o.laststatus = 3 -- global statusline
vim.o.hlsearch = true
vim.o.pummaxwidth = 100 -- Limit maximum width of popup menu
vim.o.pumblend = 0
vim.o.winblend = 0
vim.o.shortmess = 'CFOSWaco'
vim.o.breakindentopt = 'list:-1' -- Add padding for lists when 'wrap' is on

vim.o.list = true
vim.o.listchars = 'tab:▸ ,nbsp:␣,extends:❯,precedes:❮'

vim.o.guicursor = 'n-v:block,i-c-ci-ve:ver25,r-cr:hor20,o:hor50' -- Change cursor shape in certain modes

vim.o.conceallevel = 2

vim.o.foldtext = '' -- Use underlying text with its highlighting
vim.o.foldlevel = 100 -- Fold everything except top-most folds
vim.o.foldlevelstart = 100

-- Editing ====================================================================
vim.o.shiftwidth = 4
vim.o.tabstop = vim.o.shiftwidth
vim.o.softtabstop = vim.o.shiftwidth
vim.o.expandtab = true

vim.o.formatoptions = 'rqnl1j' -- Improve comment editing
vim.o.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]] -- `gw` wrapping (don't think about it)

vim.o.inccommand = 'split'

vim.o.iskeyword = '@,48-57,_,192-255,-' -- Treat dash separated words as a word text object

vim.o.updatetime = 50
vim.o.timeoutlen = 300

vim.o.completeopt = 'menuone,noselect,fuzzy'

vim.o.wildignore = '.hg,.svn,*~,*.png,*.jpg,*.gif,*.min.js,*.swp,*.o,vendor,dist,_site'

-- more useful diffs (nvim -d) and using a smarter algorithm
-- https://vimways.org/2018/the-power-of-diff/
-- https://stackoverflow.com/questions/32365271/whats-the-difference-between-git-diff-patience-and-git-diff-histogram
-- https://luppeng.wordpress.com/2020/10/10/when-to-use-each-of-the-git-diff-algorithms/
vim.o.diffopt = 'internal,filler,closeoff,linematch:40,iwhite,algorithm:histogram,indent-heuristic'

-- Spelling ===================================================================
vim.o.spelllang = 'en,da'
vim.o.spelloptions = 'camel' -- Treat parts of camelCase words as separate words
vim.o.complete = '.,w,b,u,kspell' -- Add spellcheck options for autocomplete and don't use tags for completion

-- Shell ======================================================================

vim.o.shell = 'nu'

-- WARN: disable the usage of temp files for shell commands
-- because Nu doesn't support `input redirection` which Neovim uses to send buffer content to a command:
--      `{shell_command} < {temp_file_with_selected_buffer_content}`
-- When set to `false` the stdin pipe will be used instead.
-- NOTE: some info about `shelltemp`: https://github.com/neovim/neovim/issues/1008
vim.o.shelltemp = false

-- string to be used to put the output of shell commands in a temp file
-- 1. when 'shelltemp' is `true`
-- 2. in the `diff-mode` (`nvim -d file1 file2`) when `diffopt` is set
--    to use an external diff command: `set diffopt-=internal`
vim.o.shellredir = 'out+err> %s'

-- flags for nu:
-- * `--stdin`       redirect all input to -c
-- * `--no-newline`  do not append `\n` to stdout
-- * `--commands -c` execute a command
vim.o.shellcmdflag = '--stdin --no-newline -c'

-- disable all escaping and quoting
vim.o.shellxescape = ''
vim.o.shellxquote = ''
vim.o.shellquote = ''

-- string to be used with `:make` command to:
-- 1. save the stderr of `makeprg` in the temp file which Neovim reads using `errorformat` to populate the `quickfix` buffer
-- 2. show the stdout, stderr and the return_code on the screen
-- NOTE: `ansi strip` removes all ansi coloring from nushell errors
vim.o.shellpipe = '| complete | update stderr { ansi strip } | tee { get stderr | save --force --raw %s } | into record'

-- Don't auto-wrap comments and don't insert comment leader after hitting 'o'
-- If not done on `FileType`, this keeps reappearing due to being set in
-- filetype plugins.
Config.create_autocmd(
    'FileType',
    nil,
    function() vim.cmd('setlocal formatoptions-=c formatoptions-=o') end,
    [[Ensure proper 'formatoptions']]
)

-- Diagnostics ================================================================

Load.later(function()
    -- `mini.basics` handles most options.
    require('mini.basics').setup({
        options = { extra_ui = true },
        mappings = { option_toggle_prefix = '\\' },
    })
end)

Load.later(function()
    local sev = vim.diagnostic.severity
    vim.diagnostic.config({
        signs = {
            priority = 9999,
            text = {
                [sev.ERROR] = '',
                [sev.WARN] = '',
                [sev.HINT] = '',
                [sev.INFO] = '',
            },
        },
        -- virtual_lines = { current_line = true },
        virtual_text = {
            current_line = false,
            severity = { min = sev.ERROR, max = sev.ERROR },
        },
        float = { border = 'rounded' },
        update_in_insert = false,
    })
end)
