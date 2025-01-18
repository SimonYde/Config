require('syde.load')
require('syde.options')
require('syde.remap')
require('syde.colorscheme')

require('syde.plugin.mini')
require('syde.plugin.snacks')
require('syde.plugin.treesitter')
require('syde.plugin.lsp')
require('syde.plugin.completion')
-- DEBUG = true

local nmap = Keymap.nmap
local imap = Keymap.imap

Load.later(function()
    Load.packadd('trouble.nvim')
    require('trouble').setup()

    nmap('<leader>td', function() vim.cmd('Trouble diagnostics toggle') end, 'Toggle trouble diagnostics')
end)

Load.on_events(function() require('crates').setup() end, 'BufRead', 'Cargo.toml')

Load.later(function()
    local conform = require('conform')
    conform.setup({
        formatters_by_ft = {
            typst = { 'typstyle' },
            lua = { 'stylua' },
            nix = { 'nixfmt' },
            clojure = { 'cljfmt' },
            -- nu = { 'nufmt' },
        },
    })

    nmap(
        '<leader>=',
        function() conform.format({ stop_after_first = true, lsp_fallback = true }) end,
        'Format with conform'
    )
end)

Load.later(function()
    local ufo = require('ufo')
    local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (' 󰁂 %d '):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
            local chunkText = chunk[1]
            local chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if targetWidth > curWidth + chunkWidth then
                table.insert(newVirtText, chunk)
            else
                chunkText = truncate(chunkText, targetWidth - curWidth)
                local hlGroup = chunk[2]
                table.insert(newVirtText, { chunkText, hlGroup })
                chunkWidth = vim.fn.strdisplaywidth(chunkText)
                -- str width returned from truncate() may less than 2nd argument, need padding
                if curWidth + chunkWidth < targetWidth then
                    suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
                end
                break
            end
            curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, 'MoreMsg' })
        return newVirtText
    end

    ufo.setup({
        fold_virt_text_handler = handler,
        provider_selector = function(_, _, _) return { 'treesitter', 'indent' } end,
    })
    nmap('zR', ufo.openAllFolds, 'Open all folds (nvim-ufo)')
    nmap('zM', ufo.closeAllFolds, 'Close all folds (nvim-ufo)')
    vim.o.foldlevel = 500 -- NOTE: must be set high as to avoid auto-closing
    vim.g.ufo_foldlevel = 0
    nmap('zr', function()
        vim.g.ufo_foldlevel = vim.g.ufo_foldlevel + 1
        ufo.closeFoldsWith(vim.g.ufo_foldlevel)
    end, 'Open one fold level')
    nmap('zm', function()
        vim.g.ufo_foldlevel = math.max(vim.g.ufo_foldlevel - 1, 0)
        ufo.closeFoldsWith(vim.g.ufo_foldlevel)
    end, 'Close one fold level')
end)

Load.on_events(function() require('nvim-autopairs').setup() end, 'InsertEnter')

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
            vim.cmd.DiffviewClose()
            diffview_is_open = not diffview_is_open
        else
            vim.cmd.DiffviewOpen()
            diffview_is_open = not diffview_is_open
        end
    end, 'Toggle git diffview')
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
                find_command = { 'rg', '--files', '--hidden', '--glob', '!**/.git/*', '--glob', '!**/*.png' },
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
                horizontal = {
                    height = 0.9,
                    width = 0.9,
                },
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
    nmap('<leader>fc', builtin.current_buffer_fuzzy_find, 'current buffer lines')
    nmap('<leader>b', builtin.buffers, 'buffers')
    nmap('<leader>ff', builtin.find_files, 'Files')
    nmap('<leader>fh', builtin.help_tags, 'Help tags')
    -- nmap('<leader>fg', builtin.git_files, 'Git files')
    nmap('<leader>fg', require('syde.plugin.telescope.multigrep').live_multigrep, 'Live Multigrep')
    nmap('<leader>fb', builtin.builtin, 'Builtin telescope pickers')
    nmap('<leader>fs', builtin.lsp_document_symbols, 'LSP document symbols')
    nmap('<leader>fw', builtin.lsp_dynamic_workspace_symbols, 'LSP workspace symbols')
    nmap('<leader>/', builtin.live_grep, 'Global search with grep')
    nmap("<leader>'", builtin.resume, 'Resume last picker')
    nmap('gr', builtin.lsp_references, 'Goto references (telescope)')
    nmap('gi', builtin.lsp_implementations, 'Goto implementations (telescope)')
    nmap('gd', builtin.lsp_definitions, 'Goto definitions (telescope)')
end)

Load.later(function()
    local whichkey = require('which-key')
    whichkey.setup({
        preset = 'classic',
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
        { '<leader>l', group = 'Lsp' },
        { '<leader>o', group = 'Obsidian' },
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
    require('dap-python').setup(PYTHON_PATH) -- NOTE: PYTHON_PATH set by nix
end)

Load.on_events(function()
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
end, 'FileType', 'markdown')

Load.later(function()
    Load.packadd('todo-comments.nvim')
    require('todo-comments').setup()
end)

Load.later(function()
    do return end
    require('image').setup({
        backend = 'kitty',
        kitty_method = 'normal',
        processor = 'magick_rock',
        tmux_show_only_in_active_window = true, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
        integrations = {
            markdown = {
                enabled = true,
                clear_in_insert_mode = true,
                download_remote_images = true,
                only_render_image_at_cursor = true,
                filetypes = { 'markdown', 'vimwiki' }, -- markdown extensions (i.e. quarto) can go here
                resolve_image_path = function(document_path, image_path, fallback)
                    local image = image_path
                    if image_path:find('/') then
                        -- contains a path, so we handle it normally
                        return fallback(document_path, image)
                    end

                    -- Format image path for Obsidian notes
                    local working_dir = vim.fn.getcwd()

                    if image_path:find('|') then
                        -- Split off the image file name
                        image = vim.split(image_path, '|')[1]
                    end

                    local is_vault = working_dir:find('Obsidian/Apollo')
                    if is_vault then
                        -- Special handling of obsidian wiki links
                        return working_dir .. '/attachments/' .. image
                    end
                    -- Fallback to the default behaviour
                    return fallback(document_path, image)
                end,
            },
            typst = {
                only_render_image_at_cursor = true,
            },
        },
    })
end)

Load.later(function()
    Load.packadd('img-clip.nvim')
    require('img-clip').setup({
        default = {
            dir_path = 'attachments',
        },
    })
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

-- vim.cmd([[redraw]])
