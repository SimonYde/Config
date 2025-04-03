Load.later(function()
    vim.lsp.config('*', {
        capabilities = Load.now(function() return require('blink.cmp').get_lsp_capabilities({}, true) end) or {},
        root_markers = { '.git', '.jj', 'flake.nix' },
    })

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

    vim.lsp.config.lua_ls = {
        cmd = { 'lua-language-server' },
        filetypes = { 'lua' },
        root_markers = {
            '.luarc.json',
            '.luarc.jsonc',
        },
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
    }

    vim.lsp.config.basedpyright = {
        cmd = { 'basedpyright-langserver', '--stdio' },
        filetypes = { 'python' },
        root_markers = {
            'pyproject.toml',
            'setup.py',
            'setup.cfg',
            'requirements.txt',
            'Pipfile',
            'pyrightconfig.json',
        },
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
    }

    vim.lsp.config.bashls = {
        cmd = { 'bash-language-server' },
        filetypes = { 'bash', 'sh' },
    }

    vim.lsp.config.harper_ls = {
        cmd = { 'harper-ls', '--stdio' },
        filetypes = {
            'c',
            'cpp',
            'cs',
            'gitcommit',
            'go',
            'html',
            'java',
            'javascript',
            'lua',
            'markdown',
            'nix',
            'python',
            'ruby',
            'rust',
            'swift',
            'toml',
            'typescript',
            'typescriptreact',
            'haskell',
            'cmake',
            'typst',
            'php',
            'dart',
        },
        settings = {
            ['harper-ls'] = {
                userDictPath = vim.fn.stdpath('config') .. '/spell/en.utf-8.add',
                markdown = { ignore_link_title = true },
            },
        },
    }

    vim.lsp.config.metals = {
        cmd = { 'metals' },
        filetypes = { 'java', 'scala', 'sbt' },
        root_markers = { 'build.sbt', 'build.gradle' },
        init_options = {
            statusBarProvider = 'show-message',
            isHttpEnabled = true,
            compilerOptions = {
                snippetAutoIndent = false,
            },
        },
        capabilities = {
            workspace = {
                configuration = false,
            },
        },
    }

    vim.lsp.config.nil_ls = {
        cmd = { 'nil' },
        filetypes = { 'nix' },
    }

    vim.lsp.config.nixd = {
        cmd = { 'nixd' },
        filetypes = { 'nix' },
        settings = {
            nixd = {
                nixpkgs = { expr = 'import <nixpkgs> { }' },

                options = {
                    nixos = {
                        expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.'
                            .. vim.uv.os_gethostname()
                            .. '.options',
                    },
                },
            },
        },
    }

    vim.lsp.config.nushell = {
        cmd = { 'nu', '--lsp' },
        filetypes = { 'nu' },
    }

    vim.lsp.config.ols = {
        cmd = { 'ols' },
        filetypes = { 'odin' },
        root_markers = { 'ols.json' },
        init_options = { checker_args = '-debug' },
    }

    vim.lsp.config.ruff = {
        cmd = { 'ruff', 'server' },
        filetypes = { 'python' },
    }

    vim.lsp.config.tinymist = {
        cmd = { 'tinymist' },
        filetypes = { 'typst' },
        settings = { exportPdf = 'onSave' }, -- Choose `onType`, `onSave` or `never`.

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
    }

    vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client then client.server_capabilities.semanticTokensProvider = nil end

            local nmap = function(keys, cmd, desc) Keymap.nmap(keys, cmd, desc, { buffer = args.buf }) end
            local imap = function(keys, cmd, desc) Keymap.imap(keys, cmd, desc, { buffer = args.buf }) end

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
        'ruff',
        'tinymist',
    })
end)
