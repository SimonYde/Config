Load.now(function()
    _G.dd = function(...) require('snacks.debug').inspect(...) end
    _G.bt = function() require('snacks.debug').backtrace() end
    _G.p = function(...) require('snacks.debug').profile(...) end
    vim.print = _G.dd

    require('snacks').setup({
        notifier = {},
        quickfile = {},
        picker = {},
        bufremove = {},
        toggle = {},
        terminal = {},
        zen = {},
        image = {},

        indent = {
            indent = { char = '▏' },
            scope = { enabled = false },
        },

        dashboard = {
            preset = {
                keys = {
                    {
                        icon = ' ',
                        key = 'f',
                        desc = 'Find File',
                        action = ":lua Snacks.dashboard.pick('files', {hidden = true})",
                    },
                    { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
                    {
                        icon = ' ',
                        key = 'g',
                        desc = 'Grep files',
                        action = ":lua Snacks.dashboard.pick('live_grep')",
                    },
                    {
                        icon = ' ',
                        key = 'r',
                        desc = 'Recent Files',
                        action = ":lua Snacks.dashboard.pick('oldfiles')",
                    },
                    {
                        icon = ' ',
                        key = 'c',
                        desc = 'Config',
                        action = ":lua Snacks.dashboard.pick('files', {cwd = vim.env.HOME .. '/Config', hidden = true})",
                    },

                    { icon = ' ', key = 's', desc = 'Restore Session', section = 'session' },
                    { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
                },
            },

            sections = {
                { section = 'header' },
                { section = 'keys', gap = 1, padding = 2 },
                { icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 2 },
                { icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 2 },
            },
        },

        bigfile = {
            notify = true, -- Show notification when big file detected
            size = 1024 * 1024, -- 1 MiB
            -- Enable or disable features when big file detected
            ---@param ctx {buf: number, ft:string}
            setup = function(ctx)
                Snacks.util.wo(0, { foldmethod = 'manual', statuscolumn = '', conceallevel = 0 })
                vim.b.minianimate_disable = true
                vim.b.minicursorword_disable = true
                vim.schedule(function() vim.bo[ctx.buf].syntax = ctx.ft end)
            end,
        },
    })
    -- Override plugin check, as the built-in version is `lazy.nvim` only. Assumes no lazy loading
    Snacks.dashboard.have_plugin = function(name) return package.loaded[name] ~= nil end
end)

Load.later(function()
    local nmap = Keymap.nmap
    vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesActionRename',
        callback = function(event) Snacks.rename.on_rename_file(event.data.from, event.data.to) end,
    })

    ---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
    local progress = vim.defaulttable()
    vim.api.nvim_create_autocmd('LspProgress', {
        ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
        callback = function(ev)
            local client = vim.lsp.get_client_by_id(ev.data.client_id)
            local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
            if not client or type(value) ~= 'table' then return end
            local p = progress[client.id]

            for i = 1, #p + 1 do
                if i == #p + 1 or p[i].token == ev.data.params.token then
                    p[i] = {
                        token = ev.data.params.token,
                        msg = ('[%3d%%] %s%s'):format(
                            value.kind == 'end' and 100 or value.percentage or 100,
                            value.title or '',
                            value.message and (' **%s**'):format(value.message) or ''
                        ),
                        done = value.kind == 'end',
                    }
                    break
                end
            end

            local msg = {} ---@type string[]
            progress[client.id] = vim.tbl_filter(function(v) return table.insert(msg, v.msg) or not v.done end, p)

            local spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
            vim.notify(table.concat(msg, '\n'), 'info', {
                id = 'lsp_progress',
                title = client.name,
                opts = function(notif)
                    notif.icon = #progress[client.id] == 0 and ''
                        or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
                end,
            })
        end,
    })

    Snacks.toggle
        .new({
            name = 'Folds',
            get = function() return vim.o.foldenable end,
            set = function(state) vim.o.foldenable = state end,
        })
        :map('<leader><leader>f')
    Snacks.toggle
        .new({
            name = 'hlsearch',
            get = function() return vim.v.hlsearch == 1 end,
            set = function(_) vim.cmd('let v:hlsearch = 1 - v:hlsearch') end,
        })
        :map('<leader><leader>h')
    Snacks.toggle
        .new({
            name = 'Colemak Keymap',
            get = function() return vim.g.colemak end,
            set = function(state) Config.colemak_toggle(state) end,
        })
        :map('<leader><leader>k')

    Snacks.toggle.line_number():map('<leader><leader>n')
    Snacks.toggle.diagnostics():map('<leader><leader>d')
    Snacks.toggle.inlay_hints():map('<leader>li')
    Snacks.toggle.option('spell'):map('<leader><leader>s')
    Snacks.toggle.option('wrap'):map('<leader><leader>w')
    Snacks.toggle.zen():map('<leader><leader>z')
    Snacks.toggle.option('ignorecase'):map('<leader><leader>c')
    Snacks.toggle.zoom():map('<leader>z')

    nmap('<leader>sn', Snacks.notifier.show_history, 'Show notifier history')
    nmap('<leader>st', Snacks.terminal.toggle, 'Toggle terminal')
    nmap('<leader>bd', Snacks.bufdelete.delete, 'Delete current buffer')

    nmap('<leader>gb', Snacks.git.blame_line, 'Show blame line')
    nmap('<leader>go', Snacks.gitbrowse.open, 'Open current position on remote repo')

    nmap('<leader>?', Snacks.picker.keymaps, 'Search keymaps')
    nmap('<leader>fc', Snacks.picker.lines, 'current buffer lines')
    nmap('<leader>bb', Snacks.picker.buffers, 'Pick buffers')
    ---@diagnostic disable-next-line: missing-fields
    nmap('<leader>ff', function() Snacks.picker.files({ hidden = true }) end, 'Files')
    nmap('<leader>fh', Snacks.picker.help, 'Help tags')
    nmap('<leader>fg', Snacks.picker.git_files, 'Git files')
    nmap('<leader>fb', Snacks.picker.pickers, 'Builtin pickers')
    nmap('<leader>fs', Snacks.picker.lsp_symbols, 'LSP document symbols')
    nmap('<leader>fw', Snacks.picker.lsp_workspace_symbols, 'LSP workspace symbols')
    ---@diagnostic disable-next-line: missing-fields
    nmap('<leader>/', function() Snacks.picker.grep({ hidden = true }) end, 'Global search with grep')
    nmap("<leader>'", Snacks.picker.resume, 'Resume last picker')
    nmap('<leader>*', function() Snacks.picker.grep_word({ hidden = true }) end, 'Grep word across files')
    nmap('gr', Snacks.picker.lsp_references, 'Goto references')
    nmap('gi', Snacks.picker.lsp_implementations, 'Goto implementations')
    nmap('gd', Snacks.picker.lsp_definitions, 'Goto definitions')

    nmap('<leader>gl', function() Snacks.lazygit.open() end, 'Open lazygit')
end)
