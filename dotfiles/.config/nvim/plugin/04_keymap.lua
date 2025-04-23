local M = {}

---@param mode string | table single mode string or table of mode strings
M.map = function(mode)
    ---@param keys string
    ---@param cmd function|string
    ---@param desc string
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
M.vmap = M.map('v')
M.xmap = M.map('x')
M.tmap = M.map('t')
M.nxmap = M.map({ 'n', 'x' })

-- Export module
_G.Keymap = M

Load.later(function()
    local nmap, tmap, nxmap = Keymap.nmap, Keymap.tmap, Keymap.nxmap

    vim.keymap.set({ 'n', 'v' }, 's', '<Nop>', { silent = true })
    vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

    vim.keymap.del('n', 'gri')
    vim.keymap.del('n', 'grr')
    vim.keymap.del({ 'n', 'x' }, 'gra')
    vim.keymap.del('n', 'grn')

    nmap('U', '<C-r>', 'Redo')
    tmap('<C-\\>', [[<C-\><C-n>]], 'Exit terminal mode')

    nmap('<C-d>', '<C-d>zz', 'Move down half page')
    nmap('<C-u>', '<C-u>zz', 'Move up half page')
    nmap('*', '*zz', 'Find next occurrence under cursor')
    nmap('#', '#zz', 'Find previous occurrence under cursor')

    nmap(
        '<leader>x',
        [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
        'Search and replace in buffer',
        { silent = false }
    )

    -- Toggle quickfix window
    local toggle_quickfix = function()
        local quickfix_wins = vim.tbl_filter(
            function(win_id) return vim.fn.getwininfo(win_id)[1].quickfix == 1 end,
            vim.api.nvim_tabpage_list_wins(0)
        )

        local command = #quickfix_wins == 0 and 'copen' or 'cclose'
        vim.cmd(command)
    end

    nmap('<leader>q', toggle_quickfix, 'Toggle quickfix list')

    nmap('<leader>u', function()
        vim.cmd('UndotreeToggle')
        vim.cmd('UndotreeFocus')
    end, 'Toggle undo tree')

    -- COLEMAK Remaps
    local colemak_map = function(keys, cmd, opts)
        opts = opts or {}
        opts.noremap = true
        opts.silent = true
        vim.keymap.set({ 'n', 'x' }, keys, cmd, opts)
    end

    Config.colemak_toggle = function(state)
        if state then
            colemak_map('n', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
            colemak_map('e', [[v:count == 0 ? 'gk' : 'k']], { expr = true })
            colemak_map('m', 'h')
            colemak_map('i', 'l')
            colemak_map('h', 'm')
            colemak_map('j', 'e')
            colemak_map('k', 'nzz')
            colemak_map('l', 'i')
            colemak_map('N', 'mzJ`z')
            colemak_map('E', 'K')
            colemak_map('H', 'M')
            colemak_map('J', 'E')
            colemak_map('K', 'Nzz')
            colemak_map('L', 'I')
            colemak_map('<C-w>m', '<C-w>h')
            colemak_map('<C-w>n', '<C-w>j')
            colemak_map('<C-w>e', '<C-w>k')
            colemak_map('<C-w>i', '<C-w>l')
            colemak_map('<C-w>M', '<C-w>H')
            colemak_map('<C-w>N', '<C-w>J')
            colemak_map('<C-w>E', '<C-w>K')
            colemak_map('<C-w>I', '<C-w>L')

            colemak_map('M', '^', { desc = 'Goto first non-empty cell in line' })
            colemak_map('I', '$', { desc = 'Goto line end' })
        else
            colemak_map('j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
            colemak_map('k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })
            colemak_map('h', 'h')
            colemak_map('l', 'l')
            colemak_map('m', 'm')
            colemak_map('e', 'e')
            colemak_map('n', 'nzz')
            colemak_map('i', 'i')
            colemak_map('J', 'mzJ`z')
            colemak_map('K', 'K')
            colemak_map('M', 'M')
            colemak_map('E', 'E')
            colemak_map('N', 'Nzz')
            colemak_map('I', 'I')

            colemak_map('H', '^', { desc = 'Goto first non-empty cell in line' })
            colemak_map('L', '$', { desc = 'Goto line end' })
        end

        vim.g.colemak = state
    end

    Config.colemak_toggle(true)
end)
