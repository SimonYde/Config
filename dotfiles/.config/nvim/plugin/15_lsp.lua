Config.now_if_args(function()
    Config.packadd('nvim-lspconfig')

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
        filetypes = { 'typst', 'markdown', 'latex' },
        settings = {
            ['harper-ls'] = {
                -- dialect = 'British',
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
            end, 'Open PDF')

            nmap('<leader>lP', function()
                local file = vim.api.nvim_buf_get_name(bufnr)
                local pdf = file:gsub('%.typ$', '.pdf')
                vim.system({ 'polylux2pdfpc', file }):wait()
                vim.system({ 'pdfpc', pdf })
            end, 'Present')

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

    vim.lsp.config('rust-analyzer', {
        cmd = { 'rust-analyzer' },
        filetypes = { 'rust' },
        capabilities = {
            experimental = {
                commands = {
                    commands = {
                        'rust-analyzer.showReferences',
                        'rust-analyzer.runSingle',
                        'rust-analyzer.debugSingle',
                    },
                },
            },
        },
        settings = {
            ['rust-analyzer'] = {
                cargo = {
                    allFeatures = false,
                    loadOutDirsFromCheck = true,
                    runBuildScripts = true,
                },
                check = {
                    command = 'clippy',
                },
                diagnostics = {
                    enable = true,
                    -- experimental = {
                    --     enable = true,
                    -- },
                    styleLints = {
                        enable = true,
                    },
                    disabled = { 'inactive-code' },
                },
                hover = {
                    actions = {
                        enable = true,
                        references = {
                            enable = true,
                        },
                    },
                },
                imports = {
                    preferPrelude = true,
                    group = {
                        enable = true,
                    },
                },
                inlayHints = {
                    genericParameterHints = {
                        type = {
                            enable = false,
                        },
                    },
                },
                lens = {
                    enable = true,
                    implementations = { enable = true },
                    references = {
                        adt = { enable = true },
                        enumVariant = { enable = true },
                        method = { enable = true },
                        trait = { enable = true },
                    },
                    run = { enable = true },
                },

                procMacro = {
                    enable = true,
                },
            },
        },
    })

    vim.lsp.commands['rust-analyzer.runSingle'] = function(command)
        local r = command.arguments[1]
        local cmd = { 'cargo', unpack(r.args.cargoArgs) }
        if r.args.executableArgs and #r.args.executableArgs > 0 then
            vim.list_extend(cmd, { '--', unpack(r.args.executableArgs) })
        end

        local proc = vim.system(cmd, { cwd = r.args.cwd })

        local result = proc:wait()

        if result.code == 0 then
            vim.notify(result.stdout, vim.log.levels.INFO)
        else
            vim.notify(result.stderr, vim.log.levels.ERROR)
        end
    end

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
        'clangd',
        'harper_ls',
        'gopls',
        'lua_ls',
        'metals',
        'nil_ls',
        'nixd',
        'nushell',
        'ols',
        'ruff',
        'rust-analyzer',
        'tinymist',
        'ty',
        'typst-languagetool',
        'zls',
    })
end)
