local nmap, imap = Keymap.nmap, Keymap.imap

Load.later(function()
    Load.packadd('blink.cmp')

    require('blink.cmp').setup({
        appearance = {
            use_nvim_cmp_as_default = true,
            nerd_font_variant = 'normal',
        },

        signature = { enabled = true },

        snippets = { preset = 'mini_snippets' },

        sources = {
            default = {
                'lsp',
                'path',

                'snippets',
                'buffer',
            },

            per_filetype = {
                lua = {
                    'lazydev',
                    'lsp',
                    'path',
                    'snippets',
                    'buffer',
                },
            },

            providers = {
                lazydev = {
                    name = 'LazyDev',
                    module = 'lazydev.integrations.blink',
                    -- Make lazydev completions top priority (see `:h blink.cmp`)
                    score_offset = 100,
                },
            },
        },
    })
end)

Load.later(function()
    Load.packadd('trouble.nvim')
    require('trouble').setup()

    nmap('<leader>td', function() vim.cmd.Trouble('diagnostics toggle') end, 'Toggle diagnostics')
    nmap('<leader>tt', function() vim.cmd.Trouble('todo toggle') end, 'Toggle todos')
    nmap('<leader>tq', function() vim.cmd.Trouble('qflist toggle') end, 'Toggle quickfix')
end)

Load.later(function()
    Load.packadd('yazi.nvim')
    local yazi = require('yazi')

    yazi.setup({
        open_for_directories = true,
        open_multiple_tabs = true,
        integrations = {
            grep_in_selected_files = 'snacks.picker',
            grep_in_directory = 'snacks.picker',
        },
    })

    nmap('<M-f>', function() vim.cmd.Yazi('cwd') end, 'Show `cwd` in Yazi')
    nmap('<M-F>', function() vim.cmd.Yazi() end, 'Show current file in Yazi')
end)

--- @diagnostic disable-next-line: missing-parameter
Load.on_events({ events = 'BufRead', pattern = 'Cargo.toml' }, function() require('crates').setup() end)

Load.later(function()
    Load.packadd('conform.nvim')
    local conform = require('conform')

    conform.setup({
        formatters_by_ft = {
            nu = { 'topiary_nu' },
            bash = { 'topiary_bash' },
            clojure = { 'cljfmt' },
            lua = { 'stylua' },
            nix = { 'nixfmt' },
            python = { 'ruff_format' },
            typst = { 'typstyle' },
        },

        formatters = {
            topiary_bash = {
                command = 'topiary',
                args = { 'format', '--language', 'bash' },
                env = {
                    TOPIARY_LANGUAGE_DIR = vim.env.TOPIARY_LANGUAGE_DIR,
                },
            },
            topiary_nu = {
                command = 'topiary',
                args = { 'format', '--language', 'nu' },
                env = {
                    TOPIARY_LANGUAGE_DIR = vim.env.TOPIARY_LANGUAGE_DIR,
                },
            },
        },
    })

    nmap('<leader>=', function() conform.format({ stop_after_first = true, lsp_fallback = true }) end, 'Format code')
end)

Load.on_events({ events = 'InsertEnter' }, function() require('nvim-autopairs').setup() end)

Load.later(function()
    Load.packadd('diffview.nvim')
    require('diffview').setup()

    nmap('<leader>gd', function()
        local call = vim.g.diffview_is_open and vim.cmd.DiffviewClose or vim.cmd.DiffviewOpen
        vim.g.diffview_is_open = not vim.g.diffview_is_open
        call()
    end, 'Toggle git diffview')
end)

Load.later(function()
    Load.packadd('neogit')
    require('neogit').setup({
        integrations = {
            diffview = true,
            telescope = false,
            mini_pick = false,
        },
    })

    nmap('<leader>gs', function() vim.cmd.Neogit() end, 'Neogit status')
    nmap('<leader>gw', function() vim.cmd.Neogit('worktree') end, 'Neogit worktree')
    nmap('<leader>gc', function() vim.cmd.Neogit('commit') end, 'Neogit commit')
end)

Load.later(function()
    Load.packadd('which-key.nvim')
    require('which-key').setup({
        preset = 'modern',
        disable = { buftypes = { 'nofile', 'prompt', 'quickfix', 'terminal' } },

        triggers = {
            { '<auto>', mode = 'nisotc' },
            { 's', mode = { 'n', 'v' } },
            { 'S', mode = { 'n', 'v' } },
        },
    })

    require('which-key').add({
        { 's', group = 'Surround' },
        { '<leader>d', group = 'Debug' },
        { '<leader>f', group = 'Find' },
        { '<leader>b', group = 'Buffers' },
        { '<leader>t', group = 'Trouble' },
        { '<leader>v', group = 'Visits' },
        { '<leader>g', group = 'Git' },
        { '<leader>s', group = 'Snacks' },
        { '<leader>l', group = 'Lsp' },
        { '<leader>o', group = 'Obsidian' },
    })
end)

Load.on_events({ events = 'FileType', pattern = 'lua' }, function()
    local lazydev = require('lazydev')
    --- @diagnostic disable-next-line: missing-fields
    lazydev.setup({
        integrations = {
            lspconfig = false,
            cmp = false,
        },

        library = {
            { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
            { path = 'wezterm-types', mods = { 'wezterm' } },
        },
    })
end)

Load.later(function()
    Load.packadd('lspsaga.nvim')
    require('lspsaga').setup({
        symbol_in_winbar = { enable = false },

        code_action = { show_server_name = true },

        lightbulb = { enable = false },

        implement = { enable = true },

        ui = { border = 'rounded' },
    })
end)

Load.later(function()
    Load.packadd('nvim-dap')
    Load.packadd('nvim-dap-ui')

    local dap, dapui = require('dap'), require('dapui')
    local widgets = require('dap.ui.widgets')

    dapui.setup()

    dap.listeners.before.attach.dapui_config = function() dapui.open() end
    dap.listeners.before.launch.dapui_config = function() dapui.open() end
    dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
    dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

    vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'MiniIconsRed' })

    nmap('<leader>db', function() dap.toggle_breakpoint() end, 'toggle breakpoint')
    nmap('<leader>dc', function() dap.continue() end, 'continue')
    nmap('<leader>di', function() dap.step_into() end, 'step into')
    nmap('<leader>do', function() dap.step_over() end, 'step over')
    nmap('<leader>dO', function() dap.step_out() end, 'step Out')
    nmap('<leader>dr', function() dap.repl.open() end, 'open repl')
    nmap('<leader>dl', function() dap.run_last() end, 'run last')
    nmap('<leader>dh', function() widgets.hover() end, 'show hover')
    nmap('<leader>dp', function() widgets.preview() end, 'show preview')
    nmap('<leader>df', function() widgets.centered_float(widgets.frames) end, 'frames')
    nmap('<leader>ds', function() widgets.centered_float(widgets.scopes) end, 'scopes')
    nmap('<leader>du', function() dapui.toggle() end, 'toggle ui')
    nmap(
        '<leader>dd',
        function() require('which-key').show({ keys = '<leader>d', loop = true }) end,
        'Keep debugging open'
    )
end)

Load.later(function()
    Load.packadd('render-markdown.nvim')
    require('render-markdown').setup({
        callout = {
            definition = { raw = '[!definition]', rendered = ' Definition', highlight = 'RenderMarkdownH6' },
            theorem = { raw = '[!theorem]', rendered = '󰨸 Theorem', highlight = 'RenderMarkdownHint' },
            proof = { raw = '[!proof]', rendered = '󰌶 Proof', highlight = 'RenderMarkdownH2' },
            idea = { raw = '[!idea]', rendered = '󰌶 Idea', highlight = 'RenderMarkdownWarn' },
        },
    })
end)

Load.later(function()
    require('obsidian').setup({
        disable_frontmatter = true,
        legacy_commands = false,

        new_notes_location = 'current_dir',

        follow_url_func = function(url) vim.ui.open(url) end,
        follow_img_func = function(img) vim.ui.open(img) end,

        attachments = { img_folder = 'attachments' },
        picker = { name = 'snacks.pick' },

        workspaces = {
            {
                name = 'Apollo',
                path = '~/Documents/Apollo',
            },
        },
        --- @diagnostic disable-next-line: missing-fields
        completion = {
            blink = true,
            nvim_cmp = false,
            min_chars = 2,
        },
        --- @diagnostic disable-next-line: missing-fields
        templates = {
            subdir = 'templates',
            date_format = '%Y-%m-%d',
            time_format = '%H:%M',
        },
        --- @diagnostic disable-next-line: missing-fields
        daily_notes = {
            -- Optional, if you keep daily notes in a separate directory.
            folder = '0. Periodic Notes/Daily',
            -- Optional, if you want to change the date format for the ID of daily notes.
            date_format = '%Y-%m-%d',
            -- Optional, if you want to change the date format of the default alias of daily notes.
            alias_format = '%B %-d, %Y',
            -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
            template = 'templates/daily.md',
        },
    })

    nmap('<leader>oo', function() vim.cmd.Obsidian('open') end, 'Open current file in Obsidian')
    nmap('<leader>od', function() vim.cmd.Obsidian('dailies') end, 'Open daily note search')
    nmap('<leader>on', function() vim.cmd.Obsidian('new_from_template') end, 'Insert Obsidian template')
    nmap('<leader>oq', function() vim.cmd.Obsidian('quick_switch') end, 'Quick switch')
    nmap('<leader>ot', function() vim.cmd.Obsidian('tags') end, 'Open tags list')
end)

Load.later(function()
    Load.packadd('indent-blankline.nvim')
    require('ibl').setup({
        indent = { char = '▏' },
        scope = { enabled = false },
    })
end)

Load.later(function()
    Load.packadd('todo-comments.nvim')
    require('todo-comments').setup({
        search = { pattern = [[\b(KEYWORDS)\b]] },
        highlight = { pattern = [[.*<(KEYWORDS).{-}:]] },
    })
end)

Load.later(function()
    Load.packadd('img-clip.nvim')
    require('img-clip').setup({ default = { dir_path = 'attachments' } })
end)
