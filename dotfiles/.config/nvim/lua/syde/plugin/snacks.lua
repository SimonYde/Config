Load.now(function()
    _G.dd = function(...) require('snacks.debug').inspect(...) end
    _G.bt = function() require('snacks.debug').backtrace() end
    _G.p = function(...) require('snacks.debug').profile(...) end
    vim.print = _G.dd
end)

Load.now(function()
    require('snacks').setup({
        notifier = {
            enabled = true,
        },
        statuscolumn = {
            enabled = false,
        },
        quickfile = {},
        picker = {},
        toggle = {},
        zen = {},
        bigfile = {
            notify = true, -- show notification when big file detected
            size = 1024 * 1024, -- 1MB
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
end)

Load.later(function()
    local nmap = Keymap.nmap

    local picker = Snacks.picker
    nmap('<leader>?', picker.keymaps, 'Search keymaps')
    nmap('<leader>fc', picker.grep_buffers, 'current buffer lines')
    nmap('<leader>b', picker.buffers, 'buffers')
    nmap('<leader>ff', function() picker.files({ hidden = true }) end, 'Files')
    nmap('<leader>fh', picker.help, 'Help tags')
    nmap('<leader>fg', picker.git_files, 'Git files')
    nmap('<leader>fb', picker.pickers, 'Builtin pickers')
    nmap('<leader>fs', picker.lsp_symbols, 'LSP document symbols')
    nmap('<leader>fw', picker.lsp_workspace_symbols, 'LSP workspace symbols')
    nmap('<leader>/', function() picker.grep({ hidden = true }) end, 'Global search with grep')
    nmap("<leader>'", picker.resume, 'Resume last picker')
    nmap('gr', picker.lsp_references, 'Goto references')
    nmap('gi', picker.lsp_implementations, 'Goto implementations')
    nmap('gd', picker.lsp_definitions, 'Goto definitions')
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

    nmap('<leader>sn', Snacks.notifier.show_history, 'Show notifier history')
    nmap('<leader>gb', Snacks.git.blame_line, 'Show blame line')
    nmap('<leader>go', Snacks.gitbrowse.open, 'Open current position on remote repo')

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
            set = function(state) vim.cmd('let v:hlsearch = 1 - v:hlsearch') end,
        })
        :map('<leader><leader>h')
    Snacks.toggle
        .new({
            name = 'Colemak Keymap',
            get = function() return Config._colemak_enabled end,
            set = function(state) Config.colemak_toggle() end,
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
end)
