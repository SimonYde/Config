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
    local nmap, tmap = Keymap.nmap, Keymap.tmap

    vim.keymap.set({ 'n', 'v' }, 's', '<Nop>', { silent = true })
    vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

    vim.keymap.del('n', 'gri')
    vim.keymap.del('n', 'grt')
    vim.keymap.del('n', 'grr')
    vim.keymap.del({ 'n', 'x' }, 'gra')
    vim.keymap.del('n', 'grn')

    nmap('U', '<C-r>', 'Redo')
    tmap('<C-,>', [[<C-\><C-n>]], 'Exit terminal mode')

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
end)
