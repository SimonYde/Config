local nmap = require('syde.keymap').nmap

Load.later(function()
    local MiniExtra = require('mini.extra')

    require('mini.ai').setup { n_lines = 500 }
    require('mini.align').setup {}
    local MiniIcons = require('mini.icons')
    MiniIcons.setup {}
    MiniIcons.mock_nvim_web_devicons()
    -- MiniIcons.tweak_lsp_kind()

    require('mini.bracketed').setup { n_lines = 500 }
    nmap('U', '<C-r><Cmd>lua MiniBracketed.register_undo_state()<CR>', 'Redo')

    require('mini.bufremove').setup {}
    require('mini.comment').setup {}
    require('mini.cursorword').setup { delay = 100 }

    local hipatterns = require('mini.hipatterns')
    local hi_words = MiniExtra.gen_highlighter.words
    hipatterns.setup({
        highlighters = {
            -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
            -- fixme     = hi_words({ 'FIX', 'FIXME' }, 'MiniHipatternsFixme'),
            -- note      = hi_words({ 'NOTE' }, 'MiniHipatternsNote'),
            -- hack      = hi_words({ 'HACK' }, 'MiniHipatternsHack'),
            -- todo      = hi_words({ 'TODO' }, 'MiniHipatternsTodo'),

            -- Highlight hex color strings (`#9436FF`) using that color
            hex_color = hipatterns.gen_highlighter.hex_color(),
        },
    })
    require('mini.jump').setup {}
    require('mini.jump2d').setup {}
    require('mini.surround').setup {}
    require('mini.splitjoin').setup {}
    require('mini.move').setup {}

    require('mini.visits').setup {}
    require('mini.diff').setup()

    local make_select_path = function(select_global, recency_weight)
        return function()
            local cwd = select_global and '' or vim.fn.getcwd()
            -- visits.select_path(cwd, select_opts)
            MiniExtra.pickers.visit_paths({
                cwd = cwd,
                -- sort = sort,
                recency_weight = recency_weight,
            })
        end
    end

    local map = function(lhs, desc, ...)
        vim.keymap.set('n', lhs, make_select_path(...), { desc = desc })
    end

    -- Adjust LHS and description to your liking
    map('<Leader>vr', 'Select recent (all)', true, 1)
    map('<Leader>vR', 'Select recent (cwd)', false, 1)
    map('<Leader>vy', 'Select frecent (all)', true, 0.5)
    map('<Leader>vY', 'Select frecent (cwd)', false, 0.5)
    map('<Leader>vf', 'Select frequent (all)', true, 0)
    map('<Leader>vF', 'Select frequent (cwd)', false, 0)

    local MiniMisc = require('mini.misc')
    MiniMisc.setup()
    MiniMisc.setup_auto_root({ '.git', 'flake.nix', 'Makefile' })

    local MiniNotify = require('mini.notify')
    MiniNotify.setup {
        window = {
            config = {
                border = "rounded",
            },
            winblend = 0,
        },
    }
    vim.notify = MiniNotify.make_notify({ ERROR = { duration = 10000 } })

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
    nmap('<M-F>', function() MiniFiles.open(vim.api.nvim_buf_get_name(0)) end, "Show current [F]ile in explorer")
end)
