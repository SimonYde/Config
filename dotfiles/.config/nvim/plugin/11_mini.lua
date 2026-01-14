local nmap, nxmap = Keymap.nmap, Keymap.nxmap

Load.now(function() require('mini.sessions').setup() end)

Load.now_if_args(function()
    require('mini.misc').setup()

    MiniMisc.setup_restore_cursor()

    MiniMisc.setup_auto_root({ '.git', '.jj', 'flake.nix', 'Makefile', 'Justfile' })
end)

Load.later(function()
    require('mini.align').setup()
    require('mini.bracketed').setup({ n_lines = 500 })
    require('mini.comment').setup()
    require('mini.cursorword').setup()
    require('mini.diff').setup()
    require('mini.extra').setup()
    require('mini.git').setup()
    require('mini.icons').setup()
    require('mini.jump').setup()

    require('mini.splitjoin').setup()
    require('mini.surround').setup()
    require('mini.tabline').setup()
    require('mini.trailspace').setup()
    require('mini.visits').setup()

    MiniIcons.mock_nvim_web_devicons()

    local remap = function(mode, lhs_from, lhs_to)
        local keymap = vim.fn.maparg(lhs_from, mode, false, true)
        local rhs = keymap.callback or keymap.rhs
        if rhs == nil then error('Could not remap from ' .. lhs_from .. ' to ' .. lhs_to) end
        vim.keymap.set(mode, lhs_to, rhs)
    end
    remap('n', 'gx', 'gX')
    remap('x', 'gx', 'gX')
    require('mini.operators').setup({ replace = { prefix = 'cr' } })

    require('mini.snippets').setup({
        snippets = {
            require('mini.snippets').gen_loader.from_file('~/.config/nvim/snippets/global.json'),
            require('mini.snippets').gen_loader.from_lang(),
        },
        mappings = {
            expand = '<C-e>',
            jump_next = '<C-i>',
            jump_prev = '<C-m>',
            stop = '<C-c>',
        },
    })

    require('mini.hipatterns').setup({
        highlighters = {
            -- Highlight hex color strings (`#9436FF`) using that color
            hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
        },
    })

    require('mini.jump2d').setup({
        spotter = require('mini.jump2d').gen_spotter.pattern('[^%s%p]+'),
        view = { dim = true, n_steps_ahead = 2 },
    })

    require('mini.move').setup({
        mappings = {
            -- Move visual selection in Visual mode. Use Colemak-DH keys.
            left = '<M-m>',
            down = '<M-n>',
            up = '<M-e>',
            right = '<M-i>',

            -- Move current line in Normal mode. Use Colemak-DH keys.
            line_left = '<M-m>',
            line_down = '<M-n>',
            line_up = '<M-e>',
            line_right = '<M-i>',
        },
    })

    local MiniStatusline = require('mini.statusline')

    local diagnostic_level = function(level)
        local n = #vim.diagnostic.get(0, { severity = level })
        local sign = vim.diagnostic.config().signs.text[level]
        return (n == 0) and '' or sign .. ' ' .. n
    end

    local section_macro_recording = function()
        local recording_register = vim.fn.reg_recording()

        if recording_register == '' then
            return ''
        else
            return ('rec @%s'):format(recording_register)
        end
    end

    MiniStatusline.setup({
        content = {
            active = function()
                local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
                local git = MiniStatusline.section_git({ trunc_width = 75 })
                local diff = MiniStatusline.section_diff({ trunc_width = 75 })
                local errors = diagnostic_level(vim.diagnostic.severity.ERROR)
                local warnings = diagnostic_level(vim.diagnostic.severity.WARN)
                local info = diagnostic_level(vim.diagnostic.severity.INFO)
                local hints = diagnostic_level(vim.diagnostic.severity.HINT)
                local filename = MiniStatusline.section_filename({ trunc_width = 160 })
                local macro = section_macro_recording()
                local searchcount = MiniStatusline.section_searchcount({ trunc_width = 75 })
                local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
                local location = MiniStatusline.section_location({ trunc_width = 75 })

                return MiniStatusline.combine_groups({
                    { hl = mode_hl, strings = { mode } },
                    { hl = 'MiniStatuslineDevinfo', strings = { git, diff } },
                    '%<', -- Mark general truncate point
                    { hl = 'MiniStatuslineFilename', strings = { filename } },
                    { hl = 'DiagnosticError', strings = { errors } },
                    { hl = 'DiagnosticWarn', strings = { warnings } },
                    { hl = 'DiagnosticHint', strings = { hints } },
                    { hl = 'DiagnosticInfo', strings = { info } },
                    '%=', -- End left alignment
                    { hl = 'DiagnosticError', strings = { macro } },
                    { hl = 'MiniStatuslineFilename', strings = { searchcount } },
                    { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
                    { hl = mode_hl, strings = { location } },
                })
            end,
        },
        set_vim_settings = false,
    })

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

    local yank_hunk = function() return MiniDiff.operator('yank') .. 'gh' end
    nmap('ghy', yank_hunk, "Copy hunk's reference lines", { expr = true, remap = true })

    nmap('U', '<C-r><Cmd>lua MiniBracketed.register_undo_state()<CR>', 'Redo')
    nmap('<M-t>', function()
        MiniTrailspace.trim()
        MiniTrailspace.trim_last_lines()
    end, 'Clean trailing whitespace')
    nxmap('<leader>gg', MiniGit.show_at_cursor, 'Show git info at cursor')

    local visit_map = function(lhs, select_global, recency_weight, desc)
        nmap(lhs, function()
            local cwd = select_global and '' or vim.fn.getcwd()
            local sort = MiniVisits.gen_sort.default({ recency_weight = recency_weight })
            MiniVisits.select_path(cwd, { sort = sort })
        end, desc)
    end

    -- Adjust LHS and description to your liking
    visit_map('<Leader>vr', true, 1, 'Select recent (all)')
    visit_map('<Leader>vR', false, 1, 'Select recent (cwd)')
    visit_map('<Leader>vy', true, 0.5, 'Select frecent (all)')
    visit_map('<Leader>vY', false, 0.5, 'Select frecent (cwd)')
    visit_map('<Leader>vf', true, 0, 'Select frequent (all)')
    visit_map('<Leader>vF', false, 0, 'Select frequent (cwd)')
end)
