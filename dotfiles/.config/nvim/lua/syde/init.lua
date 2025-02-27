-- _G.DEBUG = true
require('syde.load')
require('syde.options')
require('syde.remap')
require('syde.colorscheme')

require('syde.plugin.mini')
require('syde.plugin.snacks')
require('syde.plugin.treesitter')
require('syde.plugin.completion')
require('syde.plugin.lsp')

local nmap = Keymap.nmap
local imap = Keymap.imap

Load.later(function()
    Load.packadd('trouble.nvim')
    require('trouble').setup()

    nmap('<leader>td', function() vim.cmd('Trouble diagnostics toggle') end, 'Toggle trouble diagnostics')
    nmap('<leader>tt', function() vim.cmd('Trouble todo toggle') end, 'Toggle trouble todos')
    nmap('<leader>tq', function() vim.cmd('Trouble qflist toggle') end, 'Toggle trouble quickfix')
end)

--- @diagnostic disable-next-line: missing-parameter
Load.on_events(function() require('crates').setup() end, 'BufRead', 'Cargo.toml')

Load.later(function()
    Load.packadd('conform.nvim')
    local conform = require('conform')
    conform.setup({
        formatters_by_ft = {
            typst = { 'typstyle' },
            lua = { 'stylua' },
            nix = { 'nixfmt' },
            clojure = { 'cljfmt' },
        },
    })
    Config.format = function() conform.format({ stop_after_first = true, lsp_fallback = true }) end
end)

Load.later(function()
    Load.packadd('nvim-ufo')
    _G.Ufo = require('ufo')

    --- @diagnostic disable: missing-fields
    Ufo.setup({
        open_fold_hl_timeout = 0,
        provider_selector = function(_, _, _) return { 'treesitter', 'indent' } end,
        --- @diagnostic disable: assign-type-mismatch
        close_fold_kinds_for_ft = {
            rust = {
                'function_item',
            },
        },
    })
    nmap('zR', Ufo.openAllFolds, 'Open all folds (nvim-ufo)')
    nmap('zM', Ufo.closeAllFolds, 'Close all folds (nvim-ufo)')
    vim.o.foldlevel = 500 -- NOTE: must be set high as to avoid auto-closing
    vim.g.ufo_foldlevel = 0
    nmap('zr', function()
        vim.g.ufo_foldlevel = vim.g.ufo_foldlevel + 1
        Ufo.closeFoldsWith(vim.g.ufo_foldlevel)
    end, 'Open one fold level')
    nmap('zm', function()
        vim.g.ufo_foldlevel = math.max(vim.g.ufo_foldlevel - 1, 0)
        Ufo.closeFoldsWith(vim.g.ufo_foldlevel)
    end, 'Close one fold level')
end)

Load.on_events(
    function()
        require('nvim-autopairs').setup({
            disable_filetype = { 'snacks_picker_input' },
        })
    end,
    'InsertEnter'
)

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
end)

Load.later(function()
    Load.packadd('diffview.nvim')
    local diffview = require('diffview')
    diffview.setup()
    local diffview_is_open = false
    nmap('<leader>gd', function()
        if diffview_is_open then
            diffview.close()
        else
            diffview.open()
        end
        diffview_is_open = not diffview_is_open
    end, 'Toggle git diffview')
end)

Load.later(function()
    Load.packadd('neogit')
    local neogit = require('neogit')
    neogit.setup({
        integrations = {
            diffview = true,
            telescope = false,
            mini_pick = false,
        },
    })
    nmap('<leader>gs', function() neogit.open() end, 'Neogit status')
    nmap('<leader>gw', function() neogit.open({ 'worktree' }) end, 'Neogit worktree')
    nmap('<leader>gc', function() neogit.open({ 'commit' }) end, 'Neogit commit')
end)

Load.later(function()
    local whichkey = require('which-key')
    whichkey.setup({
        preset = 'modern',
        disable = {
            buftypes = { 'nofile', 'prompt', 'quickfix', 'terminal' }, -- nofile is for `cmdwin`. see `:h cmdwin`
        },
        triggers = {
            { '<auto>', mode = 'nisotc' },
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
        { '<leader>mn', group = 'Notify' },
        { '<leader>ms', group = 'Sessions' },
        { '<leader>v', group = 'Visits' },
        { '<leader>g', group = 'Git' },
        { '<leader>s', group = 'Snacks' },
        { '<leader>l', group = 'Lsp' },
        { '<leader>o', group = 'Obsidian' },
    })
end)

Load.on_events(function()
    local lazydev = require('lazydev')
    --- @diagnostic disable: missing-fields
    lazydev.setup({
        runtime = vim.env.VIMRUNTIME,
        integrations = {
            lspconfig = true,
            cmp = false,
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

Load.later(function() require('dap-python').setup('python') end)

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
        new_notes_location = 'notes_subdir',
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

        use_advanced_uri = false,
        disable_frontmatter = true,
        follow_url_func = function(url) vim.ui.open(url) end,
        follow_img_func = function(img) vim.ui.open(img) end,

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

Load.later(function()
    Load.packadd('todo-comments.nvim')
    require('todo-comments').setup()
end)

Load.later(function()
    Load.packadd('img-clip.nvim')
    require('img-clip').setup()
end)

Load.later(function()
    Load.packadd('render-markdown.nvim')
    require('render-markdown').setup({
        callout = {
            definition = { raw = '[!definition]', rendered = ' Definition', highlight = 'RenderMarkdownInfo' },
            theorem = { raw = '[!theorem]', rendered = '󰨸 Theorem', highlight = 'RenderMarkdownHint' },
            proof = { raw = '[!proof]', rendered = '󰌶 Proof', highlight = 'RenderMarkdownWarn' },
            idea = { raw = '[!idea]', rendered = '󰌶 Idea', highlight = 'RenderMarkdownWarn' },
        },
    })
end)
