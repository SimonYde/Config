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

    local MiniMisc = require('mini.misc')
    MiniMisc.setup()
    MiniMisc.setup_auto_root({ '.git', 'flake.nix', 'Makefile' })

    local MiniNotify = require('mini.notify')
    MiniNotify.setup {
        window = {
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
