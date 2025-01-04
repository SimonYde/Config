local M = {}

-- Toggle quickfix window
Config.toggle_quickfix = function()
    local quickfix_wins = vim.tbl_filter(
        function(win_id) return vim.fn.getwininfo(win_id)[1].quickfix == 1 end,
        vim.api.nvim_tabpage_list_wins(0)
    )

    local command = #quickfix_wins == 0 and 'copen' or 'cclose'
    vim.cmd(command)
end

---@param mode string | table single mode string or table of mode strings
M.map = function(mode)
    ---@param desc string
    ---@param keys string
    ---@param cmd function|string
    ---@param opts? table
    return function(keys, cmd, desc, opts)
        opts = opts or {}
        opts.desc = desc
        if opts.silent == nil then opts.silent = true end
        vim.keymap.set(mode, keys, cmd, opts)
    end
end

M.nmap = M.map('n')
M.imap = M.map('i')

_G.Keymap = M

local tmap = Keymap.map('t')
local nmap = Keymap.nmap
local xmap = Keymap.map('x')
local nxmap = Keymap.map({ 'n', 'x' })

vim.keymap.set({ 'n', 'v' }, 's', '<Nop>', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
nmap('U', '<C-r>', 'redo')

-- xmap("<M-k>", ":m'<-2<CR>gv=gv", "Move selection up") -- using mini.move instead
-- xmap("<M-j>", ":m'>+1<CR>gv=gv", "Move selection down")

if vim.fn.has('nvim-0.11') == 1 then
    Load.now(function()
        vim.keymap.del('n', 'gri')
        vim.keymap.del('n', 'grr')
        vim.keymap.del('n', 'gra')
        vim.keymap.del('x', 'gra')
        vim.keymap.del('n', 'grn')
    end)
end

nmap('<C-d>', '<C-d>zz', 'Move down half page')
nmap('<C-u>', '<C-u>zz', 'Move up half page')
nmap('n', 'nzz', 'Move to next search match')
nmap('N', 'Nzz', 'Move to previous search match')
nmap('*', '*zz', 'Find next occurrence under cursor')
nmap('#', '#zz', 'Find previous occurrence under cursor')

nxmap('<leader>y', [["+y]], 'yank to system clipboard')
nmap('<leader>Y', [["+Y]], 'yank end-of-line to system clipboard')

nmap('<leader>w', '<C-w>', 'Window')

xmap('<leader>p', [["_dP]], '[p]aste without yanking')
nxmap('<M-d>', [["_d]], '[d]elete without yanking')
nxmap('<M-c>', [["_c]], '[c]hange without yanking')

nmap('gF', '<cmd>:e <cfile><CR>', "Goto [F]ile (even if doesn't exist)")

nmap(
    '<leader>x',
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    'Search and replace in buffer',
    { silent = false }
)
tmap('<Esc><Esc>', [[<C-\><C-n>]], 'Exit terminal mode')

vim.lsp.inlay_hint.toggle = function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end
nmap('<leader>li', vim.lsp.inlay_hint.toggle, 'Toggle [i]nlay hints')
nmap('<leader>lf', vim.lsp.buf.format, 'LSP format')

nmap('<leader>q', Config.toggle_quickfix, 'Toggle [q]uickfix list')
nmap('<leader>h', vim.cmd('nohlsearch'), 'clear search highlight')
nmap('<leader>=', vim.lsp.buf.format, 'Format with LSP')
nmap('gd', vim.lsp.buf.definition, 'Goto [d]efinition')
nmap('gD', vim.lsp.buf.declaration, 'Goto [D]eclaration')
nmap('gr', vim.lsp.buf.references, 'Goto [r]eferences')
nmap('<leader>u', function()
    vim.cmd('UndotreeToggle')
    vim.cmd('UndotreeFocus')
end, 'Toggle [u]ndo tree')
nmap('<leader><leader>f', function()
    local flipped = not vim.opt.foldenable
    print('foldenable', flipped)
    vim.opt.foldenable = flipped
end, 'Toggle fold')

-- COLEMAK Remaps
-- NOTE: is reversed because the function below toggles the value, in order to
-- enable appropriate options.
COLEMAK = false
Colemak_toggle = function()
    if not COLEMAK then
        nxmap('n', [[v:count == 0 ? 'gj' : 'j']], '', { expr = true, noremap = true })
        nxmap('e', [[v:count == 0 ? 'gk' : 'k']], '', { expr = true, noremap = true })
        nxmap('m', 'h', '', { noremap = true })
        nxmap('i', 'l', '', { noremap = true })
        -- nxmap('I', 'L', '', { noremap = true })
        nxmap('h', 'm', '', { noremap = true })
        nxmap('j', 'e', '', { noremap = true })
        nxmap('k', 'nzz', '', { noremap = true })
        nxmap('l', 'i', '', { noremap = true })
        -- nxmap('M', 'H', '', { noremap = true })
        nxmap('N', 'mzJ`z', 'Join following line with current (preserve cursor position)', { noremap = true })
        nxmap('E', 'K', '', { noremap = true })
        nxmap('H', 'M', '', { noremap = true })
        nxmap('J', 'E', '', { noremap = true })
        nxmap('K', 'Nzz', '', { noremap = true })
        nxmap('L', 'I', '', { noremap = true })
        nxmap('<C-w>m', '<C-w>h', '', { noremap = true })
        nxmap('<C-w>n', '<C-w>j', '', { noremap = true })
        nxmap('<C-w>e', '<C-w>k', '', { noremap = true })
        nxmap('<C-w>i', '<C-w>l', '', { noremap = true })
        nxmap('<C-w>M', '<C-w>H', '', { noremap = true })
        nxmap('<C-w>N', '<C-w>J', '', { noremap = true })
        nxmap('<C-w>E', '<C-w>K', '', { noremap = true })
        nxmap('<C-w>I', '<C-w>L', '', { noremap = true })

        nxmap('M', '^', 'Goto first non-empty cell in line')
        nxmap('S', '0', 'Goto line start')
        nxmap('I', '$', 'Goto line end')
        COLEMAK = true
    else
        nxmap('j', [[v:count == 0 ? 'gj' : 'j']], '', { expr = true, noremap = true })
        nxmap('k', [[v:count == 0 ? 'gk' : 'k']], '', { expr = true, noremap = true })
        nxmap('h', 'h', '', { noremap = true })
        nxmap('l', 'l', '', { noremap = true })
        nxmap('L', 'L', '', { noremap = true })
        nxmap('m', 'm', '', { noremap = true })
        nxmap('e', 'e', '', { noremap = true })
        nxmap('n', 'nzz', '', { noremap = true })
        nxmap('i', 'i', '', { noremap = true })
        nxmap('H', 'H', '', { noremap = true })
        nxmap('J', 'mzJ`z', 'Join following line with current (preserve cursor position)', { noremap = true })
        nxmap('K', 'K', '', { noremap = true })
        nxmap('M', 'M', '', { noremap = true })
        nxmap('E', 'E', '', { noremap = true })
        nxmap('N', 'Nzz', '', { noremap = true })
        nxmap('I', 'I', '', { noremap = true })

        nxmap('H', '^', 'Goto first non-empty cell in line')
        nxmap('S', '0', 'Goto line start')
        nxmap('L', '$', 'Goto line end')
        COLEMAK = false
    end
end
Colemak_toggle()

nmap('<leader><leader>k', function()
    Colemak_toggle()
    print('COLEMAK', COLEMAK)
end, 'Toggle keymap')
