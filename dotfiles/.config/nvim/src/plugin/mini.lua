local nmap = Keymap.nmap
local nxmap = Keymap.map({ 'x', 'n' })

Load.now(function()
    require('mini.icons').setup({
        lsp = {
            ellipsis_char = { glyph = '…', hl = 'MiniIconsRed' },
            copilot       = { glyph = '', hl = 'MiniIconsOrange' },
            codeium       = { glyph = '', hl = 'MiniIconsGreen' },
            cody          = { glyph = '', hl = 'MiniIconsAzure' },
            supermaven    = { glyph = '', hl = 'MiniIconsYellow' },
            otter         = { glyph = '🦦', hl = 'MiniIconsCyan' },

            ["function"]  = { glyph = "󰊕", hl = 'MiniIconsAzure' },
            text          = { glyph = "󰉿", hl = 'MiniIconsRed' },
            method        = { glyph = "󰆧", hl = 'MiniIconsAzure' },
            constructor   = { glyph = "", hl = 'MiniIconsYellow' },
            field         = { glyph = "󰜢", hl = 'MiniIconsPurple' },
            variable      = { glyph = "󰀫", hl = 'MiniIconsBlue' },
            class         = { glyph = "󰠱", hl = 'MiniIconsYellow' },
            interface     = { glyph = "", hl = 'MiniIconsPurple' },
            module        = { glyph = "", hl = 'MiniIconsPurple' },
            property      = { glyph = "󰜢", hl = 'MiniIconsPurple' },
            unit          = { glyph = "󰑭", hl = 'MiniIconsCyan' },
            value         = { glyph = "󰎠", hl = 'MiniIconsRed' },
            enum          = { glyph = "", hl = 'MiniIconsPurple' },
            keyword       = { glyph = "󰌋", hl = 'MiniIconsPurple' },
            snippet       = { glyph = "", hl = 'MiniIconsCyan' },
            color         = { glyph = "󰏘", hl = 'MiniIconsCyan' },
            file          = { glyph = "󰈙", hl = 'MiniIconsYellow' },
            reference     = { glyph = "󰈇", hl = 'MiniIconsYellow' },
            folder        = { glyph = "󰉋", hl = 'MiniIconsAzure' },
            enumMember    = { glyph = "", hl = 'MiniIconsPurple' },
            constant      = { glyph = "󰏿", hl = 'MiniIconsOrange' },
            struct        = { glyph = "󰙅", hl = 'MiniIconsPurple' },
            event         = { glyph = "", hl = 'MiniIconsRed' },
            operator      = { glyph = "󰆕", hl = 'Normal' },
            typeParameter = { glyph = "", hl = 'MiniIconsYellow' },
        },
    })
    Load.later(MiniIcons.tweak_lsp_kind)
    MiniIcons.mock_nvim_web_devicons()
end)

Load.later(function()
    require('mini.files').setup({
        mappings = {
            close       = 'q',
            go_in       = 'i',
            go_in_plus  = 'I',
            go_out      = 'm',
            go_out_plus = 'M',
            mark_goto   = "'",
            mark_set    = 'h',
            reset       = '<BS>',
            reveal_cwd  = '@',
            show_help   = 'g?',
            synchronize = '=',
            trim_left   = '<',
            trim_right  = '>',
        },
    })
    nmap('<M-f>', function() MiniFiles.open() end, "Show [f]ile-tree")
    nmap('<M-F>', function()
        local file_name = vim.api.nvim_buf_get_name(0)
        if vim.uv.fs_stat(file_name) then
            MiniFiles.open(file_name)
        else
            vim.notify("Current buffer is not a file... opening mini.files in CWD", vim.log.levels.WARN)
            MiniFiles.open()
        end
    end, "Show current [F]ile in explorer")
end)

Load.later(function()
    require('mini.basics').setup({
        options = {
            basic = false,
        },
        mappings = {
            basic = true,
            option_toggle_prefix = [[<leader><leader>]],
        },
        autocommands = {
            -- Basic autocommands (highlight on yank, start Insert in terminal, ...)
            basic = false,
        },
    })
end)

Load.later(function() require('mini.extra').setup() end)

Load.later(function()
    Load.packadd('nvim-treesitter-textobjects')
    local spec_treesitter = require('mini.ai').gen_spec.treesitter
    local gen_ai_spec = MiniExtra.gen_ai_spec
    require('mini.ai').setup({
        n_lines = 500,
        custom_textobjects = {
            B = gen_ai_spec.buffer(),
            D = gen_ai_spec.diagnostic(),
            I = gen_ai_spec.indent(),
            L = gen_ai_spec.line(),
            N = gen_ai_spec.number(),
            F = spec_treesitter({
                a = '@function.outer',
                i = '@function.inner',
            }),
            o = spec_treesitter({
                a = { '@loop.outer' },
                i = { '@loop.inner' },
            }),
            c = spec_treesitter({
                a = { '@conditional.outer' },
                i = { '@conditional.inner' },
            }),
            v = spec_treesitter({
                a = { '@variable.outer' },
                i = { '@variable.inner' },
            }),
        },
    })
end)

Load.later(function() require('mini.align').setup() end)

Load.later(function()
    require('mini.bracketed').setup({ n_lines = 500 })
    nmap('U', '<C-r><Cmd>lua MiniBracketed.register_undo_state()<CR>', 'Redo')
end)


Load.later(function() require('mini.bufremove').setup() end)

Load.later(function() require('mini.comment').setup() end)

Load.later(function()
    require('mini.operators').setup({
        replace = {
            prefix = "cr"
        },
    })
end)

Load.later(function()
    require('mini.surround').setup({
        search_method = "cover_or_next",
    })
end)

Load.later(function() require('mini.cursorword').setup({ delay = 100 }) end)

Load.later(function()
    local hipatterns = require('mini.hipatterns')
    -- local hi_words = MiniExtra.gen_highlighter.words
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
end)

Load.later(function() require('mini.jump').setup() end)

Load.later(function()
    local MiniJump2d = require('mini.jump2d')
    MiniJump2d.setup({
        spotter = MiniJump2d.gen_pattern_spotter('[^%s%p]+'),
        view = {
            -- Whether to dim lines with at least one jump spot
            dim = true,

            -- How many steps ahead to show. Set to big number to show all steps.
            n_steps_ahead = 2,
        },
    })
end)

Load.later(function() require('mini.splitjoin').setup() end)

Load.later(function()
    local MiniMove = require('mini.move')
    MiniMove.setup({
        mappings = {
            -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
            left = '<M-m>',
            right = '<M-i>',
            down = '<M-n>',
            up = '<M-e>',

            -- Move current line in Normal mode
            line_left = '<M-m>',
            line_right = '<M-i>',
            line_down = '<M-n>',
            line_up = '<M-e>',
        },

        -- Options which control moving behavior
        options = {
            -- Automatically reindent selection during linewise vertical move
            reindent_linewise = true,
        },
    })
end)

Load.later(function()
    require('mini.diff').setup({
        mappings = {
            -- Apply hunks inside a visual/operator region
            apply = '<leader>ga',

            -- Reset hunks inside a visual/operator region
            reset = '<leader>gr',

            -- Hunk range textobject to be used inside operator
            -- Works also in Visual mode if mapping differs from apply and reset
            textobject = 'gh',

            -- Go to hunk range in corresponding direction
            goto_first = '[H',
            goto_prev = '[h',
            goto_next = ']h',
            goto_last = ']H',
        },
    })
end)

Load.later(function()
    require('mini.git').setup()
    nxmap("<leader>gg", MiniGit.show_at_cursor, "Show git info at cursor")
end)

Load.later(function()
    local MiniVisits = require('mini.visits')
    MiniVisits.setup()
    local make_select_path = function(select_global, recency_weight)
        return function()
            local cwd = select_global and '' or vim.fn.getcwd()
            local sort = MiniVisits.gen_sort.default({ recency_weight = recency_weight })
            local select_opts = { sort = sort }
            MiniVisits.select_path(cwd, select_opts)
            -- MiniExtra.pickers.visit_paths({
            --     cwd = cwd,
            --     -- sort = sort,
            --     recency_weight = recency_weight,
            -- })
        end
    end

    local visit_map = function(lhs, desc, ...)
        Keymap.nmap(lhs, make_select_path(...), desc)
    end

    -- Adjust LHS and description to your liking
    visit_map('<Leader>vr', 'Select recent (all)', true, 1)
    visit_map('<Leader>vR', 'Select recent (cwd)', false, 1)
    visit_map('<Leader>vy', 'Select frecent (all)', true, 0.5)
    visit_map('<Leader>vY', 'Select frecent (cwd)', false, 0.5)
    visit_map('<Leader>vf', 'Select frequent (all)', true, 0)
    visit_map('<Leader>vF', 'Select frequent (cwd)', false, 0)
end)

Load.later(function()
    require('mini.misc').setup()
    MiniMisc.setup_auto_root({ '.git', 'flake.nix', 'Makefile', 'Justfile' })
    MiniMisc.setup_termbg_sync()
end)

Load.later(function()
    local MiniNotify = require('mini.notify')
    MiniNotify.setup({
        window = {
            config = {
                border = "rounded",
            },
            winblend = 0,
        },
    })
    vim.notify = MiniNotify.make_notify({ ERROR = { duration = 10000 } })
end)


Load.later(function()
    local MiniTrailspace = require('mini.trailspace')
    require('mini.trailspace').setup()
    nmap(
        "<M-t>",
        function()
            MiniTrailspace.trim()
            MiniTrailspace.trim_last_lines()
        end,
        "Clean [t]railing whitespace"
    )
end)
