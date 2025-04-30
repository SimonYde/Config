Load.later(function()
    Load.packadd('nvim-lspconfig')

    vim.lsp.config('basedpyright', {
        settings = {
            basedpyright = {
                disableOrganizeImports = true,
                analysis = {
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                    diagnosticMode = 'openFilesOnly',
                },
            },
        },
    })

    vim.lsp.config('harper_ls', {
        settings = {
            ['harper-ls'] = {
                dialect = 'British',
                userDictPath = vim.fn.stdpath('config') .. '/spell/en.utf-8.add',
                markdown = { ignore_link_title = true },
            },
        },
    })

    vim.lsp.config('lua_ls', {
        settings = {
            Lua = {
                telemetry = { enable = false },
                runtime = { version = 'LuaJIT' },

                workspace = {
                    checkThirdParty = false,
                    ignoreSubmodules = true,
                },
            },
        },
    })

    vim.lsp.config('nixd', {
        settings = {
            nixd = {
                nixpkgs = { expr = 'import <nixpkgs> { }' },

                options = {
                    nixos = {
                        expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.'
                            .. vim.uv.os_gethostname()
                            .. '.options',
                    },
                    home_manager = {
                        expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations.stub.options',
                    },
                },
            },
        },
    })

    vim.lsp.config('ols', {
        init_options = { checker_args = '-debug' },
    })

    vim.lsp.config('tinymist', {
        settings = { exportPdf = 'onSave' }, -- `onType`, `onSave` or `never`.
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

    vim.g.rustaceanvim = {
        -- LSP configuration
        server = {
            default_settings = {
                -- rust-analyzer language server configuration
                ['rust-analyzer'] = {
                    cargo = {
                        features = 'all',
                    },
                    imports = {
                        group = {
                            enable = false,
                        },
                    },
                },
            },
        },
    }

    vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            -- Disable semantic token highlighting, in favour of treesitter.
            if client then client.server_capabilities.semanticTokensProvider = nil end

            local nmap = function(keys, cmd, desc) Keymap.nmap(keys, cmd, desc, { buffer = args.buf }) end

            -- LSP commands
            nmap('<leader>ld', vim.lsp.buf.definition, 'definitions')
            nmap('<leader>lr', vim.lsp.buf.references, 'references')
            nmap('<leader>lf', vim.lsp.buf.format, 'LSP format')
            nmap('<leader>la', vim.lsp.buf.code_action, 'code actions')

            nmap('<C-h>', vim.diagnostic.open_float, 'hover diagnostics')

            nmap('<leader>h', function() vim.cmd.Lspsaga('hover_doc') end, 'hover documentation')
            nmap('<leader>a', function() vim.cmd.Lspsaga('code_action') end, 'code actions')
            nmap('<leader>r', function() vim.cmd.Lspsaga('rename') end, 'LSP rename')
        end,
    })

    vim.lsp.enable({
        'basedpyright',
        'bashls',
        'harper_ls',
        'lua_ls',
        'metals',
        'nil_ls',
        'nixd',
        'nushell',
        'ols',
        'ruff',
        'tinymist',
    })
end)
