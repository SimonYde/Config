Load.later(function()
    local lspconfig = require('lspconfig')

    ---@param lsp { name: string, cmd: string|table?, settings: table?, on_attach: function?, filetypes: string[]?, capabilities: table? }
    local function setup_lsp(lsp)
        if type(lsp.cmd) == 'table' then
            -- NOTE: this extra block is necessary
            if vim.fn.executable(lsp.cmd[1]) ~= 1 then
                return -- LSP not installed
            end
        elseif vim.fn.executable(lsp.cmd or lsp.name) ~= 1 then
            return -- LSP not installed
        end
        local config = {}
        local default_capabilities = vim.lsp.protocol.make_client_capabilities()
        local capabilities = vim.tbl_deep_extend('force', default_capabilities, lsp.capabilities or {})

        local blink = Load.now(require, 'blink.cmp')
        if blink then capabilities = blink.get_lsp_capabilities(capabilities) end

        -- NOTE: for nvim-ufo
        capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
        }
        config.capabilities = capabilities
        if lsp.settings then config.settings = lsp.settings end
        if lsp.on_attach then config.on_attach = lsp.on_attach end
        if lsp.filetypes then config.filetypes = lsp.filetypes end

        lspconfig[lsp.name].setup(config)
    end

    vim.g.rustaceanvim = {
        -- Plugin configuration
        tools = {
            enable_clippy = true,
        },
        -- LSP configuration
        server = {
            default_settings = {
                -- rust-analyzer language server configuration
                ['rust-analyzer'] = {
                    cargo = {
                        features = 'all',
                    },
                    -- completion = {
                    --     autoimport = true,
                    -- },
                    imports = {
                        group = {
                            enable = false,
                        },
                    },
                },
            },
        },
        -- DAP configuration
        dap = {},
    }

    setup_lsp({ name = 'clojure_lsp' })

    setup_lsp({
        name = 'elmls',
        cmd = 'elm-language-server',
    })
    setup_lsp({
        name = 'nushell',
        cmd = { 'nu', '--lsp' },
    })
    setup_lsp({
        name = 'metals',
        filetypes = { 'java', 'scala', 'sbt' },
    })

    setup_lsp({
        name = 'pylsp',
        settings = {
            pylsp = {
                plugins = {
                    -- black = { enabled = true },
                    mypy = { enabled = true },
                    ruff = { enabled = true },
                },
            },
        },
    })

    setup_lsp({
        name = 'basedpyright',
    })

    setup_lsp({
        name = 'bashls',
        cmd = 'bash-language-server',
        filetypes = { 'bash', 'sh' },
    })

    setup_lsp({ name = 'clangd' })
    setup_lsp({ name = 'gleam' })
    setup_lsp({ name = 'gopls' })
    setup_lsp({ name = 'ocamllsp' })

    setup_lsp({
        name = 'nixd',
        settings = {
            nixd = {
                nixpkgs = {
                    expr = 'import <nixpkgs> { }',
                },
                options = {
                    nixos = {
                        expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.perdix.options',
                    },
                    home_manager = {
                        expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations.perdix.options',
                    },
                },
            },
        },
    })

    setup_lsp({
        name = 'lua_ls',
        cmd = 'lua-language-server',
        settings = {
            Lua = {
                runtime = {
                    version = 'LuaJIT',
                },
                diagnostics = {
                    -- Don't make workspace diagnostic, as it consumes too much CPU and RAM
                    workspaceDelay = -1,
                },
                workspace = {
                    checkThirdParty = false,
                    -- Don't analyze code from submodules
                    ignoreSubmodules = true,
                },
                telemetry = { enable = false },
            },
        },
        on_attach = function(client, bufnr)
            -- Deal with the fact that LuaLS in case of `local a = function()` style
            -- treats both `a` and `function()` as definitions of `a`.
            local filter_line_locations = function(locations)
                local present, res = {}, {}
                for _, l in ipairs(locations) do
                    local t = present[l.filename] or {}
                    if not t[l.lnum] then
                        table.insert(res, l)
                        t[l.lnum] = true
                    end
                    present[l.filename] = t
                end
                return res
            end

            local show_location = function(location)
                local buf_id = location.bufnr or vim.fn.bufadd(location.filename)
                vim.bo[buf_id].buflisted = true
                vim.api.nvim_win_set_buf(0, buf_id)
                vim.api.nvim_win_set_cursor(0, { location.lnum, location.col - 1 })
                vim.cmd('normal! zv')
            end

            local unique_definition = function()
                local on_list = function(args)
                    local items = filter_line_locations(args.items)
                    if #items > 1 then
                        vim.fn.setqflist({}, ' ', { title = 'LSP locations', items = items })
                        vim.cmd('botright copen')
                        return
                    end
                    show_location(items[1])
                end
                vim.lsp.buf.definition({ on_list = on_list })
            end
            vim.keymap.set('n', '<Leader>ls', unique_definition, { buffer = bufnr, desc = 'Lua source definition' })
        end,
    })

    setup_lsp({
        name = 'texlab',
        settings = {
            texlab = {
                build = {
                    cmd = 'tectonic',
                    args = {
                        '-X',
                        'compile',
                        '%f',
                        -- "--synctex",
                        -- "--keep-logs",
                        -- "--keep-intermediates",
                    },
                    onSave = true,
                    forwardSearchAfter = true,
                },
                forwardSearch = {
                    cmd = 'zathura',
                    args = {
                        '--synctex-forward',
                        '%l:%c:%f',
                        '%p',
                    },
                },
            },
        },
    })

    setup_lsp({
        name = 'nil_ls',
        cmd = 'nil',
    })

    setup_lsp({
        name = 'tinymist',
        settings = {
            exportPdf = 'onSave', -- Choose `onType`, `onSave` or `never`.
        },
        ---@param client vim.lsp.Client
        on_attach = function(client, bufnr)
            local nmap = function(keys, cmd, desc) Keymap.nmap(keys, cmd, desc, { buffer = bufnr }) end
            nmap('<leader>lp', function()
                local file = vim.fn.expand('%')
                local pdf = file:gsub('%.typ$', '.pdf')
                vim.system({ 'xdg-open', pdf })
            end, 'open [p]df')
            nmap('<leader>lw', function()
                local main_file = vim.api.nvim_buf_get_name(bufnr)
                client:exec_cmd({ command = 'tinymist.pinMain', arguments = { main_file } })
                vim.notify('Pinned to ' .. main_file, vim.log.levels.INFO)
                local pdf = main_file:gsub('%.typ$', '.pdf')
                vim.system({ 'xdg-open', pdf }, {}, function(_) end)
            end, 'Pin main file to current')
        end,
    })

    setup_lsp({
        name = 'harper_ls',
        cmd = 'harper-ls',
        settings = {
            ['harper-ls'] = {
                userDictPath = vim.fn.stdpath('config') .. '/spell/en.utf-8.add',
                markdown = {
                    ignore_link_title = true,
                },
            },
        },
        filetypes = { 'markdown', 'gitcommit', 'jjdescription', 'typst' },
    })

    vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client then client.server_capabilities.semanticTokensProvider = nil end

            local nmap = function(keys, cmd, desc) Keymap.nmap(keys, cmd, desc, { buffer = args.buf }) end

            local imap = function(keys, cmd, desc) Keymap.imap(keys, cmd, desc, { buffer = args.buf }) end
            -- LSP commands
            nmap('<leader>r', vim.lsp.buf.rename, 'Rename')
            nmap('<leader>e', vim.lsp.buf.hover, 'hover documentation')
            nmap('<leader>a', vim.lsp.buf.code_action, 'code actions')
            nmap('<C-e>', vim.diagnostic.open_float, 'hover [d]iagnostics')
            imap('<C-s>', vim.lsp.buf.signature_help, 'Signature Help')

            Load.now(function()
                require('lspsaga')
                nmap('<leader>e', function() vim.cmd.Lspsaga('hover_doc') end, 'hover documentation')
                nmap('<leader>a', function() vim.cmd.Lspsaga('code_action') end, 'code [a]ctions')
                nmap('<leader>r', function() vim.cmd.Lspsaga('rename') end, 'LSP [r]ename')
            end)
        end,
    })

    vim.defer_fn(function() vim.cmd('LspStart') end, 100)
end)
