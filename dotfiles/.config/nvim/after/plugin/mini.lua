local nmap = require('syde.keymap').nmap
Load.now(function()
    require('mini.starter').setup {}
    vim.api.nvim_create_autocmd("User", {
        pattern = "MiniStarterOpened",
        callback = function()
            local buf = vim.api.nvim_get_current_buf()
            local buf_name = vim.api.nvim_buf_get_name(buf)
            if buf_name:match(vim.uv.cwd() .. "/Starter") then
                Colemak_toggle()
            end
        end,
    })
    vim.api.nvim_create_autocmd("BufReadPre", {
        callback = function()
            _G.COLEMAK = false
            Colemak_toggle()
        end,
    })
    require('mini.sessions').setup {}
end)

Load.later(function()
    require('mini.ai').setup { n_lines = 500 }
    require('mini.align').setup {}

    require('mini.bracketed').setup { n_lines = 500 }
    nmap('U', '<C-r><Cmd>lua MiniBracketed.register_undo_state()<CR>', 'Redo')

    require('mini.comment').setup {}
    require('mini.jump').setup {}
    require('mini.jump2d').setup {}
    require('mini.surround').setup {}
    require('mini.splitjoin').setup {}
    require('mini.move').setup {}
    require('mini.visits').setup {}

    local MiniNotify = require('mini.notify')
    MiniNotify.setup {
        window = {
            winblend = 0,
        },
    }
    vim.notify = MiniNotify.make_notify()

    local MiniTrailspace = require('mini.trailspace')
    MiniTrailspace.setup {}
    nmap(
        "<M-t>",
        function()
            MiniTrailspace.trim()
            MiniTrailspace.trim_last_lines()
        end,
        "Clean [t]railing whitespace"
    )

    local MiniFiles = require('mini.files')
    MiniFiles.setup {}
    nmap('<M-f>', function() MiniFiles.open() end, "Show [f]ile-tree")
    nmap('<M-F>', function() MiniFiles.open(vim.api.nvim_buf_get_name(0)) end, "Show current [F]ile in file-tree")
end)
