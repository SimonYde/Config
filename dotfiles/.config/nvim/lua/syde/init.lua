require('syde.load')
require('syde.options')
require('syde.remap')
require('syde.colorscheme')

require('syde.plugin.mini')
require('syde.plugin.treesitter')
require('syde.plugin.completion')
require('syde.plugin.conform')
require('syde.plugin.lsp')

local nmap = Keymap.nmap
local imap = Keymap.imap

Load.later(function()
    Load.packadd('trouble.nvim')
    require('trouble').setup()

    nmap('<leader>td', function() vim.cmd('Trouble diagnostics toggle') end, 'Toggle trouble diagnostics')
end)

Load.on_events(function()
    require('nvim-autopairs').setup()
    require('cmp').event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done())
end, 'InsertEnter')

Load.later(function()
    Load.packadd('indent-blankline.nvim')
    local ibl = require('ibl')
    ibl.setup({
        indent = {
            char = '▏',
        },
        scope = {
            enabled = false,
        },
    })
    return ibl
end)

Load.later(function()
    Load.packadd('render-markdown.nvim')
    require('render-markdown').setup({
        callout = {
            definition = { raw = '[!definition]', rendered = ' Definition', highlight = 'RenderMarkdownInfo' },
            theorem = { raw = '[!theorem]', rendered = '󰨸 Theorem', highlight = 'RenderMarkdownHint' },
            proof = { raw = '[!proof]', rendered = '󰌶 Proof', highlight = 'RenderMarkdownWarn' },
        },
    })
end)

Load.later(function()
    Load.packadd('diffview.nvim')
    local diffview = require('diffview')
    diffview.setup()
    nmap('<leader>gd', function() diffview.open() end, 'git diffview')
end)

Load.later(function()
    Load.packadd('neogit')
    local neogit = require('neogit')
    neogit.setup({
        integrations = {
            diffview = true,
            telescope = true,
            mini_pick = true,
        },
    })
    nmap('<leader>gs', function() neogit.open() end, 'Neogit status')
    nmap('<leader>gw', function() neogit.open({ 'worktree' }) end, 'Neogit worktree')
    nmap('<leader>gc', function() neogit.open({ 'commit' }) end, 'Neogit commit')
end)

Load.later(function()
    local telescope = require('telescope')
    local actions = require('telescope.actions')
    local themes = require('telescope.themes')

    local preview = {
        show_line = false,
        layout_config = {
            preview_width = 0.55,
            prompt_position = 'top',
            horizontal = {
                height = 0.9,
                width = 0.9,
            },
        },
    }

    local no_preview = {
        layout_config = {
            prompt_position = 'top',
            horizontal = {
                height = 0.9,
                width = 0.9,
            },
        },
        show_line = false,
        previewer = false,
    }

    -- Dropdown list theme using a builtin theme definitions :
    local dropdown = themes.get_dropdown({
        width = 0.5,
        prompt = ' ',
        results_height = 15,
        previewer = false,
    })

    telescope.setup({
        pickers = {
            find_files = {
                -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
                find_command = { 'rg', '--files', '--hidden', '--glob', '!**/.git/*' },
            },
            buffers = {
                mappings = {
                    i = {
                        ['<c-x>'] = actions.delete_buffer, --+ actions.move_to_top,
                    },
                },
            },
        },
        defaults = {
            mappings = {
                i = {
                    ['<C-s>'] = actions.select_horizontal,
                },
            },
            -- `hidden = true` is not supported in text grep commands.
            file_ignore_patterns = {
                '__pycache__',
                'target',
                '.direnv',
                '.mypy_cache',
                '.ruff_cache',
                'node_modules',
                'undodir',
            },
            prompt_prefix = '  ',
            layout_config = {
                prompt_position = 'top',
            },
            sorting_strategy = 'ascending',
        },
        extensions = {
            fzf = {
                fuzzy = true,
                override_generic_sorter = true, -- override the generic sorter
                override_file_sorter = true, -- override the file sorter
                case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
            },
            ['ui-select'] = {
                dropdown,
            },
        },
    })

    Load.now(function() telescope.load_extension('fzf') end)
    Load.now(function() telescope.load_extension('ui-select') end)

    local builtin = require('telescope.builtin')
    nmap('<leader>?', builtin.keymaps, 'Search keymaps')
    nmap('<leader>b', function() builtin.buffers(preview) end, 'buffers')
    nmap('<leader>fc', function() builtin.current_buffer_fuzzy_find(no_preview) end, 'current buffer lines')
    nmap('<leader>ff', function() builtin.find_files(preview) end, 'Files')
    nmap('<leader>fh', function() builtin.help_tags(preview) end, 'Help tags')
    nmap('<leader>fg', function() builtin.git_files(preview) end, 'Git files')
    nmap('<leader>fb', function() builtin.builtin(preview) end, 'Builtin telescope pickers')
    nmap('<leader>fs', function() builtin.lsp_document_symbols(preview) end, 'LSP document symbols')
    nmap('<leader>fw', function() builtin.lsp_dynamic_workspace_symbols(preview) end, 'LSP workspace symbols')
    nmap('<leader>/', function() builtin.live_grep(preview) end, 'Global search with grep')
    nmap("<leader>'", function() builtin.resume() end, 'Resume last picker')
    nmap('gr', function() builtin.lsp_references(preview) end, 'Goto references (telescope)')
    nmap('gi', function() builtin.lsp_implementations(preview) end, 'Goto implementations (telescope)')
    nmap('gd', function() builtin.lsp_definitions(preview) end, 'Goto definitions (telescope)')
end)

Load.later(function()
    local whichkey = require('which-key')
    whichkey.setup({
        preset = 'classic',
        disable = {
            buftypes = { 'nofile', 'prompt', 'quickfix', 'terminal' }, -- nofile is for `cmdwin`. see `:h cmdwin`
        },
        triggers = {
            { '<auto>', mode = 'nixsotc' },
            { 's', mode = { 'n', 'v' } },
            { 'S', mode = { 'n', 'v' } },
        },
    })
    whichkey.add({
        { '<leader>w', proxy = '<c-w>', group = 'windows' },
        { '<leader>d', group = 'Debug' },
        { '<leader>f', group = 'Find' },
        { '<leader>m', group = 'Mini' },
        { '<leader>mb', group = 'Bufremove' },
        { '<leader>ms', group = 'Sessions' },
        { '<leader>v', group = 'Visits' },
        { '<leader>g', group = 'Git' },
        { '<leader>l', group = 'Lsp' },
        { '<leader>o', group = 'Obsidian' },
    })
end)

Load.later(function()
    require('lsp_signature').setup({
        doc_lines = 0,
        hint_enable = false,
        hint_inline = function() return false end, -- should the hint be inline(nvim 0.10 only)?  default false
        handler_opts = {
            border = 'none',
        },
    })
end)

Load.later(function()
    local otter = require('otter')
    otter.setup({
        lsp = {
            diagnostic_update_events = { 'BufWritePost' },
            root_dir = function(_) return vim.fn.getcwd(0) end,
        },
        buffers = {
            set_filetype = false,
            -- write <path>.otter.<embedded language extension> files to
            -- disk on save of main buffer.
            -- useful for some linters that require actual files
            -- otter files are deleted on quit or main buffer close
            write_to_disk = false,
        },
        strip_wrapping_quote_characters = { "'", '"', '`' },
        -- otter may not work the way you expect when entire code blocks are indented (eg. in Org files)
        -- When true, otter handles these cases fully.
        handle_leading_whitespace = true,
    })
    nmap('<leader>lo', function() otter.activate() end, 'Otter activate')
end)

Load.on_events(function()
    local lazydev = require('lazydev')
    lazydev.setup({
        runtime = vim.env.VIMRUNTIME,
        integrations = {
            lspconfig = true,
            cmp = true,
        },
        library = {
            { path = 'luvit-meta/library', words = { 'vim%.uv' } },
        },
    })
end, 'FileType', 'lua')

Load.later(function()
    Load.packadd('lspsaga.nvim')
    local lspsaga = require('lspsaga')
    lspsaga.setup({
        symbol_in_winbar = {
            enable = false,
        },
        code_action = {
            show_server_name = true,
        },
        lightbulb = {
            enable = false,
        },
        implement = {
            enable = true,
        },
        ui = {
            border = 'rounded',
        },
    })
end)

Load.later(function()
    local dap, dapui = require('dap'), require('dapui')
    local widgets = require('dap.ui.widgets')
    dapui.setup()
    dap.listeners.before.attach.dapui_config = function() dapui.open() end
    dap.listeners.before.launch.dapui_config = function() dapui.open() end
    dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
    dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

    vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'MiniIconsRed' })

    nmap('<leader>db', dap.toggle_breakpoint, 'toggle breakpoint')
    nmap('<leader>dc', dap.continue, 'continue')
    nmap('<leader>di', dap.step_into, 'step into')
    nmap('<leader>do', dap.step_over, 'step over')
    nmap('<leader>dO', dap.step_out, 'step Out')
    nmap('<leader>dr', dap.repl.open, 'open repl')
    nmap('<leader>dl', dap.run_last, 'run last')
    nmap('<leader>dh', widgets.hover, 'show hover')
    nmap('<leader>dp', widgets.preview, 'show preview')
    nmap('<leader>df', function() widgets.centered_float(widgets.frames) end, 'frames')
    nmap('<leader>ds', function() widgets.centered_float(widgets.scopes) end, 'scopes')
    nmap('<leader>du', dapui.toggle, 'toggle ui')
    nmap('<leader>d', function() require('which-key').show({ keys = '<leader>d', loop = true }) end, 'toggle ui')
end)

Load.later(function() require('dap-go').setup() end)

Load.later(function()
    require('dap-python').setup(PYTHON_PATH) -- PYTHON_PATH set by nix
end)

Load.later(function()
    require('obsidian').setup({
        ui = {
            enable = false,
        },
        workspaces = {
            {
                name = 'Apollo',
                path = '~/Obsidian/Apollo',
            },
        },
        notes_subdir = 'notes',
        new_notes_location = 'notes_subdir', -- NOTE: or "notes_subdir"
        completion = {
            nvim_cmp = true,
            min_chars = 2,
        },
        templates = {
            subdir = 'templates',
            date_format = '%Y-%m-%d-%a',
            time_format = '%H:%M',
        },
        daily_notes = {
            -- Optional, if you keep daily notes in a separate directory.
            folder = 'reviews/Daily Notes',
            -- Optional, if you want to change the date format for the ID of daily notes.
            date_format = '%Y-%m-%d',
            -- Optional, if you want to change the date format of the default alias of daily notes.
            alias_format = '%B %-d, %Y',
            -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
            template = 'templates/daily.md',
        },

        use_advanced_uri = true,
        disable_frontmatter = true,
        follow_url_func = function(url) vim.ui.open(url) end,
        follow_img_func = function(img) vim.fn.jobstart({ 'xdg-open', img }) end,

        attachments = {
            img_folder = 'attachments',
        },
    })

    nmap('<leader>oo', vim.cmd.ObsidianOpen, 'Open current file in Obsidian')
    nmap('<leader>od', vim.cmd.ObsidianDailies, 'Open daily note search')
    nmap('<leader>on', vim.cmd.ObsidianTemplate, 'Insert Obsidian template')
    nmap('<leader>ot', vim.cmd.ObsidianTags, 'Open tag list')
    nmap('<leader>op', vim.cmd.ObsidianPasteImg, 'Paste image')
    imap('<C-l>', vim.cmd.ObsidianToggleCheckbox, 'Toggle markdown checkbox')
end)

Load.later(function() require('todo-comments').setup() end)
