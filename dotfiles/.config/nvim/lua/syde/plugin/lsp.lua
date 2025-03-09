Load.later(function()
    local lspconfig = require('lspconfig')

    ---@param name string
    ---@param config { cmd: string[]?, settings: table?, on_attach: function?, filetypes: string[]?, capabilities: table? }?
    local setup_lsp = function(name, config)
        config = config or {}
        if vim.fn.executable(config.cmd and config.cmd[1] or name) ~= 1 then
            return -- LSP not installed, do not bother setting up
        end
        local default_capabilities = vim.lsp.protocol.make_client_capabilities()
        local capabilities = vim.tbl_deep_extend('force', default_capabilities, config.capabilities or {})

        local has_blink, blink = pcall(require, 'blink.cmp')
        if has_blink then capabilities = blink.get_lsp_capabilities(capabilities) end

        config.capabilities = capabilities
        lspconfig[name].setup(config)
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

    setup_lsp('lua_ls', {
        cmd = { 'lua-language-server' },
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
        on_attach = function(_, bufnr)
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

    setup_lsp('clojure_lsp')
    setup_lsp('elmls', {
        cmd = { 'elm-language-server' },
    })
    setup_lsp('nushell', {
        cmd = { 'nu', '--lsp' },
    })

    setup_lsp('ols', {
        init_options = {
            checker_args = '-debug',
        },
    })

    setup_lsp('metals', {
        filetypes = { 'java', 'scala', 'sbt' },
    })

    setup_lsp('basedpyright', {
        settings = {
            basedpyright = {
                disableOrganizeImports = true,
            },
        },
    })
    setup_lsp('ruff')

    setup_lsp('bashls', {
        cmd = { 'bash-language-server' },
        filetypes = { 'bash', 'sh' },
    })

    setup_lsp('clangd')
    setup_lsp('gleam')
    setup_lsp('gopls')
    setup_lsp('ocamllsp')

    setup_lsp('nixd', {
        settings = {
            nixd = {
                nixpkgs = {
                    expr = 'import <nixpkgs> { }',
                },
                options = {
                    nixos = {
                        expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.'
                            .. vim.uv.os_gethostname()
                            .. '.options',
                    },
                },
            },
        },
    })

    setup_lsp('texlab', {
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

    setup_lsp('nil_ls', {
        cmd = { 'nil' },
    })

    setup_lsp('tinymist', {
        settings = {
            exportPdf = 'onSave', -- Choose `onType`, `onSave` or `never`.
        },
        ---@param client vim.lsp.Client
        on_attach = function(client, bufnr)
            local nmap = function(keys, cmd, desc) Keymap.nmap(keys, cmd, desc, { buffer = bufnr }) end
            nmap('<leader>lp', function()
                local file = vim.api.nvim_buf_get_name(bufnr)
                local pdf = file:gsub('%.typ$', '.pdf')
                vim.system({ 'xdg-open', pdf })
            end, 'open [p]df')
            nmap('<leader>lw', function()
                local main_file = vim.api.nvim_buf_get_name(bufnr)
                ---@diagnostic disable-next-line: missing-fields the `title` argument is in fact not necessary.
                client:exec_cmd({ command = 'tinymist.pinMain', arguments = { main_file } })
                vim.notify('Pinned to ' .. main_file, vim.log.levels.INFO)
                local pdf = main_file:gsub('%.typ$', '.pdf')
                vim.system({ 'xdg-open', pdf })
            end, 'Pin main file to current')
        end,
    })

    setup_lsp('harper_ls', {
        cmd = { 'harper-ls' },
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
            nmap('<C-e>', vim.diagnostic.open_float, 'hover diagnostics')
            imap('<C-s>', vim.lsp.buf.signature_help, 'Signature Help')
            nmap('<leader>lf', vim.lsp.buf.format, 'LSP format')
            nmap('<leader>=', Config.format, 'Format code')

            Load.now(function()
                require('lspsaga')
                nmap('<leader>e', function() vim.cmd.Lspsaga('hover_doc') end, 'hover documentation')
                nmap('<leader>a', function() vim.cmd.Lspsaga('code_action') end, 'code actions')
                nmap('<leader>r', function() vim.cmd.Lspsaga('rename') end, 'LSP rename')
            end)
        end,
    })

    vim.defer_fn(function() vim.cmd('LspStart') end, 100)
end)
