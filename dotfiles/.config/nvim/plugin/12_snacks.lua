Load.now(function()
    _G.dd = function(...) require('snacks.debug').inspect(...) end
    _G.bt = function() require('snacks.debug').backtrace() end
    _G.p = function(...) require('snacks.debug').profile(...) end
    vim.print = _G.dd

    require('snacks').setup({
        bufremove = {},
        image = {
            doc = { enabled = false },
            math = { enabled = false },
        },
        notifier = {},
        picker = {},
        quickfile = {},
        toggle = {},
        terminal = {},
        zen = { toggles = { dim = false } },

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
                        action = ":lua Snacks.dashboard.pick('files', {cwd = vim.env.NH_FLAKE, hidden = true})",
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
            ---@param ctx { buf: number, ft:string }
            setup = function(ctx)
                Snacks.util.wo(0, { foldmethod = 'manual', statuscolumn = '', conceallevel = 0 })
                vim.b.minianimate_disable = true
                vim.b.minicursorword_disable = true
                vim.schedule(function() vim.bo[ctx.buf].syntax = ctx.ft end)
            end,
        },
    })
    -- Override plugin check, as the built-in version is `lazy.nvim` only. Assumes no lazy loading of the given plugin.
    Snacks.dashboard.have_plugin = function(name) return package.loaded[name] ~= nil end
end)

Load.later(function()
    local nmap = Keymap.nmap

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

    Snacks.toggle.diagnostics():map('<leader><leader>d')
    Snacks.toggle.dim():map('<leader><leader>D')
    Snacks.toggle.inlay_hints():map('<leader>li')
    Snacks.toggle.line_number():map('<leader><leader>n')
    Snacks.toggle.zen():map('<leader><leader>z')
    Snacks.toggle.zoom():map('<leader>z')
    Snacks.toggle.indent():map('<leader><leader>i')

    Snacks.toggle.option('spell'):map('<leader><leader>s')
    Snacks.toggle.option('wrap'):map('<leader><leader>w')
    Snacks.toggle.option('ignorecase'):map('<leader><leader>c')
    Snacks.toggle.option('foldenable'):map('<leader><leader>f')

    -- stylua: ignore start
    nmap('<leader>sn', function() Snacks.notifier.show_history() end,             'Show notifier history')
    nmap('<leader>bd', function() Snacks.bufdelete.delete() end,                  'Delete current buffer')

    nmap('<leader>gb', function() Snacks.git.blame_line() end,                    'Show blame line')
    nmap('<leader>go', function() Snacks.gitbrowse.open() end,                    'Open current position on remote repo')

    nmap('<leader>?',  function() Snacks.picker.keymaps() end,                    'Search keymaps')
    nmap('<leader>fc', function() Snacks.picker.lines() end,                      'current buffer lines')
    nmap('<leader>bb', function() Snacks.picker.buffers() end,                    'Pick buffers')
    nmap('<leader>ff', function() Snacks.picker.files({ hidden = true }) end,     'Files')
    nmap('<leader>fh', function() Snacks.picker.help() end,                       'Help tags')
    nmap('<leader>fg', function() Snacks.picker.git_files() end,                  'Git files')
    nmap('<leader>fb', function() Snacks.picker.pickers() end,                    'Builtin pickers')
    nmap('<leader>fs', function() Snacks.picker.lsp_symbols() end,                'LSP document symbols')
    nmap('<leader>fw', function() Snacks.picker.lsp_workspace_symbols() end,      'LSP workspace symbols')
    nmap('<leader>/',  function() Snacks.picker.grep({ hidden = true }) end,      'Global search with grep')
    nmap("<leader>'",  function() Snacks.picker.resume() end,                     'Resume last picker')
    nmap('<leader>*',  function() Snacks.picker.grep_word({ hidden = true }) end, 'Grep word across files')
    nmap('gr',         function() Snacks.picker.lsp_references() end,             'Goto references')
    nmap('gi',         function() Snacks.picker.lsp_implementations() end,        'Goto implementations')
    nmap('gd',         function() Snacks.picker.lsp_definitions() end,            'Goto definitions')
    -- stylua: ignore end

    nmap('<leader>gl', function() Snacks.lazygit.open() end, 'Open lazygit')
    nmap('<leader>gj', function() Snacks.terminal.get("lazyjj") end, 'Open jazyjj')
end)
